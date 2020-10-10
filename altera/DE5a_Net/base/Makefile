
.ONESHELL:

CABLE=DE5
SOF=output_files/top.sof

BSP_DIR=software/hal_bsp
APP_DIR=software/app

IPs = \
    nios.sopcinfo

include util/makefile.mk

top.qsf : top.qip Makefile
	cat << EOF > $@
	set_global_assignment -name QIP_FILE $<
	set_global_assignment -name TOP_LEVEL_ENTITY top
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name PRE_FLOW_SCRIPT_FILE "quartus_sh:util/altera/pre_flow.tcl"
	set_global_assignment -name VHDL_FILE "components_pkg.vhd"
	EOF

all : top.qsf
