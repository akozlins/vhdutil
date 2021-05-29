#

create_clock -period "125 MHz" [ get_ports i_si5342_clk_125 ]
create_clock -period "50 MHz" [ get_ports i_si5342_clk_50 ]



derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
