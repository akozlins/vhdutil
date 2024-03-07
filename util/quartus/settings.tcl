# settings

set_global_assignment -name PROJECT_IP_REGENERATION_POLICY NEVER_REGENERATE_IP
# -> Assignments / Settings / Advanced Settings

# implement state machines that can recover gracefully from an illegal state
set_global_assignment -name SAFE_STATE_MACHINE ON
# don't replace shift registers with altshift_taps megafunction (see Quartus User Guide / Auto Shift Register Replacement)
# (<>)
set_global_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION OFF

# -> Assignments / Settings / VHDL Input

set_global_assignment -name VHDL_INPUT_VERSION VHDL_2008

set_global_assignment -name SAVE_DISK_SPACE OFF

##
