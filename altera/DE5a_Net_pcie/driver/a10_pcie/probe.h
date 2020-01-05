
#include <linux/cdev.h>

struct bar_t {
    // bar address (iomap)
    void __iomem *ptr;
    size_t len;
    // char device
    struct cdev cdev;
};

struct my_dma_addr_t {
    size_t size;
    void *cpu_addr;
    dma_addr_t dma_handle;
};
struct my_dma_addr_t dma_addr;

struct a10_pcie {
    struct pci_dev *pci_dev;
    struct bar_t bars[6];
    int irq;
};
static struct a10_pcie a10_pcie;

#include "chrdev.h"

static
void pcidev_fini(void) {
    if(a10_pcie.irq >= 0) free_irq(a10_pcie.irq, &a10_pcie.pci_dev->dev);
    pci_free_irq_vectors(a10_pcie.pci_dev);

    if(dma_addr.cpu_addr != NULL) {
        dma_free_coherent(&a10_pcie.pci_dev->dev, dma_addr.size, dma_addr.cpu_addr, dma_addr.dma_handle);
    }

    for(int i = 0; i < 6; i++) {
        if(a10_pcie.bars[i].ptr == NULL) continue;
        pci_iounmap(a10_pcie.pci_dev, a10_pcie.bars[i].ptr);

        device_destroy(chrdev.class, MKDEV(chrdev.major, i));
        if(a10_pcie.bars[i].cdev.dev) cdev_del(&a10_pcie.bars[i].cdev);
    }

    pci_release_regions(a10_pcie.pci_dev);

    chrdev_fini();

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

    // enables bus-mastering
    pci_set_master(a10_pcie.pci_dev);

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

    err = dma_set_mask_and_coherent(&a10_pcie.pci_dev->dev, DMA_BIT_MASK(32));
    if(err) {
        pr_warn("[%s] dma_set_mask() failed\n", DEVICE_NAME);
        goto fail;
    }

    dma_addr.size = 4096;
    dma_addr.cpu_addr = dma_alloc_coherent(&a10_pcie.pci_dev->dev, dma_addr.size, &dma_addr.dma_handle, 0);
    if(dma_addr.cpu_addr == NULL) {
        pr_warn("[%s] dma_alloc_coherent() failed\n", DEVICE_NAME);
        goto fail;
    }
    pr_info("[%s] cpu_addr = %px\n", DEVICE_NAME, dma_addr.cpu_addr);
    pr_info("[%s] dma_handle = %px\n", DEVICE_NAME, (void*)dma_addr.dma_handle);
    // set entry 0 of PCIe 'Address Translation Table'
    iowrite32(dma_addr.dma_handle, a10_pcie.bars[2].ptr + 0x00010000 + 0x1000);

    // write to DMA registers
    iowrite32(0x00000000, a10_pcie.bars[2].ptr + 0x00020000 + 0x04); // readaddress = RAM
    iowrite32(0x01000000, a10_pcie.bars[2].ptr + 0x00020000 + 0x08); // writeaddress = TXS
    iowrite32(dma_addr.size, a10_pcie.bars[2].ptr + 0x00020000 + 0x0C); // length
    for(int i = 0; i < 16; i++) {
        u32 status = ioread32(a10_pcie.bars[2].ptr + 0x00020000 + 0x00);
        pr_info("[%s] DMA.status = %08X\n", DEVICE_NAME, status); // status
        if((status & 0x02) == 0) break;
    }
    dma_sync_single_for_cpu(&a10_pcie.pci_dev->dev, dma_addr.dma_handle, dma_addr.size, DMA_FROM_DEVICE);
    for(int i = 0; i < dma_addr.size; i += 4) {
        u32 x = *(u32*)(dma_addr.cpu_addr + i);
        pr_info("[%s] *(cpu_addr + 0x%08X) = 0x%08X\n", DEVICE_NAME, i, x);
    }



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
