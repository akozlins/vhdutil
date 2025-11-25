#

add_instance flash altera_onchip_flash
set_instance_parameter_value flash {CLOCK_FREQUENCY} $nios_clk_mhz
set_instance_parameter_value flash {DATA_INTERFACE} {Parallel}
set_instance_parameter_value flash {SECTOR_ACCESS_MODE} {Read\ and\ write Read\ and\ write Read\ only Read\ only Read\ only}
set_instance_parameter_value flash {CONFIGURATION_MODE} {Single Uncompressed Image with Memory Initialization}

nios_base.connect flash clk nreset data 0x00000000
nios_base.connect flash ""    ""   csr 0x700F00F0

if { 1 } {
    add_connection cpu.instruction_master flash.data
    set_instance_parameter_value cpu {resetSlave} {flash.data}
}
