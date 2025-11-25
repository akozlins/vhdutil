#ifndef __FLASH_H__
#define __FLASH_H__

struct ufm_t {
    volatile alt_u32* csr = (alt_u32*)FLASH_CSR_BASE;
    volatile alt_u32* sector2 = (alt_u32*)FLASH_DATA_SECTOR2_START_ADDR;

    void wait_idle() {
        while(csr[0] & 0x3) {
            usleep(1000);
        }
    }

    void disable_wp(int sector) {
        if(!(1 <= sector && sector <= 5)) return;
        sector += 22;
        csr[1] &= ~(1 << sector);
    }

    void enable_wp(int sector) {
        if(!(1 <= sector && sector <= 5)) return;
        sector += 22;
        csr[1] |= (1 << sector);
    }

    void menu() {
        while(1) {
            printf("\n");
            printf("[ufm] -------- menu --------\n");

            printf("\n");
            printf("  status = 0x%08X :", csr[0]);
            if((csr[0] & 0x3) == 0x0) printf(" IDLE");
            else if((csr[0] & 0x3) == 0x1) printf(" BUSY_ERASE");
            else if((csr[0] & 0x3) == 0x2) printf(" BUSY_WRITE");
            else if((csr[0] & 0x3) == 0x3) printf(" BUSY_READ");
            printf(" %sRS", (csr[0] & 0x04) ? "" : "!");
            printf(" %sWS", (csr[0] & 0x08) ? "" : "!");
            printf(" %sES", (csr[0] & 0x10) ? "" : "!");
            printf(" %d%d%d%d%d", (csr[0] >> 5) & 1, (csr[0] >> 6) & 1, (csr[0] >> 7) & 1, (csr[0] >> 8) & 1, (csr[0] >> 9) & 1);
            printf("\n");

            printf("  control = 0x%08X :", csr[1]);
            printf(" 0x%05X", csr[1] & 0xFFFFF);
            printf(" 0x%01X", (csr[1] >> 20) & 0x7);
            printf(" %d%d%d%d%d", (csr[0] >> 23) & 1, (csr[0] >> 24) & 1, (csr[0] >> 25) & 1, (csr[0] >> 26) & 1, (csr[0] >> 27) & 1);
            printf("\n");

            printf("\n");
            printf("  [r] => read\n");
            printf("  [w] => write\n");
            printf("  [e] => erase\n");
            printf("  [q] => exit\n");

            printf("Select entry ...\n");
            char cmd = wait_key();
            switch(cmd) {
            case 'r':
                for(int i = 0; i < 16; i++) {
                    if(i % 4 == 0) printf("\n[0x%04X]", &sector2[i]);
                    printf("  %08X", sector2[i]);
                }
                printf("\n");
                break;
            case 'w':
                disable_wp(2);
                // 2. program data
                sector2[0] = 0;
                wait_idle();
                // 4. check write successful field
                if(!(csr[0] & 0x08)) {
                    printf("fail\n");
                }
                enable_wp(2);
                break;
            case 'e':
                disable_wp(2);
                wait_idle();
                csr[1] = csr[1] & ~(0x7 << 20) | (0x2 << 20);
                wait_idle();
                if(!(csr[0] & 0x10)) {
                    printf("fail\n");
                }
                enable_wp(2);
                break;
            case 'q':
                return;
            default:
                printf("invalid command: '%c'\n", cmd);
            }
        }
    }
};

#endif // __FLASH_H__
