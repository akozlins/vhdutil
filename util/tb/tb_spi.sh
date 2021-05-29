#!/bin/sh
set -eu
IFS="$(printf '\n\t')"
unset CDPATH
cd "$(dirname -- "$(readlink -e -- "$0")")" || exit 1

entity=$(basename "$0" .sh)

STOP_TIME_US=1 \
../sim.sh "$entity" \
    ../*.vhd \
    "$entity.vhd"
