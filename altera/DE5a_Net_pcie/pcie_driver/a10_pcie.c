
#include <linux/module.h>

#include <linux/pci.h>

#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/uaccess.h>

MODULE_AUTHOR("Alexandr Kozlinskiy");
MODULE_LICENSE("GPL");

#define DEVICE_NAME "a10_pcie"
#define VENDOR_ID 0x1172
#define DEVICE_ID 0xE001

static struct pci_device_id id_table[] = {
    { PCI_DEVICE(VENDOR_ID, DEVICE_ID), },
    { 0, },
};
MODULE_DEVICE_TABLE(pci, id_table);

static struct pci_dev *pci_dev = NULL;
static void __iomem *mmio;

static int probe(struct pci_dev *dev, const struct pci_device_id *id) {
    pr_info("[%s] probe\n", DEVICE_NAME);

    pci_dev = dev;
    if (pci_enable_device(pci_dev) < 0) {
        dev_err(&(pci_dev->dev), "pci_enable_device\n");
        goto error;
    }
    if (pci_request_region(pci_dev, 0, "bar0")) {
        dev_err(&(pci_dev->dev), "pci_request_region\n");
        goto error;
    }

    mmio = pci_iomap(pci_dev, 0, pci_resource_len(pci_dev, 0));

    return 0;

error:
    return 1;
}

static void remove(struct pci_dev *dev) {
    pr_info("[%s] remove\n", DEVICE_NAME);

    pci_release_region(pci_dev, 0);
}

static struct pci_driver pci_driver = {
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

    if(pci_register_driver(&pci_driver) < 0) {
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
    cleanup();
}

module_init(myinit);
module_exit(myexit);
