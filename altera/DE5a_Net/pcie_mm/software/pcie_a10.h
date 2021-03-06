
namespace altera {

struct pcie_a10_t {
    static constexpr
    const char* NAME = "pcie_a10";

    volatile uint32_t*const cra;
    volatile uint32_t*const txs;

    pcie_a10_t(uint32_t cra, uint32_t txs)
        : cra((uint32_t*)cra)
        , txs((uint32_t*)txs)
    {
    }

    void menu() {
        while (1) {
            printf("\n");
            printf("[%s] -------- menu --------\n", NAME);

            printf("\n");
            printf("Interrupt Status Register = 0x%08X\n", cra[0x3060/4]);
            printf("cfg_busdev = 0x%08X\n", cra[0x3C60/4]);
            printf("ltssm_reg = 0x%02X\n", cra[0x3C64/4]);
            printf("current_speed_reg = 0x%08X\n", cra[0x3C68/4]);
            printf("ATT[0] = %08X\n", cra[0x1000/4]);
            printf("ATT[1] = %08X\n", cra[0x1008/4]);

            printf("\n");
            printf("  [p] => print\n");

            printf("Select entry ...\n");
            char cmd = wait_key();
            switch(cmd) {
            case 'p':
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
