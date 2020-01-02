
#include <linux/cdev.h>

static struct pci_dev *pci_dev = NULL;

struct bar_t {
    // bar address (iomap)
    void __iomem *ptr;
    size_t len;
    // char device
    struct cdev cdev;
};
static struct bar_t bars[6];

#include "chrdev.h"

static
void pcidev_fini(void) {
    for(int i = 0; i < 6; i++) {
        if(bars[i].ptr == NULL) continue;
        pci_iounmap(pci_dev, bars[i].ptr);

        device_destroy(chrdev.class, MKDEV(chrdev.major, i));
        if(bars[i].cdev.dev) cdev_del(&bars[i].cdev);
    }

    pci_release_regions(pci_dev);

    chrdev_fini();

    pci_disable_device(pci_dev);
}

static
int pcidev_probe(struct pci_dev *dev, const struct pci_device_id *id) {
    int err = 0;

    pr_info("[%s] probe\n", DEVICE_NAME);

    pci_dev = dev;

    err = pci_enable_device(pci_dev);
    if(err) {
        dev_err(&pci_dev->dev, "pci_enable_device\n");
        goto fail;
    }

    err = chrdev_init();
    if(err) {
        goto fail;
    }

    err = pci_request_regions(pci_dev, DEVICE_NAME);
    if(err) {
        dev_err(&pci_dev->dev, "pci_request_regions\n");
        goto fail;
    }

    for(int i = 0; i < 6; i++) {
        struct device *device;

        // check bar is memory resource
        if(!(pci_resource_flags(pci_dev, i) & IORESOURCE_MEM)) continue;

        // iomap bars
        bars[i].ptr = pci_iomap(pci_dev, i, pci_resource_len(pci_dev, i));
        bars[i].len = pci_resource_len(pci_dev, i);
        pr_info("[%s] bars[%d].ptr = %px\n", DEVICE_NAME, i, bars[i].ptr);
        pr_info("[%s] bars[%d].len = %ld\n", DEVICE_NAME, i, bars[i].len);

        // create char device for this bar
        cdev_init(&bars[i].cdev, &fops);
        bars[i].cdev.owner = THIS_MODULE;

        // minor number mapping: 0 -> bar0, 1 -> bar1, etc.
        err = cdev_add(&bars[i].cdev, MKDEV(chrdev.major, i), 1);
        if(err) {
            pr_warn("[%s] cdev_add() failed\n", DEVICE_NAME);
            bars[i].cdev.dev = 0;
            goto fail;
        }

        device = device_create(chrdev.class, NULL, MKDEV(chrdev.major, i), NULL, DEVICE_NAME "_bar%d", i);
        if(IS_ERR(device)) {
            pr_warn("[%s] device_create() failed\n", DEVICE_NAME);
            err = PTR_ERR(device);
            goto fail;
        }
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
