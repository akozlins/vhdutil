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

# btns

set_property PACKAGE_PIN P16 [get_ports {pl_btns[0]}]
set_property PACKAGE_PIN T18 [get_ports {pl_btns[1]}]
set_property PACKAGE_PIN R16 [get_ports {pl_btns[2]}]
set_property PACKAGE_PIN N15 [get_ports {pl_btns[3]}]
set_property PACKAGE_PIN R18 [get_ports {pl_btns[4]}]

set_property IOSTANDARD "LVCMOS25" [get_ports {pl_btns[*]}]

set_false_path -from [get_ports {pl_btns[*]}]
