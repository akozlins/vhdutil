#!/bin/tclsh

set name ip_clk_200

create_ip -vendor xilinx.com -library ip -name clk_wiz -dir .cache/ip -module_name $name

set_property -dict [ list \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
] [ get_ips $name ]

generate_target all [ get_files .cache/ip/$name/$name.xci ]

create_ip_run [ get_files .cache/ip/$name/$name.xci ]
launch_runs ${name}_synth_1
