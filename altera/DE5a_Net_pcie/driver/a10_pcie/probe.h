
static struct pci_dev *pci_dev = NULL;

struct bar_t {
    void __iomem *base;
};
static struct bar_t bars[6];

#include "chrdev.h"

static
int probe(struct pci_dev *dev, const struct pci_device_id *id) {
    int err = 0;

    pr_info("[%s] probe\n", DEVICE_NAME);

    pci_dev = dev;

    err = pci_enable_device(pci_dev);
    if(err < 0) {
        dev_err(&(pci_dev->dev), "pci_enable_device\n");
        goto fail;
    }

    err = pci_request_region(pci_dev, 0, "bar0");
    if(err) {
        dev_err(&(pci_dev->dev), "pci_request_region\n");
        goto fail;
    }
    bars[0].base = pci_iomap(pci_dev, 0, pci_resource_len(pci_dev, 0));
    pr_info("[%s] bars[%d].base = %p\n", DEVICE_NAME, 0, bars[0].base);

    chrdev_init();

    return 0;

fail:
    return err;
}

static
void remove(struct pci_dev *dev) {
    pr_info("[%s] remove\n", DEVICE_NAME);

    chrdev_fini();

    if(bars[0].base) pci_iounmap(pci_dev, bars[0].base);
    pci_release_region(pci_dev, 0);

    pci_disable_device(pci_dev);
}
