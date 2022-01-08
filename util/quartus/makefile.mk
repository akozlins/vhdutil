#
# author : Alexandr Kozlinskiy
#

.DEFAULT_GOAL := all

.DELETE_ON_ERROR :
.ONESHELL :

ifndef QUARTUS_ROOTDIR
    $(error QUARTUS_ROOTDIR is undefined)
endif

ifeq ($(QUARTUS_OUTPUT_FILES),)
    override QUARTUS_OUTPUT_FILES := output_files
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
    SOF := $(QUARTUS_OUTPUT_FILES)/top.sof
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

# list all .tcl files
# (use absolute path for files outside project directory)
QSYS_TCL_FILES := $(patsubst $(abspath .)/%,%,$(abspath $(filter %.tcl,$(IPs))))
# convert all .tcl files into .qsys files
# (place generated files into $(PREFIX) directory)
QSYS_FILES := $(addprefix $(PREFIX)/,$(patsubst %.tcl,%.qsys,$(QSYS_TCL_FILES)))
# convert all .qsys files into .sopcinfo files
SOPC_FILES := $(patsubst %.qsys,%.sopcinfo,$(QSYS_FILES))
# make list of .vhd.qmegawiz and .vhd.envsubst files
VHD_QMEGAWIZ_FILES := $(patsubst $(abspath .)/%,%,$(abspath $(filter %.vhd.qmegawiz,$(IPs))))
VHD_ENVSUBST_FILES := $(patsubst $(abspath .)/%,%,$(abspath $(filter %.vhd.envsubst,$(IPs))))
# generate list of .vhd files
VHD_FILES := $(addprefix $(PREFIX)/, \
    $(patsubst %.vhd.qmegawiz,%.vhd,$(VHD_QMEGAWIZ_FILES)) \
    $(patsubst %.vhd.envsubst,%.vhd,$(VHD_ENVSUBST_FILES)) \
)

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
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY $(QUARTUS_OUTPUT_FILES)
	set_global_assignment -name SOURCE_TCL_SCRIPT_FILE "util/quartus/settings.tcl"
	set_global_assignment -name QIP_FILE "$(PREFIX)/include.qip"
	EOF

all : top.qpf top.qsf $(PREFIX)/include.qip

.PHONY : $(PREFIX)/components_pkg.vhd
$(PREFIX)/components_pkg.vhd : $(SOPC_FILES) $(VHD_FILES)
	mkdir -pv -- "$(PREFIX)"
	# find and exec components_pkg.sh
	$(lastword $(realpath $(addsuffix components_pkg.sh,$(dir $(MAKEFILE_LIST))))) "$(PREFIX)" > "$@"
	if [ -x /bin/awk ] ; then awk -f $(lastword $(realpath $(addsuffix components_pkg.awk,$(dir $(MAKEFILE_LIST))))) "$@" ; fi
	# patch generated "altera_pci_express.sdc" files
	$(lastword $(realpath $(addsuffix altera_pci_express.sh,$(dir $(MAKEFILE_LIST))))) "$(PREFIX)"

# include.qip - include all generated files
$(PREFIX)/include.qip : $(PREFIX)/components_pkg.vhd $(QSYS_FILES)
	# components package
	echo "set_global_assignment -name VHDL_FILE [ file join $$::quartus(qip_path) \"components_pkg.vhd\" ]" > "$@"
	# add qsys *.qsys files
	for file in $(patsubst %.qsys,%,$(QSYS_FILES)) ; do
	#    echo "set_global_assignment -name QSYS_FILE [ file join $$::quartus(qip_path) \"$$(realpath -m --relative-to=$(PREFIX) -- $$file.qip)\" ]" >> "$@"
	    echo "set_global_assignment -name QSYS_FILE [ file join $$::quartus(qip_path) \"$$(realpath -m --relative-to=$(PREFIX) -- $$file.qsys)\" ]" >> "$@"
	done
	# add *.vhd (*.qip) files
	for file in $(patsubst %.vhd,%,$(VHD_FILES)) ; do
	    [ -e "$$file.qip" ] && echo "set_global_assignment -name QIP_FILE [ file join $$::quartus(qip_path) \"$$(realpath -m --relative-to=$(PREFIX) -- $$file.qip)\" ]" >> "$@"
	    [ -e "$$file.qip" ] || echo "set_global_assignment -name VHDL_FILE [ file join $$::quartus(qip_path) \"$$(realpath -m --relative-to=$(PREFIX) -- $$file.vhd)\" ]" >> "$@"
	done
	# add $(APP_DIR)/mem_init/meminit.qip
	echo "set_global_assignment -name QIP_FILE [ file join $$::quartus(qip_path) \"$$(realpath -m --relative-to=$(PREFIX) -- $(APP_DIR)/mem_init/meminit.qip)\" ]" >> "$@"

