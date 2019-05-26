#!/bin/sh
# \
unset CDPATH ; \
cd "$(dirname -- "$(readlink -e -- "$0")")" || exit 1 ; \
exec vivado \
    -nojournal -nolog -tempDir .cache \
    -mode gui -source "$0" -tclargs "$@"

source project.tcl

save_project_as -force project .cache/project

set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY none [get_runs synth_1]
