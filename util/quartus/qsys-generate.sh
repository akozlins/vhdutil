#!/bin/sh
set -euf
export LC_ALL=C

QSYS=$1

QSYS_DIR=$(dirname -- "$QSYS")

exec \
qsys-generate \
    --synthesis=VHDL \
    --output-directory="$QSYS_DIR/" \
    --search-path='$,'"$(realpath -- .)" \
    "$QSYS"
