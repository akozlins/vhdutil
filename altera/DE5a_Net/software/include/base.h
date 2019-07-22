/*
 * author : Alexandr Kozlinskiy
 * date : 2019
 */

#include <system.h>

#ifndef ALT_CPU_DCACHE_BYPASS_MASK
    #define ALT_CPU_DCACHE_BYPASS_MASK 0
#endif

#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

int uart = -1;

void uart_init() {
    uart = open(JTAG_UART_NAME, O_NONBLOCK);
    if(uart < 0) {
        printf("ERROR: can't open %s\n", JTAG_UART_NAME);
    }
}

char wait_key(useconds_t us = 100000) {
    while(true) {
        char cmd = 0;
        if(uart < 0) return cmd;
        if(read(uart, &cmd, 1) > 0) return cmd;
        usleep(us);
    }
}

#include <sys/alt_alarm.h>
#include <sys/alt_timestamp.h>

#include <altera_avalon_pio_regs.h>
#include <altera_avalon_spi.h>
