#!/bin/bash
set -euf

# TODO : docs

TB=$1
shift

STOPTIME=${STOPTIME:-1us}

SRC=()
for arg in "$@" ; do
    arg=$(realpath -s --relative-to=.cache -- "$arg")
    SRC+=("$arg")
done

mkdir -p .cache
cd .cache || exit 1

OPTS=(
    --std=08
    --ieee=synopsys -fexplicit
    --mb-comments
    -fpsl
)

[ -d "$HOME/.local/share/ghdl/vendors/altera" ] && OPTS+=(-P"$HOME/.local/share/ghdl/vendors/altera")
[ -d "/usr/local/lib/ghdl/vendors/altera" ] && OPTS+=(-P"/usr/local/lib/ghdl/vendors/altera")

#ghdl -s "${OPTS[@]}" "${SRC[@]}"
ghdl -i "${OPTS[@]}" "${SRC[@]}"
ghdl -m "${OPTS[@]}" "$TB"
ghdl -e "${OPTS[@]}" "$TB"

#exec \
ghdl -r "${OPTS[@]}" "$TB" --stop-time="$STOPTIME" --vcd="$TB.vcd" --wave="$TB.ghw"

gtkwave "$TB.ghw"
