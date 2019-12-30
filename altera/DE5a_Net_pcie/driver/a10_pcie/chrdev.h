
#include <linux/uaccess.h>

struct chrdev_t {
    dev_t dev;
    int major;
    struct class* class;
};
static struct chrdev_t chrdev;

static
int chrdev_open(struct inode* inode, struct file* file) {
    file->private_data = &bars[iminor(inode)];
    return 0;
}

static
ssize_t chrdev_read(struct file* file, char __user* user_buffer, size_t size, loff_t* offset) {
    ssize_t n = 0;
    struct bar_t* bar = file->private_data;

    pr_info("[%s] read(size = %ld, offset = %lld)\n", pci_name(pci_dev), size, *offset);

    while(n < size && *offset < bar->len) {
        u32 buffer = ioread32(bar->base + *offset);
        if(copy_to_user(user_buffer + n, (void*)&buffer, 4)) {
            return -EFAULT;
        }
        *offset += 4;
        n += 4;
    }

    return n;
}

static
struct file_operations fops = {
    .owner = THIS_MODULE,
    .open = chrdev_open,
    .read = chrdev_read,
};

static
void chrdev_fini(void) {
    if(chrdev.class) class_destroy(chrdev.class);
    if(chrdev.dev) unregister_chrdev_region(MKDEV(chrdev.major, 0), 1);
}

static
int chrdev_init(void) {
    int err = 0;

    err = alloc_chrdev_region(&chrdev.dev, 0, 6, DEVICE_NAME);
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

    return 0;

fail:
    chrdev_fini();
    return err;
}
