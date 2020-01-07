
#include <linux/cdev.h>

#include <linux/aer.h>

struct bar_t {
    // bar address (iomap)
    void __iomem *ptr;
    size_t len;
    // char device
    struct cdev cdev;
};

struct dma_page {
    size_t size;
    void *cpu_addr;
    dma_addr_t dma_addr;
};

struct a10_pcie {
    struct pci_dev *pci_dev;
    struct bar_t bars[6];
    void __iomem *mm_cra;
    void __iomem *mm_dma;
    struct dma_page dma_page;
    int irq;
};
static struct a10_pcie a10_pcie;

#include "chrdev.h"

static
void irq_ack(void) {
    iowrite32(0x00, a10_pcie.mm_dma + 0x00); // dma.status = 0
    ioread32(a10_pcie.mm_dma + 0x00); // sync
}

static
irqreturn_t irq_handler(int irq, void *dev_id) {
    irq_ack();
    pr_info("[%s] irq_handler\n", DEVICE_NAME);

    dma_sync_single_for_cpu(&a10_pcie.pci_dev->dev, a10_pcie.dma_page.dma_addr, a10_pcie.dma_page.size, DMA_FROM_DEVICE);
    for(int i = 0; i < a10_pcie.dma_page.size;) {
        pr_info("[%s] %04X:", DEVICE_NAME, i);
        for(int j = 0; j < 8 && i < a10_pcie.dma_page.size; j++, i += 4) {
            u32 x = *(u32*)(a10_pcie.dma_page.cpu_addr + i);
            pr_cont(" %08X", x);
        }
        pr_cont("\n");
    }

    return IRQ_HANDLED;
}

static
void pcidev_fini(void) {
    // disable MSI
    iowrite32(0x00, a10_pcie.mm_cra + 0x50);
    // disable DMA irq
    iowrite32(0x00, a10_pcie.mm_dma + 0x18);
    ioread32(a10_pcie.mm_dma + 0x18); // sync
    // free irq
    if(a10_pcie.irq >= 0) free_irq(a10_pcie.irq, &a10_pcie.pci_dev->dev);
    pci_free_irq_vectors(a10_pcie.pci_dev);

    // free DMA buffer
    if(a10_pcie.dma_page.cpu_addr != NULL) {
        dma_free_coherent(&a10_pcie.pci_dev->dev, a10_pcie.dma_page.size, a10_pcie.dma_page.cpu_addr, a10_pcie.dma_page.dma_addr);
    }

    for(int i = 0; i < 6; i++) {
        if(a10_pcie.bars[i].ptr == NULL) continue;
        pci_iounmap(a10_pcie.pci_dev, a10_pcie.bars[i].ptr);

        device_destroy(chrdev.class, MKDEV(chrdev.major, i));
        if(a10_pcie.bars[i].cdev.dev) cdev_del(&a10_pcie.bars[i].cdev);
    }

    chrdev_fini();

    pci_release_regions(a10_pcie.pci_dev);

    pci_clear_master(a10_pcie.pci_dev);
    pci_disable_device(a10_pcie.pci_dev);
}

