#include <sys/alt_irq.h>

namespace altera {

struct avalon_dma_t {
    static constexpr
    const char* NAME = "avalon_dma";

    struct regs_t {
        uint32_t status;
        uint32_t readaddress;
        uint32_t writeaddress;
        uint32_t length;
        uint32_t reserved0;
        uint32_t reserved1;
        uint32_t control;
        uint32_t reserved2;
    };
    volatile regs_t*const regs;

    avalon_dma_t(uint32_t base)
        : regs((regs_t*)base)
    {
    }

    void init(int irq = -1) {
        printf("[%s] init\n", NAME);

        if(irq >= 0) {
            if(int err = alt_ic_isr_register(0, irq, callback, this, nullptr)) {
                printf("[%s] ERROR: alt_ic_isr_register => %d\n", NAME, err);
            }
            // LEEN | I_EN | GO | WORD
//            regs->control = (1 << 7) | (1 << 4) | (1 << 3) | (1 << 2);
        }

    }

    void callback() {
        printf("[%s] callback\n", NAME);
        // acknowledge the IRQ
        regs->status = 0;
    }

    static
    void callback(void* context) {
        ((avalon_dma_t*)context)->callback();
    }

    void menu() {
        volatile uint32_t* ram_base = (uint32_t*)PCIE_RAM_BASE;

        while (1) {
            printf("\n");
            printf("[%s] -------- menu --------\n", NAME);

            uint32_t status = regs->status;
            printf("\n");
            printf("status: LEN = %d, WEOP = %d, REOP = %d, BUSY = %d, DONE = %d\n",
                (status >> 4) & 1,
                (status >> 3) & 1,
                (status >> 2) & 1,
                (status >> 1) & 1,
                (status >> 0) & 1
            );
            printf("control: %04X\n",
                regs->control
            );

            printf("\n");
            printf("  [w] => write\n");
            printf("  [p] => print\n");
            printf("  [d] => dma\n");

            printf("Select entry ...\n");
            char cmd = wait_key();
            switch(cmd) {
            case 'w':
                for(int i = 0; i < PCIE_RAM_SPAN/4; i++) ram_base[i] = i;
                break;
            case 'p':
                for(int i = 0; i < PCIE_RAM_SPAN/4; i++) {
                    if(i % 8 == 0) printf("%04X:", i*4);
                    printf(" %08X", ram_base[i]);
                    if(i % 8 == 7) printf("\n");
                }
                break;
            case 'd':
                regs->readaddress = 0;
                regs->writeaddress = PCIE_RAM_SPAN/2;
                regs->length = PCIE_RAM_SPAN/2;
                break;
            default:
                printf("invalid command: '%c'\n", cmd);
            }
        }
    }
};

} // namespace altera
