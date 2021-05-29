
#include "include/base.h"

#include "include/si534x.h"
si534x_t si5342 { SPI_BASE, 0 };

void spi_do(int n, const alt_u8* tx, alt_u8* rx) {
    int tx_off = 0, rx_off = 0;

    auto base = (volatile alt_u32*)AVM_TEST_BASE;
    base[0] = 0x0010;

    while((base[0] & 0x00020000) == 0) rx[0] = base[1];

    while(tx_off < n or rx_off < n) {
        while((base[0] & 0x00010000) == 0 and tx_off < n) {
            base[1] = tx[tx_off];
            tx_off++;
        }
        if((base[0] & 0x00020000) == 0 and rx_off < n) {
            rx[rx_off] = base[1];
            rx_off++;
            continue;
        }
    }
}

int main() {
    base_init();

    while (1) {
        printf("\n");
        printf("[mu3e_fev_v1] -------- menu --------\n");
        printf("\n");
        printf("  [1] => si5342\n");
        printf("  [t] => test\n");

        printf("Select entry ...\n");
        char cmd = wait_key();
        switch(cmd) {
        case '1':
            si5342.menu();
            break;
        case 't': {
            //               Set   Addr  Read  Data
            alt_u8 tx[4] = { 0x00, 0x02, 0x80, 0x00 }, rx[4];
            spi_do(4, tx, rx);
            printf("rx = 0x%08X\n", rx[3]);

            break;
        }
        default:
            printf("invalid command: '%c'\n", cmd);
        }
    }

    return 0;
}
