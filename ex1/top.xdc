#!/bin/tclsh

# clocks

create_clock -period 10 -name pl_clk_100 [get_ports pl_clk_100]
set_property PACKAGE_PIN "Y9" [get_ports pl_clk_100]
set_property IOSTANDARD LVCMOS33 [get_ports pl_clk_100]

# leds

set_property PACKAGE_PIN T22 [get_ports {pl_leds[0]}]
set_property PACKAGE_PIN T21 [get_ports {pl_leds[1]}]
set_property PACKAGE_PIN U22 [get_ports {pl_leds[2]}]
set_property PACKAGE_PIN U21 [get_ports {pl_leds[3]}]
set_property PACKAGE_PIN V22 [get_ports {pl_leds[4]}]
set_property PACKAGE_PIN W22 [get_ports {pl_leds[5]}]
set_property PACKAGE_PIN U19 [get_ports {pl_leds[6]}]
set_property PACKAGE_PIN U14 [get_ports {pl_leds[7]}]

set_property IOSTANDARD "LVCMOS33" [get_ports {pl_leds[*]}]
