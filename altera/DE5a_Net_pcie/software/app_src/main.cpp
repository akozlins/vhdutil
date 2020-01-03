/*
 * author : Alexandr Kozlinskiy
 * date : 2019
 */

#include "../include/base.h"

#include "../include/a10/flash.h"
flash_t flash;

#include "../include/a10/fan.h"
fan_t fan;

#include "avalon_dma.h"
altera::avalon_dma_t dma(PCIE_DMA_BASE);

#include "pcie_a10.h"
altera::pcie_a10_t pcie(PCIE_CRA_BASE, PCIE_TXS_BASE);

int main() {
    base_init();

    fan.init();
    flash.init();
    dma.init();

    while (1) {
        printf("\n");
        printf("  [0] => flash\n");
        printf("  [1] => fan\n");
        printf("  [2] => dma\n");
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
        case '2':
            dma.menu();
            break;
        case '3':
            pcie.menu();
            break;
        default:
            printf("invalid command: '%c'\n", cmd);
        }
    }

    return 0;
}
