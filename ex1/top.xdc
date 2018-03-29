
# clocks

create_clock -period 10 -name clk_100 [get_ports clk]
set_property PACKAGE_PIN "Y9" [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# leds

set_property PACKAGE_PIN T22 [get_ports {led_out[0]}]
set_property PACKAGE_PIN T21 [get_ports {led_out[1]}]
set_property PACKAGE_PIN U22 [get_ports {led_out[2]}]
set_property PACKAGE_PIN U21 [get_ports {led_out[3]}]
set_property PACKAGE_PIN V22 [get_ports {led_out[4]}]
set_property PACKAGE_PIN W22 [get_ports {led_out[5]}]
set_property PACKAGE_PIN U19 [get_ports {led_out[6]}]
set_property PACKAGE_PIN U14 [get_ports {led_out[7]}]

set_property IOSTANDARD "LVCMOS33" [get_ports {led_out[*]}]
