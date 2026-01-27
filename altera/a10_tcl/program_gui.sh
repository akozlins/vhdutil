#!/bin/sh
# \
exec system-console -cli -disable_readline --rc_script=$0 "$(dirname -- "$(readlink -f -- "$0")")" "$@"

set dir [ lindex $argv 0 ]
set argv [ lreplace $argv 0 0 ]
incr argc -1

source [ file join $dir "program_gui.tcl" ]

?c gui
