
#include <linux/cdev.h>
#include <linux/uaccess.h>

struct chrdev_t {
    dev_t dev;
    int major;
    struct class* class;
    struct cdev cdev;
    struct device *device;
};
static struct chrdev_t chrdev;

static
ssize_t read(struct file* file, char __user* user_buffer, size_t size, loff_t* offset) {
    ssize_t n = 0;
    size_t len = pci_resource_len(pci_dev, 0);

    pr_info("[%s] read(size = %ld, offset = %lld)\n", DEVICE_NAME, size, *offset);

    while(n < size && *offset < len) {
        u32 buffer = ioread32(bars[0].base + *offset);
        if(copy_to_user(user_buffer + *offset, (void*)&buffer, 4)) {
            return -EFAULT;
        }
        n += 4;
        *offset += 4;
    }

    return n;
}

static
struct file_operations fops = {
    .owner = THIS_MODULE,
    .read = read,
};

static
void chrdev_fini(void) {
    if(chrdev.device) device_destroy(chrdev.class, MKDEV(chrdev.major, 0));
    if(chrdev.cdev.dev) cdev_del(&chrdev.cdev);
    if(chrdev.class) class_destroy(chrdev.class);
    if(chrdev.dev) unregister_chrdev_region(MKDEV(chrdev.major, 0), 1);
}

static
int chrdev_init(void) {
    int err = 0;

    err = alloc_chrdev_region(&chrdev.dev, 0, 1, DEVICE_NAME);
    if(err < 0) {
        pr_warn("[%s] alloc_chrdev_region() failed\n", DEVICE_NAME);
        chrdev.dev = 0;
        goto fail;
    }
    chrdev.major = MAJOR(chrdev.dev);

    chrdev.class = class_create(THIS_MODULE, DEVICE_NAME);
    if(IS_ERR(chrdev.class)) {
        err = PTR_ERR(chrdev.class);
        chrdev.class = 0;
        goto fail;
    }

    cdev_init(&chrdev.cdev, &fops);
    chrdev.cdev.owner = THIS_MODULE;

    err = cdev_add(&chrdev.cdev, MKDEV(chrdev.major, 0), 1);
    if(err) {
        pr_warn("[%s] cdev_add() failed\n", DEVICE_NAME);
        chrdev.cdev.dev = 0;
        goto fail;
    }

    chrdev.device = device_create(chrdev.class, NULL, MKDEV(chrdev.major, 0), NULL, DEVICE_NAME "%d", 0);
    if(IS_ERR(chrdev.device)) {
        pr_warn("[%s] device_create() failed\n", DEVICE_NAME);
        err = PTR_ERR(chrdev.device);
        chrdev.device = NULL;
        goto fail;
    }

    return 0;

fail:
    chrdev_fini();
    return err;
}
