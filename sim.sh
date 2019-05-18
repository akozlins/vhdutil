#!/bin/sh
set -eux

TB=$1
STOPTIME=50us

mkdir -p work
unset CDPATH
cd work || exit 1

DIR=..
SRC="$DIR/util_pkg.vhd $DIR/util/*.vhd $DIR/cpu/*.vhd $DIR/tb/$TB.vhd"

ghdl -i $SRC
ghdl -s $SRC
ghdl -m -P"$XDG_CACHE_HOME/xilinx-vivado" "$TB"
ghdl -e -P"$XDG_CACHE_HOME/xilinx-vivado" "$TB"
ghdl -r "$TB" --stop-time="$STOPTIME" --vcd="$TB.vcd" --wave="$TB.ghw"

gtkwave "$TB.ghw"
