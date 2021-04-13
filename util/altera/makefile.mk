#
# author : Alexandr Kozlinskiy
#

.DEFAULT_GOAL := all

.ONESHELL :

ifndef QUARTUS_ROOTDIR
    $(error QUARTUS_ROOTDIR is undefined)
endif

# directory for generated files (*.qsys, *.sopcinfo, etc.)
# TODO: rename PREFIX -> QP_TMP_DIR
ifeq ($(PREFIX),)
    override PREFIX := .cache
endif

ifeq ($(CABLE),)
    CABLE := 1
endif

# location of compiled firmware (SOF file)
ifeq ($(SOF),)
    SOF := output_files/top.sof
endif

# location of generated nios.sopcinfo
ifeq ($(NIOS_SOPCINFO),)
    NIOS_SOPCINFO := $(PREFIX)/nios.sopcinfo
endif

# tcl script to generate BSP
# TODO: rename BSP_SCRIPT to NIOS_BSP_SCRIPT
ifeq ($(BSP_SCRIPT),)
    BSP_SCRIPT := software/hal_bsp.tcl
endif

# location (directory) of main.cpp
# TODO: rename SRC_DIR to NIOS_SRC_DIR
ifeq ($(SRC_DIR),)
    SRC_DIR := software
endif

# destination for generated BSP
# TODO: rename BSP_DIR to NIOS_BSP_DIR
ifeq ($(BSP_DIR),)
    BSP_DIR := $(PREFIX)/software/hal_bsp
endif

# destination for compiled software (nios)
# TODO: rename APP_DIR to NIOS_APP_DIR
ifeq ($(APP_DIR),)
    APP_DIR := $(PREFIX)/software/app
endif

# TODO: how to solve ../ in path to .tcl file?
# TODO: - use $(addprefix $(PREFIX),$(realpath $(...)))
# TODO: - or use $(subst $(DOTDOT),DOTDOT,...)

# list all .tcl files
QSYS_TCL_FILES := $(filter %.tcl,$(IPs))
# convert all .tcl files into .qsys files
QSYS_FILES := $(patsubst %.tcl,$(PREFIX)/%.qsys,$(QSYS_TCL_FILES))
# convert all .qsys files into .sopcinfo files
SOPC_FILES := $(patsubst %.qsys,%.sopcinfo,$(QSYS_FILES))
# list all .vhd.qmegawiz files
QMEGAWIZ_XML_FILES := $(filter %.vhd.qmegawiz,$(IPs))
# convert all .vhd.qmegawiz files into .vhd files
QMEGAWIZ_VHD_FILES := $(patsubst %.vhd.qmegawiz,$(PREFIX)/%.vhd,$(QMEGAWIZ_XML_FILES))

# default qpf file
top.qpf :
	cat << EOF > "$@"
	PROJECT_REVISION = "top"
	EOF

# default qsf file - load top.qip, and generated include.qip
top.qsf : $(MAKEFILE_LIST)
	cat << EOF > "$@"
	set_global_assignment -name QIP_FILE top.qip
	set_global_assignment -name TOP_LEVEL_ENTITY top
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name QIP_FILE $(PREFIX)/include.qip
	EOF

all : top.qpf top.qsf $(PREFIX)/include.qip

.PHONY : $(PREFIX)/components_pkg.vhd
$(PREFIX)/components_pkg.vhd : $(SOPC_FILES) $(QMEGAWIZ_VHD_FILES)
	# find and exec components_pkg.sh
	$(lastword $(realpath $(addsuffix components_pkg.sh,$(dir $(MAKEFILE_LIST))))) "$(PREFIX)" > "$@"

# include.qip - include all generated files
$(PREFIX)/include.qip : $(PREFIX)/components_pkg.vhd $(QSYS_FILES)
	# components package
	echo "set_global_assignment -name VHDL_FILE [ file join $$::quartus(qip_path) \"components_pkg.vhd\" ]" > "$@"
	# add qsys *.qsys files
	for file in $(QSYS_FILES) ; do
	    echo "set_global_assignment -name QSYS_FILE [ file join $$::quartus(qip_path) \"$$(realpath -m --relative-to=$(PREFIX) -- $$file)\" ]" >> "$@"
	done
	# add qmegawiz *.qip files
	for file in $(patsubst %.vhd,%,$(QMEGAWIZ_VHD_FILES)) ; do
	    [ -e "$$file.qip" ] && echo "set_global_assignment -name QIP_FILE [ file join $$::quartus(qip_path) \"$$(realpath -m --relative-to=$(PREFIX) -- $$file.qip)\" ]" >> "$@"
	    [ -e "$$file.qip" ] || echo "set_global_assignment -name VHDL_FILE [ file join $$::quartus(qip_path) \"$$(realpath -m --relative-to=$(PREFIX) -- $$file.vhd)\" ]" >> "$@"
	done

