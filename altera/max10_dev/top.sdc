#

create_clock -name i_clk_50 -period "50 MHz" [ get_ports i_clk_50 ]

derive_clock_uncertainty

derive_pll_clocks
