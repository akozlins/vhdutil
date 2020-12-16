#!/bin/bash
set -euf

TCL=$1
QSYS=$2

CMD=(
    "package require qsys;"
    "source {$TCL};"
    "save_system {$QSYS};"
)

exec \
qsys-script \
    --cmd="${CMD[*]}"
