#ifndef __ADC_H__
#define __ADC_H__

#include <altera_modular_adc_sequencer_regs.h>

struct adc_t {

    void menu() {
        while (1) {
            printf("\n");
            printf("  [r] => read\n");

            printf("Select entry ...\n");
            char cmd = wait_key();

            switch(cmd) {
            case 'r':
                IOWR(ADC_SEQUENCER_CSR_BASE, 0, 0); // stop
                IOWR(ADC_SAMPLE_STORE_CSR_BASE, 0x40, 0); // disable interrupt
                IOWR(ADC_SEQUENCER_CSR_BASE, 0, 1); // start
                printf("sample[0] = 0x%08X\n", IORD(ADC_SAMPLE_STORE_CSR_BASE, 0));
                printf("sample[1] = 0x%08X\n", IORD(ADC_SAMPLE_STORE_CSR_BASE, 1));
                break;
            case 'q':
                return;
            default:
                printf("invalid command: '%c'\n", cmd);
            }
        }
    }

};

#endif // __ADC_H__
