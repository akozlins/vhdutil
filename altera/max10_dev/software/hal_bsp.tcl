#

set dir0 [ file dirname $argv0 ]
source [ file join $dir0 "include/hal_bsp.tcl" ]

set reset_memory_device [ lindex [ get_memory_region reset ] 1 ]

# boot option 1 (see AN730 / BSP Editor Settings)
if { $reset_memory_device == "flash_data" } {
    puts "reset memory defice is flash_data => set .text to flash_data"

    update_section_mapping .text flash_data

    set_setting hal.linker.allow_code_at_reset true
    set_setting hal.linker.enable_alt_load true
    set_setting hal.linker.enable_alt_load_copy_rodata true
    set_setting hal.linker.enable_alt_load_copy_rwdata true
    set_setting hal.linker.enable_alt_load_copy_exceptions true
}
