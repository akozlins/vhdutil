#!/bin/tclsh

# clocks

create_clock -period 10 -name i_clk_100 [ get_ports {i_clk_100} ]
set_property PACKAGE_PIN "Y9" [ get_ports {i_clk_100} ]
set_property IOSTANDARD "LVCMOS33" [ get_ports {i_clk_100} ]

# constraints

#set_false_path -to [ get_ports {i_led[*]} ]
#set_false_path -from [ get_ports {i_btn[*]} ]

# leds

set_property PACKAGE_PIN T22 [ get_ports {o_led[0]} ]
set_property PACKAGE_PIN T21 [ get_ports {o_led[1]} ]
set_property PACKAGE_PIN U22 [ get_ports {o_led[2]} ]
set_property PACKAGE_PIN U21 [ get_ports {o_led[3]} ]
set_property PACKAGE_PIN V22 [ get_ports {o_led[4]} ]
set_property PACKAGE_PIN W22 [ get_ports {o_led[5]} ]
set_property PACKAGE_PIN U19 [ get_ports {o_led[6]} ]
set_property PACKAGE_PIN U14 [ get_ports {o_led[7]} ]

set_property IOSTANDARD "LVCMOS33" [ get_ports {o_led[*]} ]

# buttons

set_property PACKAGE_PIN P16 [ get_ports {i_btn[0]} ]
set_property PACKAGE_PIN T18 [ get_ports {i_btn[1]} ]
set_property PACKAGE_PIN R16 [ get_ports {i_btn[2]} ]
set_property PACKAGE_PIN N15 [ get_ports {i_btn[3]} ]
set_property PACKAGE_PIN R18 [ get_ports {i_btn[4]} ]

set_property IOSTANDARD "LVCMOS25" [ get_ports {i_btn[*]} ]

# switches

set_property PACKAGE_PIN F22 [ get_ports {i_sw[0]} ]
set_property PACKAGE_PIN G22 [ get_ports {i_sw[1]} ]
set_property PACKAGE_PIN H22 [ get_ports {i_sw[2]} ]
set_property PACKAGE_PIN F21 [ get_ports {i_sw[3]} ]
set_property PACKAGE_PIN H19 [ get_ports {i_sw[4]} ]
set_property PACKAGE_PIN H18 [ get_ports {i_sw[5]} ]
set_property PACKAGE_PIN H17 [ get_ports {i_sw[6]} ]
set_property PACKAGE_PIN M15 [ get_ports {i_sw[7]} ]

set_property IOSTANDARD "LVCMOS25" [ get_ports {i_sw[*]} ]