# default device.tcl file
device.tcl :
	touch -- "$@"

$(PREFIX)/%.vhd : %.vhd.envsubst
	NAME="$(basename $(notdir $@))" envsubst '$$NAME' < "$<" > "$@"

$(PREFIX)/%.vhd : %.vhd.qmegawiz
	# find and exec qmegawiz.sh
	$(lastword $(realpath $(addsuffix qmegawiz.sh,$(dir $(MAKEFILE_LIST))))) "$<" "$@"

$(PREFIX)/%.qsys : %.tcl device.tcl
	mkdir -pv -- "$(PREFIX)"
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

update_mif :
	quartus_cdb top --update_mif
	quartus_asm top

.PHONY : pgm
pgm : $(SOF)
	quartus_pgm -m jtag -c "$(CABLE)" --operation="p;$(SOF)"

.PRECIOUS : $(BSP_DIR)/settings.bsp
$(BSP_DIR)/settings.bsp : $(BSP_SCRIPT) $(NIOS_SOPCINFO)
	mkdir -pv -- "$(BSP_DIR)"
	nios2-bsp-create-settings \
	    --type hal --script "$(SOPC_KIT_NIOS2)/sdk2/bin/bsp-set-defaults.tcl" \
	    --sopc $(NIOS_SOPCINFO) --cpu-name cpu \
	    --bsp-dir "$(BSP_DIR)" --settings "$(BSP_DIR)/settings.bsp" --script "$(BSP_SCRIPT)"

bsp : $(BSP_DIR)/settings.bsp

.PRECIOUS : $(APP_DIR)/main.elf
.PHONY : $(APP_DIR)/main.elf
$(APP_DIR)/main.elf : $(SRC_DIR)/* $(BSP_DIR)/settings.bsp
	# TODO: --elf-name
	nios2-app-generate-makefile \
	    --set ALT_CFLAGS "-Wall -Wextra -Wformat=0 -pedantic -std=c++14" \
	    --bsp-dir "$(BSP_DIR)" --app-dir "$(APP_DIR)" --src-dir "$(SRC_DIR)"
	$(MAKE) -C "$(APP_DIR)" clean
	$(MAKE) -C "$(APP_DIR)"
	nios2-elf-objcopy "$(APP_DIR)/main.elf" -O srec "$(APP_DIR)/main.srec"
	# generate mem_init/*.hex files (see AN730 / HEX File Generation)
	$(MAKE) -C "$(APP_DIR)" mem_init_generate
	mkdir -pv -- "$(QUARTUS_OUTPUT_FILES)"
	cp -av -- "$(APP_DIR)/mem_init/nios_ram.hex" "$(QUARTUS_OUTPUT_FILES)/"

app_gdb:
	nios2-gdb-server --cable $(CABLE) --tcpport 2342 --tcptimeout 2 &
	nios2-elf-gdb --eval-command='target remote :2342' $(APP_DIR)/app/main.elf

.PHONY : app
app : $(APP_DIR)/main.elf

.PHONY : app_upload
app_upload : app
	nios2-gdb-server -c "$(CABLE)" -r -w 1 -g "$(APP_DIR)/main.srec"

.PHONY : terminal
terminal :
	nios2-terminal -c "$(CABLE)"
