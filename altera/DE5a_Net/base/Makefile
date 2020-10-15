
.ONESHELL :

CABLE=DE5
SOF=output_files/top.sof

IPs = \
    nios.tcl

include util/altera/makefile.mk

$(PREFIX)/top.qsf : top.qip
	cat << EOF > $@
	set_global_assignment -name QIP_FILE $<
	set_global_assignment -name TOP_LEVEL_ENTITY top
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name PRE_FLOW_SCRIPT_FILE "quartus_sh:util/altera/pre_flow.tcl"
	set_global_assignment -name VHDL_FILE "components_pkg.vhd"
	EOF
