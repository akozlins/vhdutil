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

prj_src add "$basedir/top.vhd"
prj_impl option top "top"

foreach f [ lsort [ glob -nocomplain -directory $basedir \
    "../../util/*.vhd" \
    "../../rv/rv32i_*.vhd" \
] ] {
    prj_src add "$f"
}

prj_project save

#prj_run Synthesis -task Lattice_Synthesis
#prj_run PAR -task PARTrace
#prj_run Export -impl impl1 -task Bitgen
