#

source {device.tcl}

source {util/nios_base.tcl}
set_instance_parameter_value spi numberOfSlaves 16

nios_base.export_avm avm_test 8 0x70100000 -readLatency 1
