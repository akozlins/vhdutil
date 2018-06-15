#!/bin/tclsh

foreach cell [ get_cells -hier -filter {ref_name==clkdiv || orig_ref_name==clkdiv} ] {
    set P [ get_property P $cell ]
    create_generated_clock -source [ get_pins "$cell/clk" ] -divide_by $P [ get_pins "$cell/clkout" ]
}
