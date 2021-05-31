
#include "include/base.h"

#include "include/si534x.h"
si534x_t si5342 { SPI_BASE, 0 };

#include <sys/alt_irq.h>

struct avalon_spi_master_t {
    volatile alt_u32* base = (alt_u32*)AVALON_SPI_MASTER_BASE;

    int valid() {
        for(int i = 1; i < 4; i++) {
            if(base[i] == 0xCCCCCCCC) return 0;
        }
        return 1;
    }

    void slave_select(alt_u32 ss) {
        base[1] = ss;
    }

    void sso(int x) {
        if(x) base[2] |= 1 << 31;
        else base[2] &= ~(1 << 31);
    }

    void write(alt_u32 x) {
        base[0] = x;
    }

    alt_u32 read() {
        return base[0];
    }

    int wfull() {
        return (base[2] & 0x00000001) != 0;
    }

    int rempty() {
        return (base[2] & 0x00000100) != 0;
    }

    void control(alt_u16 sclk_div, int sdo_cpha = 0, int sdi_cpha = 0, int cpol = 0) {
        alt_u32 flags = sclk_div;
        if(cpol) flags |= 1 << 16;
        if(sdo_cpha) flags |= 1 << 17;
        if(sdi_cpha) flags |= 1 << 18;
        base[3] = flags;
    }

    void reset() {
        base[3] |= 1 << 31;
        base[3] &= ~(1 << 31);
    }

    void spi_do(int ss, int n, const alt_u8* tx, alt_u8* rx) {
        if(!valid()) {
            printf("E [avalon_spi_master_t::spi_do] invalid base address\n");
            return;
        }

        reset();
        control(3);
        slave_select(ss);

        alt_irq_context irq_context = alt_irq_disable_all();
        for(int tx_off = 0, rx_off = 0; tx_off < n or rx_off < n;) {
            // write
            while(!wfull() and tx_off < n) {
                if(tx_off == 0) sso(1);
                write(tx[tx_off++]);
                if(tx_off == n) sso(0);
            }
            // read
            if(!rempty() and rx_off < n) {
                rx[rx_off++] = read();
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
            for(int addr = 0; addr < 256; addr++) {
                alt_u8 tx[4] = { 0x00, addr, 0x80, 0x00 }, rx[4];
                spi_master.spi_do(0x00000001, 4, tx, rx);
                printf("[0x%02X] = 0x%08X\n", addr, rx[3]);
            }

            break;
        }
        default:
            printf("invalid command: '%c'\n", cmd);
        }
    }

    return 0;
}
