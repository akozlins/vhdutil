#

set_instance_assignment -name IO_STANDARD "1.8 V" -to o_si5342_spi_sclk
set_instance_assignment -name IO_STANDARD "1.8 V" -to o_si5342_spi_mosi
set_instance_assignment -name IO_STANDARD "1.8 V" -to i_si5342_spi_miso
set_instance_assignment -name IO_STANDARD "1.8 V" -to o_si5342_spi_ss_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to o_si5342_oe_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to o_si5342_reset_n

set_location_assignment PIN_H15 -to o_si5342_spi_sclk
set_location_assignment PIN_D12 -to o_si5342_spi_mosi
set_location_assignment PIN_D13 -to i_si5342_spi_miso
set_location_assignment PIN_C12 -to o_si5342_spi_ss_n
set_location_assignment PIN_B12 -to o_si5342_oe_n
set_location_assignment PIN_C10 -to o_si5342_reset_n



set_instance_assignment -name IO_STANDARD LVDS -to i_si5342_clk_125
set_location_assignment PIN_AN15 -to i_si5342_clk_125

set_instance_assignment -name IO_STANDARD LVDS -to i_si5342_clk_50
set_location_assignment PIN_B15 -to i_si5342_clk_50



set_location_assignment PIN_D23 -to o_led_n[0]
set_location_assignment PIN_D24 -to o_led_n[1]
set_location_assignment PIN_D25 -to o_led_n[2]
set_location_assignment PIN_D26 -to o_led_n[3]
set_location_assignment PIN_D27 -to o_led_n[4]
set_location_assignment PIN_E23 -to o_led_n[5]
set_location_assignment PIN_E24 -to o_led_n[6]
set_location_assignment PIN_F21 -to o_led_n[7]
set_location_assignment PIN_F22 -to o_led_n[8]
set_location_assignment PIN_F23 -to o_led_n[9]
set_location_assignment PIN_F25 -to o_led_n[10]
set_location_assignment PIN_G20 -to o_led_n[11]
set_location_assignment PIN_G22 -to o_led_n[12]
set_location_assignment PIN_G23 -to o_led_n[13]
set_location_assignment PIN_G24 -to o_led_n[14]
set_location_assignment PIN_G25 -to o_led_n[15]

set_location_assignment PIN_C26 -to i_btn_n[0]
set_location_assignment PIN_D22 -to i_btn_n[1]

set_instance_assignment -name IO_STANDARD "1.8 V" -to i_reset_n
set_location_assignment PIN_A5 -to i_reset_n
