#!/bin/sh
set -euf

TCL=$1
QSYS=$2

qsys-script --cmd="source {$TCL}; save_system {$QSYS};"
