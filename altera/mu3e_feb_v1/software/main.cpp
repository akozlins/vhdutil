
#include "include/base.h"

#include "include/si534x.h"
si534x_t si5342 { SPI_BASE, 0 };

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
            auto base = (volatile alt_u32*)AVM_TEST_BASE;
            base[0] = 0x0001;
            printf("ctrl = 0x%08X\n", base[0]);

            base[1] = 0x00; // Set Addr
            base[1] = 0x02; // Addr
            base[1] = 0x80; // Read Data
            base[1] = 0x00; // Data

            alt_u32 r;
            while(base[0] & 0x00020000) { printf("."); usleep(1); }
            r = base[1];
            while(base[0] & 0x00020000) { printf("."); usleep(1); }
            r = base[1];
            while(base[0] & 0x00020000) { printf("."); usleep(1); }
            r = base[1];
            while(base[0] & 0x00020000) { printf("."); usleep(1); }
            r = base[1];
            printf("\n");
            printf("r = 0x%08X\n", r);

            break;
        }
        default:
            printf("invalid command: '%c'\n", cmd);
        }
    }

    return 0;
}
