
#include <linux/cdev.h>

//#include <linux/dma-mapping.h>

#include <linux/aer.h>

struct bar_t {
    // bar address (iomap)
    void __iomem* ptr;
    size_t len;
    // char device
    struct cdev cdev;
};

struct dma_page {
    size_t size;
    void* cpu_addr;
    dma_addr_t dma_addr;
};

struct pcie_device {
    struct pci_dev* pci_dev;
    struct bar_t bars[6];
    void __iomem* mm_cra;
    void __iomem* mm_dma;
    struct dma_page dma_page;
    int irq;
};
static struct pcie_device pcie_device;

static
void irq_ack(void) {
}

static
irqreturn_t irq_handler(int irq, void* dev_id) {
    irq_ack();
    pr_info("[%s] irq_handler\n", DEVICE_NAME);

    return IRQ_HANDLED;
}

static
void pcidev_fini(void) {
    // free irq
    if(pcie_device.irq >= 0) free_irq(pcie_device.irq, &pcie_device.pci_dev->dev);
    pci_free_irq_vectors(pcie_device.pci_dev);

    // free DMA buffer
    if(pcie_device.dma_page.cpu_addr != NULL) {
        dma_free_coherent(&pcie_device.pci_dev->dev, pcie_device.dma_page.size, pcie_device.dma_page.cpu_addr, pcie_device.dma_page.dma_addr);
    }

    for(int i = 0; i < 6; i++) {
        if(pcie_device.bars[i].ptr == NULL) continue;
        pci_iounmap(pcie_device.pci_dev, pcie_device.bars[i].ptr);
    }

    pci_release_regions(pcie_device.pci_dev);

    pci_clear_master(pcie_device.pci_dev);
    pci_disable_device(pcie_device.pci_dev);
}

static
int pcidev_probe(struct pci_dev* pci_dev, const struct pci_device_id* id) {
    int err = 0;

    pr_info("[%s] probe\n", DEVICE_NAME);

    pcie_device.pci_dev = pci_dev;

    err = pci_enable_device(pcie_device.pci_dev);
    if(err) {
        dev_err(&pcie_device.pci_dev->dev, "pci_enable_device\n");
        goto fail;
    }

    // enable AER
    err = pci_enable_pcie_error_reporting(pcie_device.pci_dev);
    if(err) {
        dev_err(&pcie_device.pci_dev->dev, "pci_enable_pcie_error_reporting\n");
//        goto fail;
    }

    // set bus master bit in PCI_COMMAND register
    // (enable device to act as master on the address bus)
    pci_set_master(pcie_device.pci_dev);
    if(0) {
        u16 cmd;
        pci_read_config_word(pcie_device.pci_dev, PCI_COMMAND, &cmd);
        pr_info("[%s] PCI_COMMAND = %04X\n", DEVICE_NAME, cmd);
    }

    err = pci_request_regions(pcie_device.pci_dev, DEVICE_NAME);
    if(err) {
        dev_err(&pcie_device.pci_dev->dev, "pci_request_regions\n");
        goto fail;
    }

    for(int i = 0; i < 6; i++) {
        // check bar is memory resource
        if(!(pci_resource_flags(pcie_device.pci_dev, i) & IORESOURCE_MEM)) continue;

        // iomap bars
        pcie_device.bars[i].ptr = pci_iomap(pcie_device.pci_dev, i, pci_resource_len(pcie_device.pci_dev, i));
        pcie_device.bars[i].len = pci_resource_len(pcie_device.pci_dev, i);
        pr_info("[%s] bars[%d].ptr = %px\n", DEVICE_NAME, i, pcie_device.bars[i].ptr);
        pr_info("[%s] bars[%d].len = %ld\n", DEVICE_NAME, i, pcie_device.bars[i].len);
    }

    err = dma_set_mask_and_coherent(&pcie_device.pci_dev->dev, DMA_BIT_MASK(32));
    if(err) {
        pr_warn("[%s] dma_set_mask() failed\n", DEVICE_NAME);
        goto fail;
    }

    // alloc DMA buffer
    pcie_device.dma_page.size = 4096;
    pcie_device.dma_page.cpu_addr = dma_alloc_coherent(&pcie_device.pci_dev->dev, pcie_device.dma_page.size, &pcie_device.dma_page.dma_addr, 0);
    if(pcie_device.dma_page.cpu_addr == NULL) {
        pr_warn("[%s] dma_alloc_coherent() failed\n", DEVICE_NAME);
        goto fail;
    }
    pr_info("[%s] cpu_addr = %px\n", DEVICE_NAME, pcie_device.dma_page.cpu_addr);
    pr_info("[%s] dma_addr = %px\n", DEVICE_NAME, (void*)pcie_device.dma_page.dma_addr);



    // alloc irq
    err = pci_alloc_irq_vectors(pcie_device.pci_dev, 1, 1, PCI_IRQ_MSI);
    if(err < 0) {
        pr_warn("[%s] pci_alloc_irq_vectors() failed\n", DEVICE_NAME);
        goto fail;
    }
    pcie_device.irq = pci_irq_vector(pcie_device.pci_dev, 0);
    if(pcie_device.irq < 0) {
        pr_warn("[%s] pci_irq_vector() failed\n", DEVICE_NAME);
        goto fail;
    }
    err = request_irq(pcie_device.irq, irq_handler, IRQF_SHARED, DEVICE_NAME "_irq0", &pcie_device.pci_dev->dev);
    if(err < 0) {
        pr_warn("[%s] request_irq() failed\n", DEVICE_NAME);
        pcie_device.irq = IRQ_NOTCONNECTED;
        goto fail;
    }



    // test
    for(int i = 0; i < 4; i++) {
        ioread32(pcie_device.bars[0].ptr + 4*i);
    }
    for(int i = 0; i < 4; i++) {
        iowrite32(0xDEADBEEF, pcie_device.bars[0].ptr + 4*i);
    }



    return 0;
fail:
    pcidev_fini();
    return err;
}

static
void pcidev_remove(struct pci_dev* dev) {
    pr_info("[%s] remove\n", DEVICE_NAME);
    pcidev_fini();
}
