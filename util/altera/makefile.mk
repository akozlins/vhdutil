#
# author : Alexandr Kozlinskiy
#

.DEFAULT_GOAL := all

.ONESHELL :

ifndef QUARTUS_ROOTDIR
    $(error QUARTUS_ROOTDIR is undefined)
endif

ifeq ($(PREFIX),)
    override PREFIX := .
endif

ifeq ($(CABLE),)
    CABLE := 1
endif

ifeq ($(SOF),)
    SOF := $(PREFIX)/output_files/top.sof
endif

ifeq ($(NIOS_SOPCINFO),)
    NIOS_SOPCINFO := $(PREFIX)/nios.sopcinfo
endif

BSP_SCRIPT := software/hal_bsp.tcl
SRC_DIR := software/app_src

ifeq ($(BSP_DIR),)
    BSP_DIR := $(PREFIX)/software/hal_bsp
endif

ifeq ($(APP_DIR),)
    APP_DIR := $(PREFIX)/software/app
endif

$(PREFIX)/top.qsf : $(PREFIX)/util $(PREFIX)/IPs.qip
	cat << EOF > $@
	set_global_assignment -name QIP_FILE $$(realpath --relative-to=$(PREFIX) -- top.qip)
	set_global_assignment -name TOP_LEVEL_ENTITY top
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name PRE_FLOW_SCRIPT_FILE "quartus_sh:./util/altera/pre_flow.tcl"
	set_global_assignment -name QIP_FILE "IPs.qip"
	set_global_assignment -name VHDL_FILE "components_pkg.vhd"
	EOF

$(PREFIX)/top.qpf : $(PREFIX)
	cat << EOF > $@
	PROJECT_REVISION = "top"
	EOF

QSYS_FILES := $(patsubst %.tcl,$(PREFIX)/%.qsys,$(IPs))
SOPC_FILES := $(patsubst %.qsys,%.sopcinfo,$(QSYS_FILES))

all : $(PREFIX)/top.qpf $(PREFIX)/top.qsf $(QSYS_FILES) $(SOPC_FILES)

$(PREFIX) :
	mkdir -pv $(PREFIX)

e$(PREFIX)/util : $(PREFIX)
	[ -e $(PREFIX)/util ] || ln -snv --relative -T util $(PREFIX)/util

$(PREFIX)/IPs.qip : $(PREFIX)
	echo "" > $@
	for ip in $(QSYS_FILES) ; do
	    echo "set_global_assignment -name QSYS_FILE [ file join $$::quartus(qip_path) \"$$(realpath -m --relative-to=$(PREFIX) -- $$ip)\" ]" >> $@
	done

.PRECIOUS : %.qip %.sip
ip_%.qip : ip_%.v
#	qmegawiz -silent OPTIONAL_FILES=NONE ip_$*.v
	qmegawiz -silent ip_$*.v
#	sed -r 's/ +/ /g' -i ip_$*.v
	touch ip_$*.qip

$(PREFIX)/%.qsys : %.tcl
	./util/altera/tcl2qsys.sh $< $@

$(PREFIX)/%.sopcinfo : $(PREFIX)/%.qsys
	./util/altera/qsys-generate.sh $<

.PHONY : flow
flow : all
	( cd $(PREFIX) && ./util/altera/flow.sh )

.PHONY : sof2flash
sof2flash :
	sof2flash --pfl --programmingmode=PS \
	    --optionbit=0x00030000 \
	    --input="$(SOF)" \
	    --output="$(SOF).flash" --offset=0x02B40000
	objcopy -Isrec -Obinary $(SOF).flash $(SOF).bin

.PHONY : pgm
pgm : $(SOF)
	quartus_pgm -m jtag -c $(CABLE) --operation="p;$(SOF)"

.PRECIOUS : $(BSP_DIR)
$(BSP_DIR) : $(BSP_SCRIPT) $(NIOS_SOPCINFO)
	mkdir -p $(BSP_DIR)
	nios2-bsp-create-settings \
	    --type hal --script $(SOPC_KIT_NIOS2)/sdk2/bin/bsp-set-defaults.tcl \
	    --sopc $(NIOS_SOPCINFO) --cpu-name cpu \
	    --bsp-dir $(BSP_DIR) --settings $(BSP_DIR)/settings.bsp --script $(BSP_SCRIPT)

bsp : $(BSP_DIR)

.PRECIOUS : $(APP_DIR)/main.elf
.PHONY : $(APP_DIR)/main.elf
$(APP_DIR)/main.elf : $(SRC_DIR)/* $(BSP_DIR)
	nios2-app-generate-makefile \
	    --set ALT_CFLAGS "-pedantic -Wall -Wextra -Wformat=0 -std=c++11" \
	    --bsp-dir $(BSP_DIR) --app-dir $(APP_DIR) --src-dir $(SRC_DIR)
	$(MAKE) -C $(APP_DIR) clean
	$(MAKE) -C $(APP_DIR)
	nios2-elf-objcopy $(APP_DIR)/main.elf -O srec $(APP_DIR)/main.srec
	# generate flash image (srec)
	( cd $(APP_DIR) ; make mem_init_generate )

.PHONY : app
app : $(APP_DIR)/main.elf

.PHONY : app_flash
app_flash :
	nios2-flash-programmer -c $(CABLE) --base=0x0 $(APP_DIR)/main.flash

.PHONY : flash
flash : app_flash
	nios2-flash-programmer -c $(CABLE) --base=0x0 $(SOF).flash

.PHONY : app_upload
app_upload : app
	nios2-gdb-server -c $(CABLE) -r -w 1 -g $(APP_DIR)/main.srec

.PHONY : terminal
terminal :
	nios2-terminal -c $(CABLE)
