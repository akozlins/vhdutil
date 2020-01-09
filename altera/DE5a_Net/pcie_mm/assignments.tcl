#

set_instance_assignment -name XCVR_REFCLK_PIN_TERMINATION DC_COUPLING_EXTERNAL_RESISTOR -to PCIE_REFCLK_p
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to PCIE_TX_p
set_instance_assignment -name XCVR_IO_PIN_TERMINATION 100_OHMS -to PCIE_RX_p

set_location_assignment PIN_AT25 -to PCIE_PERST_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to PCIE_PERST_n
set_location_assignment PIN_AH40 -to PCIE_REFCLK_p
set_instance_assignment -name IO_STANDARD HCSL -to PCIE_REFCLK_p
set_location_assignment PIN_AU42 -to PCIE_RX_p[0]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_RX_p[0]
set_location_assignment PIN_AR42 -to PCIE_RX_p[1]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_RX_p[1]
set_location_assignment PIN_AN42 -to PCIE_RX_p[2]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_RX_p[2]
set_location_assignment PIN_AL42 -to PCIE_RX_p[3]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_RX_p[3]
set_location_assignment PIN_AJ42 -to PCIE_RX_p[4]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_RX_p[4]
set_location_assignment PIN_AG42 -to PCIE_RX_p[5]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_RX_p[5]
set_location_assignment PIN_AE42 -to PCIE_RX_p[6]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_RX_p[6]
set_location_assignment PIN_AC42 -to PCIE_RX_p[7]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_RX_p[7]
set_location_assignment PIN_AV44 -to PCIE_TX_p[0]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_TX_p[0]
set_location_assignment PIN_AT44 -to PCIE_TX_p[1]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_TX_p[1]
set_location_assignment PIN_AP44 -to PCIE_TX_p[2]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_TX_p[2]
set_location_assignment PIN_AM44 -to PCIE_TX_p[3]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_TX_p[3]
set_location_assignment PIN_AK44 -to PCIE_TX_p[4]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_TX_p[4]
set_location_assignment PIN_AH44 -to PCIE_TX_p[5]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_TX_p[5]
set_location_assignment PIN_AF44 -to PCIE_TX_p[6]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_TX_p[6]
set_location_assignment PIN_AD44 -to PCIE_TX_p[7]
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to PCIE_TX_p[7]
