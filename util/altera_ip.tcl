#

# ::add_pcie_a10_hip --
#
#   Add ...
#
# Arguments:
#   -mode $     - Hard IP mode (...)
#   -name $     - instance name
#
proc add_pcie_a10_hip { args } {
    set name pcie_a10_hip_0
    set mode 0
    set mm 0
    set auto_export 1
    set vendor_id 0x1172
    set device_id 0xE001
    set revision_id 1
    set class_code 0xFF0000
    set bar0_width 12
    for { set i 0 } { $i < [ llength $args ] } { incr i } {
        switch -- [ lindex $args $i ] {
            -name { incr i
                set name [ lindex $args $i ]
            }
            -mode { incr i
                set mode [ lindex $args $i ]
            }
            -mm { incr i
                set mm [ lindex $args $i ]
                set auto_export 0
            }
            default {
                send_message "Error" "\[add_pcie_a10_hip\] invalid argument '[ lindex $args $i ]'"
            }
        }
    }

    add_instance ${name} altera_pcie_a10_hip

    set_instance_parameter_value ${name} {wrala_hwtcl} ${mode}
    if { $mm > 0 } {
        set_instance_parameter_value ${name} {interface_type_hwtcl} {Avalon-MM}
        set_instance_parameter_value ${name} {avmm_addr_width_hwtcl} ${mm}
    }

    if { $bar0_width > 0 } {
        set_instance_parameter_value ${name} {bar0_type_hwtcl} {32-bit non-prefetchable memory}
        set_instance_parameter_value ${name} {bar0_address_width_hwtcl} ${bar0_width}
        set_instance_parameter_value ${name} {bar1_type_hwtcl} {Disabled}
        set_instance_parameter_value ${name} {bar1_address_width_hwtcl} 0
        set_instance_parameter_value ${name} {bar2_type_hwtcl} {Disabled}
        set_instance_parameter_value ${name} {bar2_address_width_hwtcl} 0
        set_instance_parameter_value ${name} {bar3_type_hwtcl} {Disabled}
        set_instance_parameter_value ${name} {bar3_address_width_hwtcl} 0
        set_instance_parameter_value ${name} {bar4_type_hwtcl} {Disabled}
        set_instance_parameter_value ${name} {bar4_address_width_hwtcl} 0
        set_instance_parameter_value ${name} {bar5_type_hwtcl} {Disabled}
        set_instance_parameter_value ${name} {bar5_address_width_hwtcl} 0
    }

    set_instance_parameter_value ${name} {vendor_id_hwtcl} ${vendor_id}
    set_instance_parameter_value ${name} {device_id_hwtcl} ${device_id}
    set_instance_parameter_value ${name} {revision_id_hwtcl} ${revision_id}

    set_instance_parameter_value ${name} {class_code_hwtcl} ${class_code}
    set_instance_parameter_value ${name} {subsystem_vendor_id_hwtcl} ${vendor_id}
    set_instance_parameter_value ${name} {subsystem_device_id_hwtcl} ${device_id}

    set_instance_parameter_value ${name} {maximum_payload_size_hwtcl} {128}
    set_instance_parameter_value ${name} {completion_timeout_hwtcl} {ABCD}
    set_instance_parameter_value ${name} {advance_error_reporting_hwtcl} {1}

    if { $auto_export } {
        set_instance_property ${name} AUTO_EXPORT {true}
    }
}
