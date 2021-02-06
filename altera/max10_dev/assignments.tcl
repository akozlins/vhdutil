#

set_location_assignment PIN_120 -to i_sw[0]
set_location_assignment PIN_124 -to i_sw[1]
set_location_assignment PIN_127 -to i_sw[2]
set_location_assignment PIN_130 -to i_sw[3]
set_location_assignment PIN_131 -to i_sw[4]

set_instance_assignment -name IO_STANDARD "2.5 V" -to i_sw[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to i_sw[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to i_sw[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to i_sw[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to i_sw[4]

set_location_assignment PIN_132 -to o_led_n[0]
set_location_assignment PIN_134 -to o_led_n[1]
set_location_assignment PIN_135 -to o_led_n[2]
set_location_assignment PIN_140 -to o_led_n[3]
set_location_assignment PIN_141 -to o_led_n[4]

set_instance_assignment -name IO_STANDARD "2.5 V" -to o_led_n[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to o_led_n[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to o_led_n[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to o_led_n[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to o_led_n[4]

set_location_assignment PIN_121 -to i_reset_n
set_instance_assignment -name IO_STANDARD "2.5 V" -to i_reset_n

set_location_assignment PIN_27 -to i_clk_50
