#!/bin/bash
set -euf

TCL=$1
QSYS=$2

QSYS_DIR=$(dirname -- "$QSYS")
mkdir -p -- "$QSYS_DIR"

# use tcl file basename as system name
NAME=$(basename -- "$TCL")
NAME=${NAME%.*}

CMD=(
    "package require qsys;"
    "create_system {$NAME};"
    "source {$TCL};"
    "save_system {$QSYS};"
)

exec \
qsys-script \
    --cmd="${CMD[*]}"
