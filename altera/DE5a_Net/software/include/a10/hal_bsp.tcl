#create_bsp <bspType> <bsp version> <processor name> <sopcinfo>

# flags
set_setting hal.make.bsp_cflags_debug -g
set_setting hal.make.bsp_cflags_optimization -O2

# logging
#set_setting hal.log_port jtag_uart
#set_setting hal.make.bsp_cflags_user_flags -DALT_LOG_FLAGS=-1

# exit
set_setting hal.enable_exit true
set_setting hal.enable_clean_exit true

# timers
set_setting hal.sys_clk_timer timer
set_setting hal.timestamp_timer timer_ts

# drivers
set_setting hal.enable_small_c_library true
set_setting hal.enable_reduced_device_drivers false
set_setting hal.enable_lightweight_device_driver_api false
set_driver none flash

# regions
foreach { name slave offset span } [ get_memory_region ram ] {
    set span [ expr $span - 0x100 - 0x40000 ]
    update_memory_region $name $slave $offset $span
    add_memory_region ctrl $slave [ expr $offset + $span         ] [ expr 0x100   ]
    add_memory_region data $slave [ expr $offset + $span + 0x100 ] [ expr 0x40000 ]
    break
}

# sections
#update_section_mapping .entry      ram
#update_section_mapping .exceptions ram
#update_section_mapping .text       ram
#update_section_mapping .rodata     ram
#update_section_mapping .rwdata     ram
#update_section_mapping .bss        ram
#update_section_mapping .heap       ram
#update_section_mapping .stack      ram
