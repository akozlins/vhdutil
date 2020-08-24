
MODULE_NAME := dmabuf

KDIR = /lib/modules/`uname -r`/build

all : .cache/Kbuild
	$(MAKE) -C $(KDIR) modules M=$(PWD)/.cache src=$(PWD) -E "MODULE_NAME := $(MODULE_NAME)"

clean : .cache/Kbuild
	$(MAKE) -C $(KDIR) clean M=$(PWD)/.cache src=$(PWD) -E "MODULE_NAME := $(MODULE_NAME)"

insmod : | all rmmod
	sudo insmod .cache/$(MODULE_NAME).ko

rmmod :
	sudo rmmod $(MODULE_NAME) || true

.cache/Kbuild : Kbuild
	mkdir -p .cache
	cp Kbuild .cache/
