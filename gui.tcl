#!/bin/sh
# \
exec vivado -mode gui -source "$0" -tclargs "$@"

source project.tcl

save_project_as -force project project

# synth
synth_design -verbose -top top
