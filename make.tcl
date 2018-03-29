#!/bin/sh
# \
exec vivado -mode tcl -source "$0" -tclargs "$@"

set part "xc7z020clg484-1"

set dir [ lindex $argv 0 ]
if { [ file isdirectory $dir ] == 0 } {
    error "path '$dir' does not exist"
}

create_project -in_memory -part $part
read_vhdl "$dir/top.vhd"
read_xdc "$dir/top.xdc"

# synth
synth_design -verbose -top top
opt_design -verbose

# place & route
place_design -verbose
phys_opt_design -verbose
route_design -verbose
#place_design -verbose -post_place_opt
#phys_opt_design -verbose
#route_design -verbose

#set_property BITSTREAM.STARTUP.STARTUPCLK JtagClk [current_design]
#set_property BITSTREAM.CONFIG.DCIUPDATEMODE Quiet [current_design]
write_bitstream -verbose -mask_file -force "$dir/top.bit"

open_hw
connect_hw_server
open_hw_target
set dev [ get_hw_devices "xc7z020_1" ]
set_property PROGRAM.FILE "$dir/top.bit" $dev
program_hw_devices $dev

exit
