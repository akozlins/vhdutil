#

create_clock -period  "50.0 MHz" [get_ports CLK_50_B2J]

derive_pll_clocks -create_base_clocks

derive_clock_uncertainty



# flash
#set_max_skew -from [ get_ports FLASH_* ] 10ns
#set_max_skew -to [ get_ports FLASH_* ] 10ns
