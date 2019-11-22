#

create_clock -period  "50.0 MHz" [get_ports CLK_50_B2J]

derive_pll_clocks -create_base_clocks

derive_clock_uncertainty
