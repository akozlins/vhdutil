#!/bin/sh
# \
unset CDPATH ; \
cd "$(dirname -- "$(readlink -e -- "$0")")" || exit 1 ; \
exec lattice_pnmainc "$0"

set basedir [ file normalize [ file dirname [ info script ] ] ]
file mkdir ".cache"
cd ".cache"

prj_project new -name "top" -lpf "$basedir/top.lpf" -synthesis "synplify"
prj_dev set -part "LCMXO3LF-6900C-5BG256C"

# top file
prj_src add "$basedir/top.vhd"
prj_impl option top "top"

foreach f [ lsort [ glob -nocomplain -directory $basedir \
    "../../util/*.vhd" \
    "../../rv/rv32i_*.vhd" \
] ] {
    prj_src add "$f"
}

# reveal inserter
rvl_project new
rvl_core select top_LA0
rvl_trace trc_option SampleClk=clk
rvl_trace add_sig  {{dbg[31:0]}}
rvl_tu set -name TU1 -set_sig {i_reset_n}
rvl_tu set -name TU1 -op .RE.
rvl_tu set -name TU1 -val 1
rvl_te set -expression TU1 TE1
rvl_project save -overwrite "top_LA0.rvl"
prj_src add "top_LA0.rvl"
prj_src enable "top_LA0.rvl"

prj_project save

#prj_run Synthesis -task Lattice_Synthesis
#prj_run PAR -task PARTrace
#prj_run Export -impl impl1 -task Bitgen