static
int pcidev_probe(struct pci_dev *pci_dev, const struct pci_device_id *id) {
    int err = 0;

    pr_info("[%s] probe\n", DEVICE_NAME);

    a10_pcie.pci_dev = pci_dev;

    err = pci_enable_device(a10_pcie.pci_dev);
    if(err) {
        dev_err(&a10_pcie.pci_dev->dev, "pci_enable_device\n");
        goto fail;
    }

    // enable AER
    err = pci_enable_pcie_error_reporting(a10_pcie.pci_dev);
    if(err) {
        dev_err(&a10_pcie.pci_dev->dev, "pci_enable_pcie_error_reporting\n");
//        goto fail;
    }

    // set bus master bit in PCI_COMMAND register
    // (enable device to act as master on the address bus)
    pci_set_master(a10_pcie.pci_dev);
    if(0) {
        u16 cmd;
        pci_read_config_word(a10_pcie.pci_dev, PCI_COMMAND, &cmd);
        pr_info("[%s] PCI_COMMAND = %04X\n", DEVICE_NAME, cmd);
    }

    err = chrdev_init();
    if(err) {
        goto fail;
    }

    err = pci_request_regions(a10_pcie.pci_dev, DEVICE_NAME);
    if(err) {
        dev_err(&a10_pcie.pci_dev->dev, "pci_request_regions\n");
        goto fail;
    }

    for(int i = 0; i < 6; i++) {
        struct device *device;

        // check bar is memory resource
        if(!(pci_resource_flags(a10_pcie.pci_dev, i) & IORESOURCE_MEM)) continue;

        // iomap bars
        a10_pcie.bars[i].ptr = pci_iomap(a10_pcie.pci_dev, i, pci_resource_len(a10_pcie.pci_dev, i));
        a10_pcie.bars[i].len = pci_resource_len(a10_pcie.pci_dev, i);
        pr_info("[%s] bars[%d].ptr = %px\n", DEVICE_NAME, i, a10_pcie.bars[i].ptr);
        pr_info("[%s] bars[%d].len = %ld\n", DEVICE_NAME, i, a10_pcie.bars[i].len);

        // create char device for this bar
        cdev_init(&a10_pcie.bars[i].cdev, &fops);
        a10_pcie.bars[i].cdev.owner = THIS_MODULE;

        // minor number mapping: 0 -> bar0, 1 -> bar1, etc.
        err = cdev_add(&a10_pcie.bars[i].cdev, MKDEV(chrdev.major, i), 1);
        if(err) {
            pr_warn("[%s] cdev_add() failed\n", DEVICE_NAME);
            a10_pcie.bars[i].cdev.dev = 0;
            goto fail;
        }

        device = device_create(chrdev.class, NULL, MKDEV(chrdev.major, i), NULL, DEVICE_NAME "_bar%d", i);
        if(IS_ERR(device)) {
            pr_warn("[%s] device_create() failed\n", DEVICE_NAME);
            err = PTR_ERR(device);
            goto fail;
        }
    }
    a10_pcie.mm_cra = a10_pcie.bars[2].ptr + 0x00010000;
    a10_pcie.mm_dma = a10_pcie.bars[2].ptr + 0x00020000;

    err = dma_set_mask_and_coherent(&a10_pcie.pci_dev->dev, DMA_BIT_MASK(32));
    if(err) {
        pr_warn("[%s] dma_set_mask() failed\n", DEVICE_NAME);
        goto fail;
    }

    // alloc DMA buffer
    a10_pcie.dma_page.size = 4096;
    a10_pcie.dma_page.cpu_addr = dma_alloc_coherent(&a10_pcie.pci_dev->dev, a10_pcie.dma_page.size, &a10_pcie.dma_page.dma_addr, 0);
    if(a10_pcie.dma_page.cpu_addr == NULL) {
        pr_warn("[%s] dma_alloc_coherent() failed\n", DEVICE_NAME);
        goto fail;
    }
    pr_info("[%s] cpu_addr = %px\n", DEVICE_NAME, a10_pcie.dma_page.cpu_addr);
    pr_info("[%s] dma_addr = %px\n", DEVICE_NAME, (void*)a10_pcie.dma_page.dma_addr);
    // set entry 0 of PCIe 'Address Translation Table'
    iowrite32(a10_pcie.dma_page.dma_addr, a10_pcie.mm_cra + 0x1000);



    // alloc irq
    err = pci_alloc_irq_vectors(a10_pcie.pci_dev, 1, 1, PCI_IRQ_MSI);
    if(err < 0) {
        pr_warn("[%s] pci_alloc_irq_vectors() failed\n", DEVICE_NAME);
        goto fail;
    }
    a10_pcie.irq = pci_irq_vector(a10_pcie.pci_dev, 0);
    if(a10_pcie.irq < 0) {
        pr_warn("[%s] pci_irq_vector() failed\n", DEVICE_NAME);
        goto fail;
    }
    err = request_irq(a10_pcie.irq, irq_handler, IRQF_SHARED, DEVICE_NAME "_irq0", &a10_pcie.pci_dev->dev);
    if(err < 0) {
        pr_warn("[%s] request_irq() failed\n", DEVICE_NAME);
        a10_pcie.irq = IRQ_NOTCONNECTED;
        goto fail;
    }
    // TODO : check DMA status
    // dma.control = QWORD | LEEN | I_EN | GO
    iowrite32((1 << 11) | (1 << 7) | (1 << 3), a10_pcie.mm_dma + 0x18);
    irq_ack();
    // enable DMA irq
    iowrite32((1 << 11) | (1 << 7) | (1 << 4) | (1 << 3), a10_pcie.mm_dma + 0x18);
    // enable MSI interrupt 0
    iowrite32(0x01, a10_pcie.mm_cra + 0x50);



    // start DMA
    iowrite32(0x00000000, a10_pcie.mm_dma + 0x04); // readaddress = RAM
    iowrite32(0x01000000, a10_pcie.mm_dma + 0x08); // writeaddress = TXS
    iowrite32(a10_pcie.dma_page.size, a10_pcie.mm_dma + 0x0C); // length



    return 0;
fail:
    pcidev_fini();
    return err;
}

static
void pcidev_remove(struct pci_dev *dev) {
    pr_info("[%s] remove\n", DEVICE_NAME);
    pcidev_fini();
}
