
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
            break;
        }
        default:
            printf("invalid command: '%c'\n", cmd);
        }
    }

    return 0;
}
