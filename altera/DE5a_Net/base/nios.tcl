#

package require qsys

create_system {nios}
source [ file join [ file dirname [ info script ] ] "device.tcl" ]

source [ file join [ file dirname [ info script ] ] "util/nios_base.tcl" ]
set_instance_parameter_value ram {memorySize} {0x00080000}

source [ file join [ file dirname [ info script ] ] "a10/flash1616.tcl" ]
