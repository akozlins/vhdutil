#

package require qsys

set dir0 [ file dirname [ info script ] ]

source [ file join $dir0 "../device.tcl" ]
source [ file join $dir0 "../util/altera_ip.tcl" ]

proc add_pcie_a10_hip {} {
    set name pcie_a10_hip_0
    set auto_export 1
    set vendor_id 0x1172
    set device_id 0xE001
    set revision_id 1
    set class_code 0xFF0000
    set bar0_width 12

    add_instance ${name} altera_pcie_a10_hip

    if { $bar0_width > 0 } {
        set_instance_parameter_value ${name} {bar0_address_width_hwtcl} ${bar0_width}
        set_instance_parameter_value ${name} {bar0_type_hwtcl} {32-bit non-prefetchable memory}
    }

    set_instance_parameter_value ${name} {vendor_id_hwtcl} ${vendor_id}
    set_instance_parameter_value ${name} {device_id_hwtcl} ${device_id}
    set_instance_parameter_value ${name} {revision_id_hwtcl} ${revision_id}

    set_instance_parameter_value ${name} {class_code_hwtcl} ${class_code}
    set_instance_parameter_value ${name} {subsystem_vendor_id_hwtcl} ${vendor_id}
    set_instance_parameter_value ${name} {subsystem_device_id_hwtcl} ${device_id}

    set_instance_parameter_value ${name} {wrala_hwtcl} {0}

    if { $auto_export } {
        set_instance_property ${name} AUTO_EXPORT {true}
    }
}

set name [ file tail [ file rootname [ info script ] ] ]
create_system $name
add_pcie_a10_hip
save_system [ file join $dir0 "$name.qsys" ]
