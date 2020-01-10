#

package require qsys

create_system {nios}
source {device.tcl}

source {util/nios_base.tcl}
set_instance_parameter_value ram {memorySize} {0x00080000}
source {a10/flash1616.tcl}

nios_base.add_clock_source clk_pcie 250 -clock_export clk_pcie_clock -reset_export clk_pcie_reset
nios_base.export_avm avm_test 8 0x70040000 -readLatency 1 -clk clk_pcie

save_system {nios.qsys}
