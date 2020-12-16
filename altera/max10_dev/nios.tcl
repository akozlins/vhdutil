#

create_system {nios}

source {device.tcl}

source {util/nios_base.tcl}
set_instance_parameter_value ram {memorySize} {0x00008000}

source "nios_adc.tcl"
source "nios_ufm.tcl"
