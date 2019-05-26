
CC = riscv64-linux-gnu-gcc

CFLAGS += -march=rv32i -mabi=ilp32
CFLAGS += -nostdlib -Wl,--entry=main
CFLAGS += -Wl,--section-start=.text=0x0010
CFLAGS += -Wl,--build-id=none
CFLAGS += -O0

all : Makefile test
	riscv64-linux-gnu-objdump -M no-aliases -d test
	riscv64-linux-gnu-objcopy -O binary test test.bin
	xxd -c4 -e test.bin | awk '{print $$2}' > test.hex
