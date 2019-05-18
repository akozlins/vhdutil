#!/bin/sh
set -eux

TB=$1

STOPTIME=50us

SRC="util_pkg.vhd util/*.vhd cpu/*.vhd tb/$TB.vhd"

WORK=work

#ghdl -s --workdir=$WORK $SRC
ghdl -i --workdir=$WORK $SRC
ghdl -m --workdir=$WORK -P"$XDG_CACHE_HOME/xilinx-vivado" $TB
ghdl -e --workdir=$WORK -P"$XDG_CACHE_HOME/xilinx-vivado" $TB
ghdl -r --workdir=$WORK $TB --stop-time=$STOPTIME --vcd=$WORK/$TB.vcd --wave=$WORK/$TB.ghw

#ghdl --clean --workdir=$WORK

gtkwave $WORK/$TB.ghw
