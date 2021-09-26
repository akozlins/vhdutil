
#ifdef FIFO_IN_BASE
#include <altera_avalon_fifo_util.h>
#endif

int test() {
    while(1) {
        printf("\n");
#ifdef FIFO_IN_BASE
        printf("  [f] => fifo\n");
#endif
        printf("  [0] => flash read test");
        printf("  [q] => exit\n");

        printf("Select entry ...\n");
        char cmd = wait_key();

        switch(cmd) {
#ifdef FIFO_IN_BASE
        case 'f':
            printf("fifo:\n");
            altera_avalon_fifo_init(FIFO_IN_CSR_BASE, 0, 0, FIFO_IN_CSR_FIFO_DEPTH);
            altera_avalon_fifo_write_fifo(FIFO_IN_BASE, FIFO_IN_CSR_BASE, 0x12345678);
            printf("  read = 0x%08X\n", altera_avalon_fifo_read_fifo(FIFO_OUT_BASE, FIFO_IN_CSR_BASE));
            break;
#endif
        case '0': {
            alt_u32 n = 0; // total number of page reads
            alt_u32 k = 0; // reads since last error
            alt_u32 cs_last = 0;
            while(1) {
                char cmd;
                if(read(uart, &cmd, 1) > 0 && cmd == 'q') break;

                alt_u32 cs = 0; // checksum
                for(int i = 0; i < 2048; i++) cs += ((volatile alt_u32*)0)[i];

                n += 1;
                k += 1;
                if(k % 1024 == 0 || cs != cs_last) {
                    printf("\r n = %u : cs = 0x%08X, k = %u", n, cs, k);
                }
                if(cs != cs_last) {
                    cs_last = cs;
                    printf("\n");
                    k = 0;
                }
            }
            break;
        }
        case 'q':
            return 0;
        }
    }

    return -1;
}
