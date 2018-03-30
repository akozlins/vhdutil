#!/bin/sh
# \
exec vivado -mode gui -source "$0" -tclargs "$@"

source project.tcl

# synth
synth_design -verbose -top top
