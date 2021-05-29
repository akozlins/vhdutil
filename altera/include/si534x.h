/*
 * author : Alexandr Kozlinskiy
 * date : 2019
 */

#ifndef __UTIL_SI534X_H__
#define __UTIL_SI534X_H__

#include "si.h"

struct si534x_t : si_t {

    si534x_t(ALT_AVALON_I2C_DEV_t* i2c_dev, alt_u32 i2c_slave)
        : si_t(i2c_dev, i2c_slave)
    {
    }

    si534x_t(alt_u32 spi_base, alt_u32 spi_slave)
        : si_t(spi_base, spi_slave)
    {
    }

    void status() {
        printf("status:\n");
        printf("  SYSINCAL = %d\n", read(0x000C));
        printf("  LOF/LOS = %d/%d\n", (read(0x000D) & 0x10) != 0, (read(0x000D) & 0x01) != 0);
        printf("  HOLD/LOL = %d/%d\n", (read(0x000E) & 0x20) != 0, (read(0x000E) & 0x02) != 0);
    }

    void read_design_id(char design_id[8]) {
        read_n(0x026B, (alt_u8*)design_id, 8);
    }

    void write_design_id(const char design_id[8]) {
        write_n(0x026B, (alt_u8*)design_id, 8);
    }

    int wait_sysincal(int timeout = 8) {
        for(int i = 0; i < timeout; i++) {
            alt_u8 sysincal = read(0x000C);
            if(sysincal == 0) return 0;
            printf("[si534x.init] SYSINCAL = %u => wait ...\n", sysincal);
            usleep(1000);
        }
        return -1;
    }

    void soft_reset() {
        write(0x001C, read(0x001c) | (1 << 0));
    }

    int nvm_write() {
        printf("\n");
        printf("WARNING\n");
        printf("=======\n");
        printf("This will write to NVM.\n");
        printf("\n");
        printf("Are you sure? (Type uppercase yes):\n");
        if(!(wait_key() == 'Y' && wait_key() == 'E' && wait_key() == 'S')) {
            return -1;
        }

        if(read(0x00E2) != 0x03) {
            printf("[si534x.nvm_write] ERROR: ACTIVE_NVM_BANK = 0x%02X != 0x03\n");
            return -1;
        }

        // The procedure for writing registers into NVM is as follows:
        // 1. Write all registers as needed. Verify device operation before writing registers to NVM.
        // 2. You may write to the user scratch space (Registers 0x026B to 0x0272 DESIGN_ID0-DESIGN_ID7) to identify the contents of the NVM bank.

        // 3. Write 0xC7 to NVM_WRITE register.
        printf("[si534x.nvm_write] Write 0xC7 to NVM_WRITE register.\n");
        write(0x00E3, 0xC7);

        // 4. Poll DEVICE_READY until DEVICE_READY = 0x0F.
        printf("[si534x.nvm_write] Poll DEVICE_READY until DEVICE_READY = 0x0F.\n");
        if(wait_ready() != 0) {
            printf("[si534x.nvm_write] FATAL: DEVICE_READY != 0x0F\n");
            while(1);
            return -1;
        }

        // 5. Set NVM_READ_BANK 0x00E4[0] = 1. This will load the NVM contents into non-volatile memory.
        write(0x00E4, read(0x00E4) & 0x01);
        // 6. Poll DEVICE_READY until DEVICE_READY = 0x0F.
        wait_ready();
        // NOTE: Alternatively, steps 5 and 6 can be replaced with a Hard Reset,
        //       either by RSTb pin, HARD_RST register bit, or power cycling the device to generate a POR.
        //       All of these actions will load the new NVM contents back into the device registers.

        // 7. Read ACTIVE_NVM_BANK and verify that the value is the next highest value in the table above.
        //    For example, from the factory it will be a 3. After NVM_WRITE, the value will be 15.
        if(read(0x00E2) != 0x0F) {
            printf("[si534x.nvm_write] ERROR: ACTIVE_NVM_BANK = 0x%02X != 0x0F\n");
            return -1;
        }

        return 0;
    }

    void menu() {
        alt_u32 pn_base = (read(0x0003) << 8) | read(0x0002);

        while (1) {
            status();
            printf("\n");

            printf("SI%04X:\n", pn_base);
            printf("  [R] => reset\n");
            printf("  [r] => read regs\n");

            printf("Select entry ...\n");
            char cmd = wait_key();
            switch(cmd) {
            case 'R':
                soft_reset();
                break;
            case 'r': {
                printf("select page (0): ");
                char page = wait_key();
                if('0' <= page && page <= '9') page = page - '0';
                else if('a' <= page && page <= 'f') page = 10 + page - 'a';
                else if('A' <= page && page <= 'F') page = 10 + page - 'A';
                else page = 0;
                printf("si5345.read:\n");
                for(alt_u16 address = 0x0000; address < 0x0100; address++) {
                    printf("  [0x%04X] = 0x%02X\n", (page << 8) + address, read((page << 8) + address));
                }
                break;
            }
            case 'q':
                return;
            default:
                printf("invalid command: '%c'\n", cmd);
            }
        }
    }

};

#endif // __UTIL_SI534X_H__
