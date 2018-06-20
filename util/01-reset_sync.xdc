#!/bin/tclsh

foreach cell [ get_cells -hier -filter {ref_name==reset_sync || orig_ref_name==reset_sync} ] {
    set_false_path -to [ get_pins "$cell/i_ff_sync/ff_reg*/CLR" ]
}
