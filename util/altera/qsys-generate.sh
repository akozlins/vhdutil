#!/bin/sh
set -euf

QSYS=$1

QSYS_DIR=$(dirname -- "$QSYS")

exec \
qsys-generate \
    --synthesis=VHDL \
    --output-directory="$QSYS_DIR/" \
    "$QSYS"