# default device.tcl file
device.tcl :
	touch -- "$@"

$(PREFIX)/%.vhd : %.vhd.qmegawiz
	# find and exec qmegawiz.sh
	$(lastword $(realpath $(addsuffix qmegawiz.sh,$(dir $(MAKEFILE_LIST))))) "$<" "$@"

$(PREFIX)/%.qsys : %.tcl device.tcl
	mkdir -pv $(PREFIX)
	# util link is used by qsys to find _hw.tcl modules
	[ -e $(PREFIX)/util ] || ln -snv --relative -T util $(PREFIX)/util
	# find and exec tcl2qsys.sh
	$(lastword $(realpath $(addsuffix tcl2qsys.sh,$(dir $(MAKEFILE_LIST))))) "$<" "$@"

$(PREFIX)/%.sopcinfo : $(PREFIX)/%.qsys
	# find and exec qsys-generate.sh
	$(lastword $(realpath $(addsuffix qsys-generate.sh,$(dir $(MAKEFILE_LIST))))) "$<"

.PHONY : flow
flow : all
	# find and exec flow.sh
	$(lastword $(realpath $(addsuffix flow.sh,$(dir $(MAKEFILE_LIST)))))

.PHONY : sof2flash
sof2flash :
	sof2flash --pfl --programmingmode=PS \
	    --optionbit=0x00030000 \
	    --input="$(SOF)" \
	    --output="$(SOF).flash" --offset=0x02B40000
	objcopy -Isrec -Obinary "$(SOF).flash" "$(SOF).bin"

.PHONY : pgm
pgm : $(SOF)
	quartus_pgm -m jtag -c "$(CABLE)" --operation="p;$(SOF)"

.PRECIOUS : $(BSP_DIR)
$(BSP_DIR) : $(BSP_SCRIPT) $(NIOS_SOPCINFO)
	mkdir -pv -- "$(BSP_DIR)"
	nios2-bsp-create-settings \
	    --type hal --script "$(SOPC_KIT_NIOS2)/sdk2/bin/bsp-set-defaults.tcl" \
	    --sopc $(NIOS_SOPCINFO) --cpu-name cpu \
	    --bsp-dir "$(BSP_DIR)" --settings "$(BSP_DIR)/settings.bsp" --script "$(BSP_SCRIPT)"

bsp : $(BSP_DIR)

.PRECIOUS : $(APP_DIR)/main.elf
.PHONY : $(APP_DIR)/main.elf
$(APP_DIR)/main.elf : $(SRC_DIR)/* $(BSP_DIR)
	# TODO: --elf-name
	nios2-app-generate-makefile \
	    --set ALT_CFLAGS "-Wall -Wextra -Wformat=0 -pedantic -std=c++14" \
	    --bsp-dir "$(BSP_DIR)" --app-dir "$(APP_DIR)" --src-dir "$(SRC_DIR)"
	$(MAKE) -C "$(APP_DIR)" clean
	$(MAKE) -C "$(APP_DIR)"
	nios2-elf-objcopy "$(APP_DIR)/main.elf" -O srec "$(APP_DIR)/main.srec"
	# generate flash (srec) image (see AN730 / HEX File Generation)
	$(MAKE) -C "$(APP_DIR)" mem_init_generate

.PHONY : app
app : $(APP_DIR)/main.elf

.PHONY : app_flash
app_flash :
	nios2-flash-programmer -c "$(CABLE)" --base=0x0 "$(APP_DIR)/main.flash"

.PHONY : flash
flash : app_flash
	nios2-flash-programmer -c "$(CABLE)" --base=0x0 "$(SOF).flash"

.PHONY : app_upload
app_upload : app
	nios2-gdb-server -c "$(CABLE)" -r -w 1 -g "$(APP_DIR)/main.srec"

.PHONY : terminal
terminal :
	nios2-terminal -c "$(CABLE)"
