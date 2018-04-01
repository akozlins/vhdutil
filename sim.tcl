#!/bin/sh
# \
exec vivado -mode gui -source "$0" -tclargs "$@"

create_project -in_memory

read_vhdl "util.vhd"
foreach { file } [ glob -directory "util/" -- "*" ] {
    read_vhdl "$file"
}

foreach { file } [ glob -directory "tb/" -- "*" ] {
    add_files -fileset sim_1 "$file"
}

save_project_as -force project project

proc sim { tb } {
    set_property top_lib xil_defaultlib [ get_filesets sim_1 ]
    set_property top $tb [ get_filesets sim_1 ]
    launch_simulation
}

sim tb_alu
