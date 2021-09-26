
#include "include/base.h"

#include "adc.h"
adc_t adc;

#include "ufm.h"
ufm_t ufm;

#include "test.h"

int main() {
    base_init();

    while (1) {
        printf("\n");
        printf("  [a] => adc\n");
        printf("  [f] => ufm (flash)\n");
        printf("  [t] => test\n");
        printf("  [0] => n/a\n");

        printf("Select entry ...\n");
        char cmd = wait_key();

        switch(cmd) {
        case 'a':
            adc.menu();
            break;
        case 'f':
            ufm.menu();
            break;
        case 't':
            test();
            break;
        default:
            printf("invalid command: '%c'\n", cmd);
        }
    }

    return 0;
}
