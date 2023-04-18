#!/bin/sh
# \
unset CDPATH ; \
cd "$(dirname -- "$(readlink -e -- "$0")")" || exit 1 ; \
exec lattice_pnmainc "$0" "$@"

prj_project open .cache/top.ldf

pgr_project open ../top.xcf
pgr_program run
