#!/bin/sh
# \
unset CDPATH ; \
cd "$(dirname -- "$(readlink -e -- "$0")")" || exit 1 ; \
exec lattice_pnmainc "$0" "$@"

prj_project open [ lindex $argv 0 ]

# reveal inserter
rvl_project new
rvl_core select top_LA0
rvl_trace trc_option SampleClk=i_clk
rvl_trace add_sig  {{dbg[31:0]}}
rvl_tu set -name TU1 -set_sig {i_reset_n}
rvl_tu set -name TU1 -op .RE.
rvl_tu set -name TU1 -val 1
rvl_te set -expression TU1 TE1
rvl_project save -overwrite "top_LA0.rvl"
prj_src add "top_LA0.rvl"
prj_src enable "top_LA0.rvl"

prj_project save
