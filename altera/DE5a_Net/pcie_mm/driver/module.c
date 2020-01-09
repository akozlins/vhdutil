
#include <linux/module.h>
#include <linux/pci.h>

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

#include "probe.h"

static
struct pci_driver pci_driver = {
    .name = DEVICE_NAME,
    .id_table = id_table,
    .probe = pcidev_probe,
    .remove = pcidev_remove,
};

static
int __init _module_init(void) {
    int err;

    pr_info("[%s] init\n", DEVICE_NAME);

    err = pci_register_driver(&pci_driver);
    if(err < 0) {
        pr_warn("[%s] pci_register_driver() failed\n", DEVICE_NAME);
        return err;
    }

    return 0;
}

static
void __exit _module_exit(void) {
    pr_info("[%s] exit\n", DEVICE_NAME);

    pci_unregister_driver(&pci_driver);
}

module_init(_module_init);
module_exit(_module_exit);
