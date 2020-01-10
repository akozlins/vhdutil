
MODULE_NAME := a10_pcie_st
BDF := 0000:`lspci -d 1172:e001 -mm | cut -d' ' -f1`

obj-m += $(MODULE_NAME).o
$(MODULE_NAME)-objs := module.o

ccflags-y := -std=gnu11 -Wall -g
KERNEL = /lib/modules/`uname -r`/build

all :
	make -C $(KERNEL) M=$(PWD) modules

clean :
	make -C $(KERNEL) M=$(PWD) clean

rescan :
	sudo rmmod $(MODULE_NAME) || true
	sudo ../util/rescan.sh $(BDF)

insmod : all
	sudo rmmod $(MODULE_NAME) || true
	sudo insmod ./$(MODULE_NAME).ko

rmmod :
	sudo rmmod $(MODULE_NAME) || true
