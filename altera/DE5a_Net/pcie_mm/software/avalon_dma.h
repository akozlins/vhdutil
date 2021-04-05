
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

        regs->control =
//            (1 << 2) | // WORD
            (1 << 11) | // QWORD
            (1 << 7) | (1 << 3); // LEEN | GO
        regs->status = 0;

        if(irq >= 0) {
            if(int err = alt_ic_isr_register(0, irq, callback, this, nullptr)) {
                printf("[%s] ERROR: alt_ic_isr_register => %d\n", NAME, err);
            }
        }
    }

    void callback() {
        printf("[%s] callback\n", NAME);
        // acknowledge IRQ
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
            printf("status = 0x%02X\n", status);
            printf("  LEN = %d, WEOP = %d, REOP = %d, BUSY = %d, DONE = %d\n",
                (status >> 4) & 1,
                (status >> 3) & 1,
                (status >> 2) & 1,
                (status >> 1) & 1,
                (status >> 0) & 1
            );
            uint32_t control = regs->control;
            printf("control = 0x%04X\n", control);
            printf("  WCON = %d, RCON = %d, LEEN = %d, WEEN = %d, REEN = %d, I_EN = %d, GO = %d\n",
                (control >> 9) & 1,
                (control >> 8) & 1,
                (control >> 7) & 1,
                (control >> 6) & 1,
                (control >> 5) & 1,
                (control >> 4) & 1,
                (control >> 3) & 1
            );
            printf("  QW = %d, DW = %d, W = %d, HW = %d, B = %d\n",
                (control >> 11) & 1,
                (control >> 10) & 1,
                (control >> 2) & 1,
                (control >> 1) & 1,
                (control >> 0) & 1
            );
            printf("readaddress = %08X\n", regs->readaddress);
            printf("writeaddress = %08X\n", regs->writeaddress);
            printf("length = %08X\n", regs->length);

            printf("\n");
            printf("  [I] => init\n");
            printf("  [w] => write\n");
            printf("  [p] => print\n");
            printf("  [d] => dma\n");

            printf("Select entry ...\n");
            char cmd = wait_key();
            switch(cmd) {
            case 'I':
                init();
                break;
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
                while((regs->status >> 1) & 1) {
                    printf("wait busy\n");
                }
                break;
            case 'q':
                return;
            default:
                printf("invalid command: '%c'\n", cmd);
            }
        }
    }
};

} // namespace altera
