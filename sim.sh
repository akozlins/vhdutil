#!/bin/sh
set -eux

TB=$1
STOPTIME=50us

unset CDPATH
cd .cache || exit 1
[ -e cpu ] || ln -s ../cpu
[ -e rv ] || ln -s ../rv
[ -e tb ] || ln -s ../tb

DIR=..
SRC="$DIR/util/*.vhd $DIR/cpu/*.vhd $DIR/rv/*.vhd $DIR/tb/$TB.vhd"

ghdl -i $SRC
ghdl -s $SRC
ghdl -m -P"$XDG_CACHE_HOME/xilinx-vivado" "$TB"
ghdl -e -P"$XDG_CACHE_HOME/xilinx-vivado" "$TB"
ghdl -r "$TB" --stop-time="$STOPTIME" --vcd="$TB.vcd" --wave="$TB.ghw"

gtkwave "$TB.ghw"
