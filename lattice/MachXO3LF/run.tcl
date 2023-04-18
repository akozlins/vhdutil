#!/bin/sh
# \
unset CDPATH ; \
cd "$(dirname -- "$(readlink -e -- "$0")")" || exit 1 ; \
exec lattice_pnmainc "$0" "$@"

prj_project open [ lindex $argv 0 ]

#prj_run Synthesis -impl Implementation0 -task Synplify_Synthesis
#prj_run Map -impl Implementation0 -task MapTrace
#prj_run PAR -impl Implementation0 -task PARTrace
prj_run Export -impl Implementation0 -task Bitgen

