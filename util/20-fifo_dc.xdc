#!/bin/tclsh

foreach cell [ get_cells -hier -filter {ref_name==fifo_dc || orig_ref_name==fifo_dc} ] {
    set from_cells [ get_cells "$cell/rgray_reg\[*\]" ]
    set to_cells [ get_cells "$cell/i_wrgray/ff_reg\[0\]\[*\]" ]
    set_bus_skew \
        -from $from_cells -to $to_cells \
        [ get_property PERIOD [ get_clocks -of_objects $to_cells ] ]
    set_max_delay -datapath_only \
        -from $from_cells -to $to_cells \
        [ get_property PERIOD [ get_clocks -of_objects $from_cells ] ]
}

foreach cell [ get_cells -hier -filter {ref_name==fifo_dc || orig_ref_name==fifo_dc} ] {
    set from_cells [ get_cells "$cell/wgray_reg\[*\]" ]
    set to_cells [ get_cells "$cell/i_rwgray/ff_reg\[0\]\[*\]" ]
    set_bus_skew \
        -from $from_cells -to $to_cells \
        [ get_property PERIOD [ get_clocks -of_objects $to_cells ] ]
    set_max_delay -datapath_only \
        -from $from_cells -to $to_cells \
        [ get_property PERIOD [ get_clocks -of_objects $from_cells ] ]
}
