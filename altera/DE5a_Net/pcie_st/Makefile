
CABLE=DE5

IPs = \
    $(wildcard ip/*.tcl) \
    nios.tcl

include util/quartus/makefile.mk

flash :
	../../a10_tcl/program.sh
