#!/bin/sh
set -euf

DIR=$(dirname -- "$(readlink -f -- "$0")")

PROJECT_NAME=top

quartus_sh -t "$DIR/flow.tcl" "$PROJECT_NAME"
