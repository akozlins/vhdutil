/*
 * author : Alexandr Kozlinskiy
 * date : 2019
 */

#include "../include/base.h"

#include "../include/a10/flash.h"
flash_t flash;

#include "../include/a10/fan.h"
fan_t fan;

int main() {
    base_init();

    fan.init();
    flash.init();

    while (1) {
        printf("\n");
        printf("  [0] => flash\n");
        printf("  [1] => fan\n");
        printf("  [3] => pcie\n");

        printf("Select entry ...\n");
        char cmd = wait_key();
        switch(cmd) {
        case '0':
            flash.menu();
            break;
        case '1':
            fan.menu();
            break;
        case '3':
            for(int i = 0; i < 64; i++) {
                printf("[pcie] [0x%02X] = 0x%08X\n", i, ((uint32_t*)AVM_PCIE_BASE)[i]);
            }
            break;
        default:
            printf("invalid command: '%c'\n", cmd);
        }
    }

    return 0;
}
