#!/bin/tclsh

# clocks

create_clock -period 10 -name pl_clk_100 [ get_ports {pl_clk_100} ]
set_property PACKAGE_PIN "Y9" [ get_ports {pl_clk_100} ]
set_property IOSTANDARD "LVCMOS33" [ get_ports {pl_clk_100} ]

set i_clk_P [ get_property P [ get_cells {i_clk} ] ]
create_generated_clock [ get_pins {i_clk/clkout} ] -source [ get_pins {i_clk/clk} ] -divide_by $i_clk_P

# constraints

foreach cell [ get_cells -hier -filter {ref_name==clkmon} ] {
    set from_cells [ get_cells "$cell/tst_gcnt_reg\[*\]" ]
    set to_cells [ get_cells "$cell/i_gcnt/data_q_reg\[0\]\[*\]" ]
    set_bus_skew \
        -from $from_cells -to $to_cells \
        [ get_property PERIOD [ get_clocks -of_objects $to_cells ] ]
    set_max_delay -datapath_only \
        -from $from_cells -to $to_cells \
        [ get_property PERIOD [ get_clocks -of_objects $from_cells ] ]
}

#set_false_path -to [ get_ports {pl_led[*]} ]
#set_false_path -from [ get_ports {pl_btn[*]} ]

# leds

set_property PACKAGE_PIN T22 [ get_ports {pl_led[0]} ]
set_property PACKAGE_PIN T21 [ get_ports {pl_led[1]} ]
set_property PACKAGE_PIN U22 [ get_ports {pl_led[2]} ]
set_property PACKAGE_PIN U21 [ get_ports {pl_led[3]} ]
set_property PACKAGE_PIN V22 [ get_ports {pl_led[4]} ]
set_property PACKAGE_PIN W22 [ get_ports {pl_led[5]} ]
set_property PACKAGE_PIN U19 [ get_ports {pl_led[6]} ]
set_property PACKAGE_PIN U14 [ get_ports {pl_led[7]} ]

set_property IOSTANDARD "LVCMOS33" [ get_ports {pl_led[*]} ]

# buttons

set_property PACKAGE_PIN P16 [ get_ports {pl_btn[0]} ]
set_property PACKAGE_PIN T18 [ get_ports {pl_btn[1]} ]
set_property PACKAGE_PIN R16 [ get_ports {pl_btn[2]} ]
set_property PACKAGE_PIN N15 [ get_ports {pl_btn[3]} ]
set_property PACKAGE_PIN R18 [ get_ports {pl_btn[4]} ]

set_property IOSTANDARD "LVCMOS25" [ get_ports {pl_btn[*]} ]

# switches

set_property PACKAGE_PIN F22 [ get_ports {pl_sw[0]} ]
set_property PACKAGE_PIN G22 [ get_ports {pl_sw[1]} ]
set_property PACKAGE_PIN H22 [ get_ports {pl_sw[2]} ]
set_property PACKAGE_PIN F21 [ get_ports {pl_sw[3]} ]
set_property PACKAGE_PIN H19 [ get_ports {pl_sw[4]} ]
set_property PACKAGE_PIN H18 [ get_ports {pl_sw[5]} ]
set_property PACKAGE_PIN H17 [ get_ports {pl_sw[6]} ]
set_property PACKAGE_PIN M15 [ get_ports {pl_sw[7]} ]

set_property IOSTANDARD "LVCMOS25" [ get_ports {pl_sw[*]} ]
