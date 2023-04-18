#!/bin/sh
# \
unset CDPATH ; \
cd "$(dirname -- "$(readlink -e -- "$0")")" || exit 1 ; \
exec lattice_pnmainc "$0" "$@"

set basedir [ file normalize [ file dirname [ info script ] ] ]
file mkdir ".cache"
cd ".cache"

prj_project new -name "top" -lpf "$basedir/top.lpf" -synthesis "synplify"
prj_strgy set_value -strategy Strategy1 syn_vhdl2008=True
prj_dev set -part "LCMXO3LF-6900C-5BG256C"

# top file
prj_src add "$basedir/top.vhd"
prj_impl option top "top"

foreach f [ lsort [ glob -nocomplain -directory $basedir \
    "../../util/ff_sync.vhd" \
    "../../util/reset_sync.vhd" \
    "../../util/clkdiv.vhd" \
] ] {
    prj_src add "$f"
}

# programmer
prj_src add "$basedir/top.xcf"

prj_project save
