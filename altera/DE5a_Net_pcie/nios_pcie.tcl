#

source "util/altera_ip.tcl"

add_pcie_a10_hip -name pcie -mode 12 -mm 32

add_instance pcie_ram altera_avalon_onchip_memory2
set_instance_parameter_value pcie_ram {memorySize} {0x00001000}



add_connection pcie.app_nreset_status pcie_ram.reset1
add_connection pcie.coreclkout_hip pcie_ram.clk1
add_connection pcie.rxm_bar0 pcie_ram.s1



add_interface pcie_hip_serial conduit end
set_interface_property pcie_hip_serial EXPORT_OF pcie.hip_serial
add_interface pcie_npor conduit end
set_interface_property pcie_npor EXPORT_OF pcie.npor
add_interface pcie_refclk clock sink
set_interface_property pcie_refclk EXPORT_OF pcie.refclk
