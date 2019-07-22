
add_instance flash flash1616
set_instance_parameter_value flash {clockFrequency} $nios_freq

set_instance_parameter_value cpu {resetSlave} {flash.uas}
set_instance_parameter_value cpu {resetOffset} {0x05E40000}

add_connection clk.clk flash.clk
add_connection clk.clk_reset flash.reset

add_connection                 cpu.data_master flash.uas
set_connection_parameter_value cpu.data_master/flash.uas        baseAddress {0x00000000}
add_connection                 cpu.instruction_master flash.uas
set_connection_parameter_value cpu.instruction_master/flash.uas baseAddress {0x00000000}

add_connection jtag_master.master flash.uas
add_connection cpu.debug_reset_request flash.reset

add_interface flash conduit end
set_interface_property flash EXPORT_OF flash.out
