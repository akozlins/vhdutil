
#include <linux/module.h>

#include <linux/pci.h>

#include <linux/cdev.h>
#include <linux/uaccess.h>

MODULE_AUTHOR("Alexandr Kozlinskiy");
MODULE_LICENSE("GPL");

#define DEVICE_NAME "a10_pcie"
#define VENDOR_ID 0x1172
#define DEVICE_ID 0xE001

static
struct pci_device_id id_table[] = {
    { PCI_DEVICE(VENDOR_ID, DEVICE_ID), },
    { 0, },
};
MODULE_DEVICE_TABLE(pci, id_table);

static struct pci_dev *pci_dev = NULL;

struct bar_t {
    void __iomem *base;
};
static struct bar_t bars[6];

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

    return 0;

fail:
    return err;
}

static
void remove(struct pci_dev *dev) {
    pr_info("[%s] remove\n", DEVICE_NAME);

    pci_release_region(pci_dev, 0);
}

static
struct pci_driver pci_driver = {
    .name = DEVICE_NAME,
    .id_table = id_table,
    .probe = probe,
    .remove = remove,
};

static
void cleanup(void) {
    pci_unregister_driver(&pci_driver);
}

static
int __init myinit(void) {
    int err = 0;

    pr_info("[%s] init\n", DEVICE_NAME);

    if(pci_register_driver(&pci_driver) < 0) {
        pr_warn("[%s] pci_register_driver() failed\n", DEVICE_NAME);
        err = -EINVAL;
        goto fail;
    }

    return 0;

fail:
    cleanup();
    return err;
}

static
void __exit myexit(void) {
    pr_info("[%s] exit\n", DEVICE_NAME);
    cleanup();
}

module_init(myinit);
module_exit(myexit);
