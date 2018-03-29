#!/bin/sh
# \
exec vivado -mode tcl -source "$0"

set part "xc7z020clg484-1"

create_project -in_memory -part $part
read_vhdl top.vhd
read_xdc top.xdc

# synth
synth_design -verbose -top top
opt_design -verbose

# place & route
place_design -verbose
phys_opt_design -verbose
route_design -verbose

write_bitstream -verbose -mask_file -force top.bit

open_hw
connect_hw_server
open_hw_target
set dev [ get_hw_devices "xc7z020_1" ]
set_property PROGRAM.FILE "top.bit" $dev
program_hw_devices $dev

exit
