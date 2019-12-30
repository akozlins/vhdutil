/*
 * mm_i2c.h
 *
 * author : Alexandr Kozlinskiy
 * date : 2017-11-13
 */

#ifndef SOFTWARE_APP_SRC_I2C_H_
#define SOFTWARE_APP_SRC_I2C_H_

#include <system.h>

#include <altera_avalon_i2c.h>

struct i2c_t {
    ALT_AVALON_I2C_DEV_t* dev = alt_avalon_i2c_open(I2C_NAME);

    static
    void read(ALT_AVALON_I2C_DEV_t* i2c_dev, alt_u8 i2c_slave, alt_u8* r, alt_u32 n) {
        if(!i2c_dev) {
            printf("[i2c] ERROR i2c_dev == nullptr");
            return;
        }
        alt_avalon_i2c_master_target_set(i2c_dev, i2c_slave);
        int err = alt_avalon_i2c_master_rx(i2c_dev, r, n, ALT_AVALON_I2C_NO_INTERRUPTS);
        if(err != ALT_AVALON_I2C_SUCCESS) {
            printf("[i2c] ERROR alt_avalon_i2c_master_rx => %d\n", err);
        }
    }

    static
    void write(ALT_AVALON_I2C_DEV_t* i2c_dev, alt_u8 i2c_slave, alt_u8* w, alt_u32 n) {
        if(!i2c_dev) {
            printf("[i2c] ERROR i2c_dev == nullptr");
            return;
        }
        alt_avalon_i2c_master_target_set(i2c_dev, i2c_slave);
        int err = alt_avalon_i2c_master_tx(i2c_dev, w, n, ALT_AVALON_I2C_NO_INTERRUPTS);
        if(err != ALT_AVALON_I2C_SUCCESS) {
            printf("[i2c] ERROR alt_avalon_i2c_master_tx => %d\n", err);
        }
    }

    alt_u8 r8(alt_u8 slave) {
        alt_u8 r = 0;
        read(dev, slave, &r, 1);
        return r;
    }

    void w8(alt_u8 slave, alt_u8 w) {
        write(dev, slave, &w, 1);
    }

    alt_u16 r16(alt_u8 slave) {
        alt_u8 r[2] {};
        read(dev, slave, r, 2);
        return (r[0] << 8) | r[1];
    }

    alt_u8 get(alt_u8 slave, alt_u8 addr) {
        w8(slave, addr);
        return r8(slave);
    }

    void set(alt_u8 slave, alt_u8 addr, alt_u8 data) {
        alt_u8 w[2] = { addr, data };
        write(dev, slave, w, 2);
    }
};

#endif /* SOFTWARE_APP_SRC_I2C_H_ */
