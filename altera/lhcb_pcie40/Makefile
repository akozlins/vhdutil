
CABLE=1

IPs := \
    nios.tcl

include util/quartus/makefile.mk

output_files/top.pof : output_files/top.sof
	quartus_cpf -c top.cof

pgm_pof : output_files/top.pof
	quartus_pgm -c $(CABLE) top.cdf
