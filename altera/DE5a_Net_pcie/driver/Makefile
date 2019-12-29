
ccflags-y := -std=gnu11 -Wall -g
KERNEL = /lib/modules/`uname -r`/build

obj-m += a10_pcie.o
a10_pcie-objs := a10_pcie/module.o

all:
	make -C $(KERNEL) M=$(PWD) modules

clean:
	make -C $(KERNEL) M=$(PWD) clean
