#

source {device.tcl}

source {util/nios_base.tcl}
set_instance_parameter_value spi numberOfSlaves 16

add_instance avalon_spi_master avalon_spi_master
nios_base.connect avalon_spi_master clk reset slave 0x70200000
add_interface spi_master conduit end
set_interface_property spi_master EXPORT_OF avalon_spi_master.spi

nios_base.export_avm avm_test 8 0x70100000 -readLatency 1
