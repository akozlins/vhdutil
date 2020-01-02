#

source "util/altera_ip.tcl"

add_instance pcie_bridge altera_avalon_mm_clock_crossing_bridge
add_pcie_a10_hip -name pcie -mode 7 -mm 32
add_instance pcie_ram altera_avalon_onchip_memory2
add_instance pcie_dma altera_avalon_dma



# ----------------------------------------------------------------
# RAM
set_instance_parameter_value pcie_ram {memorySize} {0x00001000}

# clock and reset
add_connection pcie.coreclkout_hip pcie_ram.clk1
add_connection pcie.app_nreset_status pcie_ram.reset1



# ----------------------------------------------------------------
# DMA
set_instance_parameter_value pcie_dma {allowByteTransactions} {0}
set_instance_parameter_value pcie_dma {allowHalfWordTransactions} {0}
set_instance_parameter_value pcie_dma {allowWordTransactions} {1}
set_instance_parameter_value pcie_dma {allowDoubleWordTransactions} {0}
set_instance_parameter_value pcie_dma {allowQuadWordTransactions} {0}

# clock and reset
add_connection pcie.coreclkout_hip pcie_dma.clk
add_connection pcie.app_nreset_status pcie_dma.reset

# irq
add_connection cpu.irq pcie_dma.irq
set_connection_parameter_value cpu.irq/pcie_dma.irq irqNumber 13

# dma -> ram
add_connection pcie_dma.read_master pcie_ram.s1
add_connection pcie_dma.write_master pcie_ram.s1



# ----------------------------------------------------------------
# PCIe
set_instance_parameter_value pcie {bar2_type_hwtcl} {32-bit non-prefetchable memory}

add_interface pcie_hip_ctrl conduit end
set_interface_property pcie_hip_ctrl EXPORT_OF pcie.hip_ctrl
add_interface pcie_hip_serial conduit end
set_interface_property pcie_hip_serial EXPORT_OF pcie.hip_serial
add_interface pcie_npor conduit end
set_interface_property pcie_npor EXPORT_OF pcie.npor
add_interface pcie_refclk clock sink
set_interface_property pcie_refclk EXPORT_OF pcie.refclk

# bar0 -> ram.slave
add_connection pcie_bridge.m0 pcie_ram.s1
set_connection_parameter_value pcie_bridge.m0/pcie_ram.s1 baseAddress {0x00000000}

# bar2 -> cra, txs
add_connection pcie.rxm_bar2 pcie.cra
set_connection_parameter_value pcie.rxm_bar2/pcie.cra baseAddress {0x00010000}
add_connection pcie.rxm_bar2 pcie.txs
set_connection_parameter_value pcie.rxm_bar2/pcie.txs baseAddress {0x01000000}



# ----------------------------------------------------------------
# Bridge
set_instance_parameter_value pcie_bridge {USE_AUTO_ADDRESS_WIDTH} {1}

# clock and reset (bridge slave port)
add_connection clk.clk pcie_bridge.s0_clk
add_connection clk.clk_reset pcie_bridge.s0_reset

# cpu -> bridge
add_connection cpu.data_master pcie_bridge.s0
set_connection_parameter_value cpu.data_master/pcie_bridge.s0 baseAddress {0x72000000}

# clock and reset (bridge master port)
add_connection pcie.coreclkout_hip pcie_bridge.m0_clk
add_connection pcie.app_nreset_status pcie_bridge.m0_reset

# bridge -> ram
add_connection pcie.rxm_bar0 pcie_ram.s1

# bridge -> cra, txs
add_connection pcie_bridge.m0 pcie.cra
add_connection pcie_bridge.m0 pcie.txs

# bridge -> dma
add_connection pcie_bridge.m0 pcie_dma.control_port_slave
set_connection_parameter_value pcie_bridge.m0/pcie_dma.control_port_slave baseAddress {0x00020000}
