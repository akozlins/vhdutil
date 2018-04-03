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

sim tb_alu
