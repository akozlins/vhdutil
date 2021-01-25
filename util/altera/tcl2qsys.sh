#!/bin/bash
set -euf

TCL=$1
QSYS=$2

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
