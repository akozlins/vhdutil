#!/bin/sh
set -eux

work=work
tb=$1

ghdl -i --workdir=$work util_pkg.vhd util/*.vhd cpu/*.vhd tb/*.vhd
ghdl -m --workdir=$work --ieee=synopsys -fexplicit -P"$XDG_CACHE_HOME/xilinx-vivado" $tb
ghdl -e --workdir=$work --ieee=synopsys -fexplicit -P"$XDG_CACHE_HOME/xilinx-vivado" $tb
ghdl -r --workdir=$work $tb --stop-time=1ms --vcd=$work/$tb.vcd --wave=work/$tb.ghw

ghdl --clean --workdir=$work

gtkwave $work/$tb.ghw
