#

create_clock -period "40.000 ns" -name {altera_reserved_tck} {altera_reserved_tck}

# JTAG Signal Constraints
# constrain the TDI TMS and TDO ports - (modified from timequest SDC cookbook)
set_input_delay -clock altera_reserved_tck 5 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck 5 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck -clock_fall -fall -max 5 [get_ports altera_reserved_tdo]

create_clock -name {clkin_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports { clkin_50 }]
create_clock -name {clk_125_p} -period 8.000 -waveform { 0.000 4.000 } [get_ports { clk_125_p }]
create_clock -name {clkintop_p[0]} -period 10.000 -waveform { 0.000 5.000 } [get_ports { clkintop_p[0] }]
create_clock -name {clkintop_p[1]} -period 8.000 -waveform { 0.000 4.000 } [get_ports { clkintop_p[1] }]
create_clock -name {clkinbot_p[1]} -period 8.000 -waveform { 0.000 4.000 } [get_ports { clkinbot_p[1] }]

derive_pll_clocks -create_base_clocks

derive_clock_uncertainty
