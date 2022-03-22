#

source {device.tcl}

source {util/nios_base.tcl}
set_instance_parameter_value ram {memorySize} {0x00080000}
set_instance_parameter_value spi numberOfSlaves 32

# add dummy flash_tcm_* ports
add_instance flash flash1616
add_interface flash conduit end
set_interface_property flash EXPORT_OF flash.out
