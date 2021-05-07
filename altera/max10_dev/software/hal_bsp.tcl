#

set dir0 [ file dirname $argv0 ]
source [ file join $dir0 "include/hal_bsp.tcl" ]

# boot option 1 (see AN730 / BSP Editor Settings)
if { 0 } {
    update_section_mapping .text flash_data

    set_setting hal.linker.allow_code_at_reset true
    set_setting hal.linker.enable_alt_load true
    set_setting hal.linker.enable_alt_load_copy_rodata true
    set_setting hal.linker.enable_alt_load_copy_rwdata true
    set_setting hal.linker.enable_alt_load_copy_exceptions true
}
