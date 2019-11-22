/*
 * author : Alexandr Kozlinskiy
 * date : 2019
 */

#include "../i2c.h"

/**
 * Arria 10 board (DE5a_NET) FAN controller.
 */
struct fan_t {
    i2c_t i2c;

    const alt_u32 fclk = 254000;

//    uint8_t mode = 0x2; // closed loop
    alt_u8 scale = 4;
    alt_u8 rps = 50;

    alt_u8 get_rps() {
        return scale * fclk / ( 128 * 2 * (i2c.get(0x48, 0x00) + 1));
    }

    void set_rps(alt_u8 rps) {
        i2c.set(0x48, 0x00, scale * fclk / (128 * 2 * rps) - 1);
    }

    void init() {
        i2c.set(0x48, 0x16, 0x02); // tachometer count time
        i2c.set(0x48, 0x08, 0x07); // alarm enable
        i2c.set(0x48, 0x04, 0xF5); // gpio definition
        i2c.set(0x48, 0x02, 0x2A); // configuration
//        i2c.set(0x48, 0x00, 0x4E); // fan speed
        set_rps(rps);
    }

    void menu() {
        while (1) {
            printf("\n");
            printf("[fan] -------- menu --------\n");

            printf("\n");
            printf(
                "  conf = 0x%02X, gpio = 0x%02X, tach = 0x%02X\n"
                "  alarm = 0x%02X => 0x%02X\n"
                "  rps = 0x%02X (%u) => %u\n",
                i2c.get(0x48, 0x02), i2c.get(0x48, 0x04), i2c.get(0x48, 0x16),
                i2c.get(0x48, 0x08), i2c.get(0x48, 0x0A),
                i2c.get(0x48, 0x00), rps, i2c.get(0x48, 0x0C) / 2
            );

            printf("\n");
            printf("  [i] => init\n");
            printf("  [[] => rps++\n");
            printf("  []] => rps--\n");
            printf("  [q] => exit\n");

            printf("Select entry ...\n");
            char cmd = wait_key();
            switch(cmd) {
            case 'i': // fan i2c
                init();
                break;
            case ']':
                set_rps(++rps);
                break;
            case '[':
                set_rps(--rps);
                break;
            case '?':
                wait_key();
                break;
            case 'q':
                return;
            default:
                printf("invalid command: '%c'\n", cmd);
            }
        }
    }
};
