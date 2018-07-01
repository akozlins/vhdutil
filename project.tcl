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

proc add_files_glob { pattern { fileset "sources_1" }  } {
    foreach { file } [ lsort [ glob -nocomplain -- $pattern ] ] {
        add_files -fileset $fileset $file
    }
}

proc read_xdc_glob { pattern  } {
    foreach { file } [ lsort [ glob -nocomplain -- $pattern ] ] {
        read_xdc -unmanaged $file
    }
}

set part "xc7z020clg484-1"

create_project -in_memory -part $part
read_xdc -unmanaged "top.xdc"

read_vhdl "util_pkg.vhd"
add_files_glob "util/*.vhd"
read_xdc_glob "util/*.xdc"

add_files_glob "cpu/*.vhd"
add_files_glob "tb/*.vhd" sim_1

read_vhdl "top.vhd"
set_property top top [ current_fileset ]
