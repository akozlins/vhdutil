#!/bin/sh
# \
exec tclsh "$0" "$@"

namespace eval device_test {

proc set_global_assignment { args } {
    if { [ string equal [ lindex $args 0 ] "-name" ] != 1 } return
    set name [ lindex $args 1 ]
    set value [ lindex $args 2 ]
    switch $name {
        QIP_FILE {
#            puts stderr "I [set_global_assignment] source '$value'"
            if { [ file exists $value ] == 0 } {
                puts stderr "E [set_global_assignment] file '$value' does not exist"
            } else {
                source $value
            }
        }
        SOURCE_TCL_SCRIPT_FILE {
#            puts stderr "I [set_global_assignment] source '$value'"
#            source $value
        }
        VHDL_FILE {
            puts "$value"
        }
    }
}

proc set_instance_assignment { args } {
}

proc set_location_assignment { args } {
}

proc set_parameter { args } {
}

proc trace_quartus_qip_path { args } {
    set ::quartus(qip_path) [ file dirname [ info script ] ]
}

trace add variable ::quartus(qip_path) read trace_quartus_qip_path

source "top.qsf"

trace remove variable ::quartus(qip_path) read trace_quartus_qip_path

}
