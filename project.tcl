#!/bin/tclsh

set part "xc7z020clg484-1"

set dir [ lindex $argv 0 ]
if { [ file isdirectory $dir ] == 0 } {
    error "path '$dir' does not exist"
}

create_project -in_memory -part $part
read_vhdl "util.vhd"
read_vhdl "$dir/top.vhd"
read_xdc "$dir/top.xdc"

foreach { file } [ glob -directory "util/" -- "*.vhd" ] {
    read_vhdl "$file"
}
