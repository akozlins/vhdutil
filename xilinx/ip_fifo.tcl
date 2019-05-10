#!/bin/tclsh

set name ip_fifo

create_ip -vendor xilinx.com -library ip -name fifo_generator -dir ip -module_name $name
set_property -dict [ list \
    CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} \
    CONFIG.Performance_Options {First_Word_Fall_Through} \
    CONFIG.Input_Data_Width {16} \
    CONFIG.Input_Depth {16} \
    CONFIG.Enable_Reset_Synchronization {false} \
] [ get_ips $name ]

generate_target all [ get_files ip/$name/$name.xci ]

create_ip_run [ get_files ip/$name/$name.xci ]
launch_runs ${name}_synth_1
