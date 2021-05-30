
#include "include/base.h"

#include "include/si534x.h"
si534x_t si5342 { SPI_BASE, 0 };

#include <sys/alt_irq.h>

struct avalon_spi_master_t {
    volatile alt_u32* base = (alt_u32*)AVM_TEST_BASE;

    static const alt_u32 WFULL = 0x00000001;
    static const alt_u32 REMPTY = 0x00000100;

    void spi_do(int ss, int n, const alt_u8* tx, alt_u8* rx) {
        base[1] = ss;
        base[3] = (base[3] & 0xFFFF0000) | 0x0010;

        // clean rx fifo
        while((base[2] & REMPTY) == 0) rx[0] = base[1];

        alt_irq_context irq_context = alt_irq_disable_all();
        for(int tx_off = 0, rx_off = 0; tx_off < n or rx_off < n;) {
            // write
            while((base[2] & WFULL) == 0 and tx_off < n) {
                base[0] = tx[tx_off];
                tx_off++;
            }
            // read
            if((base[2] & REMPTY) == 0 and rx_off < n) {
                rx[rx_off] = base[0];
                rx_off++;
            }
        }
        alt_irq_enable_all(irq_context);
    }
};
avalon_spi_master_t spi_master;

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
            spi_master.spi_do(0x00000001, 4, tx, rx);
            printf("rx = 0x%08X\n", rx[3]);

            break;
        }
        default:
            printf("invalid command: '%c'\n", cmd);
        }
    }

    return 0;
}
