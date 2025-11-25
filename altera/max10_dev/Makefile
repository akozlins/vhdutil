
CABLE=1

IPs := \
    $(wildcard ip/*.vhd.qmegawiz) \
    nios.tcl

include util/quartus/makefile.mk

$(POF) : $(APP_DIR)/mem_init/flash.hex

.PHONY : pof
pof : $(POF)

.PHONY : pgm_pof
pgm_pof : $(POF)
	CABLE=$$($(call find_file,jtagconfig_match.sh) "$(CABLE)" "$(CABLE_DEVICE)")
	quartus_pgm --cable "$$CABLE" --mode jtag --operation="p;$(POF)"
