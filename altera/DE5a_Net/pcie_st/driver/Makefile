
ccflags-y := -std=gnu11 -Wall -g
KERNEL = /lib/modules/`uname -r`/build

obj-m += a10_pcie_st.o
a10_pcie_st-objs := module.o

all:
	make -C $(KERNEL) M=$(PWD) modules

clean:
	make -C $(KERNEL) M=$(PWD) clean
