#

create_clock -period "50.0 MHz" [get_ports CLK_50_B2J]
create_clock -period "100.0 MHz" [get_ports PCIE_REFCLK_p]

derive_pll_clocks -create_base_clocks

derive_clock_uncertainty
