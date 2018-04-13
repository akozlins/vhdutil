#!/bin/sh
# \
unset CDPATH ; \
cd "$(dirname -- "$(readlink -e -- "$0")")" || exit 1 ; \
exec vivado -mode tcl -source "$0" -tclargs "$@"

proc sim { tb } {
    set_property top_lib xil_defaultlib [ get_filesets sim_1 ]
    set_property top $tb [ get_filesets sim_1 ]
    launch_simulation
}

proc pgm { bit } {
    set dev [ get_hw_devices "xc7z020_1" ]
    set_property PROGRAM.FILE $bit $dev
    program_hw_devices $dev
}

set part "xc7z020clg484-1"

set dir [ lindex $argv 0 ]
if { [ file isdirectory $dir ] == 0 } {
    error "path '$dir' does not exist"
}

create_project -in_memory -part $part
read_xdc "top.xdc"

read_vhdl "util.vhd"
foreach { file } [ lsort [ glob -nocomplain -- "util/*.vhd" "util/*.v" ] ] {
    add_files -fileset sources_1 "$file"
}
foreach { file } [ lsort [ glob -nocomplain -- "tb/*.v" ] ] {
    add_files -fileset sim_1 "$file"
}

read_vhdl "$dir/top.vhd"
set_property top top [ current_fileset ]
