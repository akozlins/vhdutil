#!/bin/sh
# \
exec vivado -jvm Xmx2048m -mode gui -source "$0" -tclargs "$@"

source project.tcl

save_project_as -force project project
