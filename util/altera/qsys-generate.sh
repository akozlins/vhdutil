#!/bin/sh
set -euf

QSYS=$1

QSYS_DIR=$(dirname -- "$QSYS")

# TODO: use --search-path='./util,$'

exec \
qsys-generate \
    --synthesis=VHDL \
    --output-directory="$QSYS_DIR/" \
    "$QSYS"
