#

macro(add_quartus_qsf TARGET_NAME)
endmacro()

macro(add_quartus_software TARGET_NAME)
endmacro()

add_custom_command(bsp-create-settings
    COMMAND nios2-bsp-create-settings \
        --type hal --script $(SOPC_KIT_NIOS2)/sdk2/bin/bsp-set-defaults.tcl \
        --sopc nios.sopcinfo --cpu-name cpu \
        --bsp-dir $(BSP_DIR) --settings $(BSP_DIR)/settings.bsp --script $(BSP_DIR).tcl
    VERBATIM
)
