/*
 * author : Alexandr Kozlinskiy
 * date : 2019
 */

#include "../include/base.h"

#include "../include/i2c.h"
i2c_t i2c;

#include "../include/a10/fan.h"
fan_t fan;

#include "../include/a10/cfi1616.h"
cfi1616_t flash;

volatile alt_u32* ctrl = (alt_u32*)(CTRL_REGION_BASE);
volatile alt_u8* data = (alt_u8*)(DATA_REGION_BASE);

alt_u32 hist_ts[16];

alt_u32 hibit(alt_u32 n) {
    if(n == 0) return 0;
    alt_u32 r = 0;
    if(n & 0xFFFF0000) { r += 16; n >>= 16; };
    if(n & 0xFF00) { r += 8; n >>= 8; };
    if(n & 0xF0) { r += 4; n >>= 4; };
    if(n & 8) return r + 3;
    if(n & 4) return r + 2;
    if(n & 2) return r + 1;
    return 0;
}

const alt_u32 TS_UFREQ = TIMER_TS_FREQ / 1000000;

alt_u32 alarm_callback(void*) {
    IOWR_ALTERA_AVALON_PIO_CLEAR_BITS(PIO_BASE, 0xFF);
    // watchdog
    IOWR_ALTERA_AVALON_PIO_SET_BITS(PIO_BASE, alt_nticks() & 0xFF);

    alt_timestamp_start();
    int state = flash.callback((alt_u8*)IORD(ctrl, 0), data, (alt_u32)IORD(ctrl, 1));
    alt_u32 ts_bin = hibit(alt_timestamp() / TS_UFREQ);
    if(ts_bin < 16) hist_ts[ts_bin]++;
    if(state == -EAGAIN) return 1;
    if(state == 0) {
        IOWR(ctrl, 0, 0);
        IOWR(ctrl, 1, 0);
    }

    return 10;
}

int main() {
    uart_init();

    printf("ALT_DEVICE_FAMILY = '%s'\n", ALT_DEVICE_FAMILY);
    printf("\n");

    fan.init();

    if(flash.init((alt_u8*)(FLASH_BASE)) != 0) printf("ERROR: flash init failed\n");

    alt_alarm alarm;
    int err = alt_alarm_start(&alarm, 10, alarm_callback, nullptr);
    if(err) {
        printf("ERROR: alt_alarm_start => %d\n", err);
    }

    while (1) {
        printf("Command:\n");
        printf("  [-] => continue\n");

        printf("Select entry ...\n");
        char cmd = wait_key();
        switch(cmd) {
        case 'q':
            break;
        default:
            printf("invalid command: '%c'\n", cmd);
        }
    }

    return 0;
}
