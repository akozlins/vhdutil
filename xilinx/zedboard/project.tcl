#!/bin/sh
# \
unset CDPATH ; \
cd "$(dirname -- "$(readlink -e -- "$0")")" || exit 1 ; \
exec vivado -mode tcl -source "$0" -tclargs "$@"

source "../util.tcl"

create_project -in_memory

set_property -name "part" -value "xc7z020clg484-1" -objects [ current_project ]
set_property -name "enable_vhdl_2008" -value "1" -objects [ current_project ]
set_property -name "target_language" -value "VHDL" -objects [ current_project ]

add_files top.vhd
set_property top top [ current_fileset ]
add_files_glob "../../util/*.vhd"
add_files_glob "../../cpu/*.vhd"
add_files_glob "../../rv/*.vhd"
add_files_glob "../../tb/*.vhd" sim_1
set_property file_type {VHDL 2008} [ get_files ]

read_xdc -unmanaged "top.xdc"

set_property -name "source_mgmt_mode" -value "All" -objects [ current_project ]
