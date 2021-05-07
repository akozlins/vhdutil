#

# Configuration mode: Single Uncompressed Image with Memory Initialization
set_global_assignment -name INTERNAL_FLASH_UPDATE_MODE "SINGLE IMAGE WITH ERAM"

proc set_assignment { name pins } {
    set i 0
    foreach pin $pins {
        set_location_assignment $pin -to $name\[$i\]
        set_instance_assignment -name IO_STANDARD "2.5 V" -to $name\[$i\]
        set i [ expr $i + 1 ]
    }
}

set_assignment i_sw { PIN_120 PIN_124 PIN_127 PIN_130 PIN_131 }
set_assignment o_led_n { PIN_132 PIN_134 PIN_135 PIN_140 PIN_141 }

set_location_assignment PIN_121 -to i_reset_n
set_instance_assignment -name IO_STANDARD "2.5 V" -to i_reset_n

set_location_assignment PIN_27 -to i_clk_50
