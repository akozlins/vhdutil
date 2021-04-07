/*
 * author : Alexandr Kozlinskiy
 * date : 2019
 */

#include "include/base.h"

#include "include/a10/flash.h"
flash_t flash;

#include "include/a10/fan.h"
fan_t fan(0x01);

int main() {
    base_init();

    fan.init();

    flash.init();

    while (1) {
        printf("  [1] => flash\n");
        printf("  [8] => fan\n");

        printf("Select entry ...\n");
        char cmd = wait_key();
        switch(cmd) {
        case '1':
            flash.menu();
            break;
        case '8':
            fan.menu();
            break;
        default:
            printf("invalid command: '%c'\n", cmd);
        }
    }

    return 0;
}
