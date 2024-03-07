#!/bin/bash
set -euf

QSF=$1

SRC=($(./util/quartus/qsf-list-vhdl.tcl "$QSF" | grep "^[.]" ))
SIM=$(readlink -f -- ./util/sim.sh)

cd -- "$(dirname -- "$QSF")" || exit 1

"$SIM" top "${SRC[@]}"
