
#ifdef FIFO_IN_BASE
#include <altera_avalon_fifo_util.h>
#endif

int test() {
    while(1) {
        printf("\n");
#ifdef FIFO_IN_BASE
        printf("  [f] => fifo\n");
#endif
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
        case 'q':
            return 0;
        }
    }

    return -1;
}
