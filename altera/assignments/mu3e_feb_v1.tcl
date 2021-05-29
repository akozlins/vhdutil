# base frontend Stratix-IV assignments

set_global_assignment -name FAMILY "Stratix IV"
set_global_assignment -name DEVICE EP4SGX70HF35C3
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "15 MM HEAT SINK WITH STILL AIR"
set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"



set_instance_assignment -name IO_STANDARD LVDS -to data_in_A_0[3]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_A_0[2]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_A_0[1]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_A_0[0]
set_location_assignment PIN_AH28 -to data_in_A_0[3]
set_location_assignment PIN_AB27 -to data_in_A_0[2]
set_location_assignment PIN_AD26 -to data_in_A_0[1]
set_location_assignment PIN_AC26 -to data_in_A_0[0]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_A_1[3]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_A_1[2]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_A_1[1]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_A_1[0]
set_location_assignment PIN_AJ26 -to data_in_A_1[3]
set_location_assignment PIN_AE28 -to data_in_A_1[2]
set_location_assignment PIN_AF28 -to data_in_A_1[1]
set_location_assignment PIN_AG29 -to data_in_A_1[0]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_A_2[2]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_A_2[1]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_A_2[0]
set_location_assignment PIN_AH26 -to data_in_A_2[2]
set_location_assignment PIN_AJ26 -to data_in_A_2[1]
set_location_assignment PIN_AH28 -to data_in_A_2[0]

set_instance_assignment -name IO_STANDARD LVDS -to data_in_B_0[3]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_B_0[2]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_B_0[1]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_B_0[0]
set_location_assignment PIN_G28 -to data_in_B_0[3]
set_location_assignment PIN_L29 -to data_in_B_0[2]
set_location_assignment PIN_K28 -to data_in_B_0[1]
set_location_assignment PIN_L30 -to data_in_B_0[0]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_B_1[3]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_B_1[2]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_B_1[1]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_B_1[0]
set_location_assignment PIN_F26 -to data_in_B_1[3]
set_location_assignment PIN_L26 -to data_in_B_1[2]
set_location_assignment PIN_J28 -to data_in_B_1[1]
set_location_assignment PIN_H29 -to data_in_B_1[0]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_B_2[2]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_B_2[1]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_B_2[0]
set_location_assignment PIN_G26 -to data_in_B_2[2]
set_location_assignment PIN_F26 -to data_in_B_2[1]
set_location_assignment PIN_G28 -to data_in_B_2[0]

set_instance_assignment -name IO_STANDARD LVDS -to data_in_C_0[3]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_C_0[2]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_C_0[1]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_C_0[0]
set_location_assignment PIN_J5 -to data_in_C_0[3]
set_location_assignment PIN_C6 -to data_in_C_0[2]
set_location_assignment PIN_C7 -to data_in_C_0[1]
set_location_assignment PIN_D7 -to data_in_C_0[0]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_C_1[3]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_C_1[2]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_C_1[1]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_C_1[0]
set_location_assignment PIN_J7 -to data_in_C_1[3]
set_location_assignment PIN_F7 -to data_in_C_1[2]
set_location_assignment PIN_G7 -to data_in_C_1[1]
set_location_assignment PIN_F9 -to data_in_C_1[0]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_C_2[2]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_C_2[1]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_C_2[0]
set_location_assignment PIN_G9 -to data_in_C_2[2]
set_location_assignment PIN_J7 -to data_in_C_2[1]
set_location_assignment PIN_J5 -to data_in_C_2[0]

set_instance_assignment -name IO_STANDARD LVDS -to data_in_D_0[3]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_D_0[2]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_D_0[1]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_D_0[0]
set_location_assignment PIN_AN24 -to data_in_D_0[3]
set_location_assignment PIN_AK24 -to data_in_D_0[2]
set_location_assignment PIN_AJ23 -to data_in_D_0[1]
set_location_assignment PIN_AF21 -to data_in_D_0[0]
set_location_assignment PIN_AL24 -to "data_in_D_0[2](n)"
set_location_assignment PIN_AK23 -to "data_in_D_0[1](n)"
set_location_assignment PIN_AG21 -to "data_in_D_0[0](n)"
set_instance_assignment -name IO_STANDARD LVDS -to data_in_D_1[3]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_D_1[2]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_D_1[1]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_D_1[0]
set_location_assignment PIN_AN26 -to data_in_D_1[3]
set_location_assignment PIN_AN23 -to data_in_D_1[2]
set_location_assignment PIN_AL25 -to data_in_D_1[1]
set_location_assignment PIN_AL23 -to data_in_D_1[0]
set_location_assignment PIN_AP23 -to "data_in_D_1[2](n)"
set_location_assignment PIN_AM25 -to "data_in_D_1[1](n)"
set_location_assignment PIN_AM23 -to "data_in_D_1[0](n)"
set_instance_assignment -name IO_STANDARD LVDS -to data_in_D_2[2]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_D_2[1]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_D_2[0]
set_location_assignment PIN_AN27 -to data_in_D_2[2]
set_location_assignment PIN_AN26 -to data_in_D_2[1]
set_location_assignment PIN_AN24 -to data_in_D_2[0]
set_location_assignment PIN_AP27 -to "data_in_D_2[2](n)"
set_location_assignment PIN_AP26 -to "data_in_D_2[1](n)"
set_location_assignment PIN_AP24 -to "data_in_D_2[0](n)"

set_instance_assignment -name IO_STANDARD LVDS -to data_in_E_0[3]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_E_0[2]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_E_0[1]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_E_0[0]
set_location_assignment PIN_AM7 -to data_in_E_0[3]
set_location_assignment PIN_AF6 -to data_in_E_0[2]
set_location_assignment PIN_AG9 -to data_in_E_0[1]
set_location_assignment PIN_AJ9 -to data_in_E_0[0]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_E_1[3]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_E_1[2]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_E_1[1]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_E_1[0]
set_location_assignment PIN_AM6 -to data_in_E_1[3]
set_location_assignment PIN_AJ7 -to data_in_E_1[2]
set_location_assignment PIN_AJ8 -to data_in_E_1[1]
set_location_assignment PIN_AK8 -to data_in_E_1[0]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_E_2[2]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_E_2[1]
set_instance_assignment -name IO_STANDARD LVDS -to data_in_E_2[0]
set_location_assignment PIN_AK6 -to data_in_E_2[2]
set_location_assignment PIN_AM6 -to data_in_E_2[1]
set_location_assignment PIN_AM7 -to data_in_E_2[0]

set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_A_0[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_A_0[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_A_0[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_A_0[3]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_A_1[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_A_1[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_A_1[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_A_1[3]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_A_2[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_A_2[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_A_2[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_B_0[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_B_0[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_B_0[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_B_0[3]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_B_1[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_B_1[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_B_1[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_B_1[3]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_B_2[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_B_2[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_B_2[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_C_0[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_C_0[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_C_0[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_C_0[3]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_C_1[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_C_1[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_C_1[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_C_1[3]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_C_2[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_C_2[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_C_2[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_E_0[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_E_0[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_E_0[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_E_0[3]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_E_1[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_E_1[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_E_1[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_E_1[3]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_E_2[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_E_2[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to data_in_E_2[2]

set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_data[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_data[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_data[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_data[0]
set_location_assignment PIN_U31 -to tx_data[3]
set_location_assignment PIN_W31 -to tx_data[2]
set_location_assignment PIN_AE31 -to tx_data[1]
set_location_assignment PIN_AG31 -to tx_data[0]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_data[0]
set_location_assignment PIN_V33 -to rx_data[3]
set_location_assignment PIN_Y33 -to rx_data[2]
set_location_assignment PIN_AF33 -to rx_data[1]
set_location_assignment PIN_AH33 -to rx_data[0]

set_instance_assignment -name IO_STANDARD LVDS -to transceiver_pll_clock
set_location_assignment PIN_AB33 -to transceiver_pll_clock

set_instance_assignment -name IO_STANDARD LVDS -to monitor_A[2]
set_instance_assignment -name IO_STANDARD LVDS -to monitor_A[1]
set_instance_assignment -name IO_STANDARD LVDS -to monitor_A[0]
set_location_assignment PIN_AM28 -to monitor_A[2]
set_location_assignment PIN_AL28 -to monitor_A[1]
set_location_assignment PIN_AJ28 -to monitor_A[0]
set_instance_assignment -name IO_STANDARD LVDS -to monitor_B[2]
set_instance_assignment -name IO_STANDARD LVDS -to monitor_B[1]
set_instance_assignment -name IO_STANDARD LVDS -to monitor_B[0]
set_location_assignment PIN_C28 -to monitor_B[2]
set_location_assignment PIN_D28 -to monitor_B[1]
set_location_assignment PIN_F28 -to monitor_B[0]
set_instance_assignment -name IO_STANDARD LVDS -to monitor_C[2]
set_instance_assignment -name IO_STANDARD LVDS -to monitor_C[1]
set_instance_assignment -name IO_STANDARD LVDS -to monitor_C[0]
set_location_assignment PIN_H12 -to monitor_C[2]
set_location_assignment PIN_G11 -to monitor_C[1]
set_location_assignment PIN_E11 -to monitor_C[0]
set_location_assignment PIN_G12 -to "monitor_C[2](n)"
set_location_assignment PIN_F11 -to "monitor_C[1](n)"
set_location_assignment PIN_D11 -to "monitor_C[0](n)"
set_instance_assignment -name IO_STANDARD LVDS -to monitor_D[2]
set_instance_assignment -name IO_STANDARD LVDS -to monitor_D[1]
set_instance_assignment -name IO_STANDARD LVDS -to monitor_D[0]
set_location_assignment PIN_AN12 -to monitor_D[2]
set_location_assignment PIN_AN11 -to monitor_D[1]
set_location_assignment PIN_AL11 -to monitor_D[0]
set_location_assignment PIN_AP12 -to "monitor_D[2](n)"
set_location_assignment PIN_AP11 -to "monitor_D[1](n)"
set_location_assignment PIN_AM11 -to "monitor_D[0](n)"
set_instance_assignment -name IO_STANDARD LVDS -to monitor_E[2]
set_instance_assignment -name IO_STANDARD LVDS -to monitor_E[1]
set_instance_assignment -name IO_STANDARD LVDS -to monitor_E[0]
set_location_assignment PIN_AE15 -to monitor_E[2]
set_location_assignment PIN_AH14 -to monitor_E[1]
set_location_assignment PIN_AH13 -to monitor_E[0]

set_instance_assignment -name IO_STANDARD LVDS -to lvds_clk_B
set_location_assignment PIN_AA7 -to lvds_clk_B
set_instance_assignment -name IO_STANDARD LVDS -to lvds_clk_A
set_location_assignment PIN_AA28 -to lvds_clk_A

set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_out[11]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_out[10]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_out[9]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_out[8]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_out[7]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_out[6]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_out[5]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_out[4]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_out[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_out[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_out[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_out[0]
set_location_assignment PIN_E31 -to transceiver_pod_out[11]
set_location_assignment PIN_G31 -to transceiver_pod_out[10]
set_location_assignment PIN_N31 -to transceiver_pod_out[9]
set_location_assignment PIN_R31 -to transceiver_pod_out[8]
set_location_assignment PIN_E4 -to transceiver_pod_out[7]
set_location_assignment PIN_G4 -to transceiver_pod_out[6]
set_location_assignment PIN_N4 -to transceiver_pod_out[5]
set_location_assignment PIN_R4 -to transceiver_pod_out[4]
set_location_assignment PIN_U4 -to transceiver_pod_out[3]
set_location_assignment PIN_W4 -to transceiver_pod_out[2]
set_location_assignment PIN_AE4 -to transceiver_pod_out[1]
set_location_assignment PIN_AG4 -to transceiver_pod_out[0]

set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_in[11]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_in[10]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_in[9]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_in[8]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_in[7]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_in[6]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_in[5]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_in[4]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_in[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_in[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_in[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to transceiver_pod_in[0]
set_location_assignment PIN_F33 -to transceiver_pod_in[11]
set_location_assignment PIN_H33 -to transceiver_pod_in[10]
set_location_assignment PIN_P33 -to transceiver_pod_in[9]
set_location_assignment PIN_T33 -to transceiver_pod_in[8]
set_location_assignment PIN_F2 -to transceiver_pod_in[7]
set_location_assignment PIN_H2 -to transceiver_pod_in[6]
set_location_assignment PIN_P2 -to transceiver_pod_in[5]
set_location_assignment PIN_T2 -to transceiver_pod_in[4]
set_location_assignment PIN_V2 -to transceiver_pod_in[3]
set_location_assignment PIN_Y2 -to transceiver_pod_in[2]
set_location_assignment PIN_AF2 -to transceiver_pod_in[1]
set_location_assignment PIN_AH2 -to transceiver_pod_in[0]

set_instance_assignment -name IO_STANDARD LVDS -to transceiver_pod_pll_clock_left
set_location_assignment PIN_K2 -to transceiver_pod_pll_clock_left
set_instance_assignment -name IO_STANDARD LVDS -to transceiver_pod_pll_clock_right
set_location_assignment PIN_K33 -to transceiver_pod_pll_clock_right

set_instance_assignment -name IO_STANDARD LVDS -to clock_A
set_instance_assignment -name IO_STANDARD LVDS -to clock_B
set_instance_assignment -name IO_STANDARD LVDS -to clock_C
set_instance_assignment -name IO_STANDARD LVDS -to clock_D
set_instance_assignment -name IO_STANDARD LVDS -to clock_E
set_location_assignment PIN_AA26 -to clock_A
set_location_assignment PIN_M26 -to clock_B
set_location_assignment PIN_H9 -to clock_C
set_location_assignment PIN_R11 -to clock_D
set_location_assignment PIN_AA11 -to clock_E

set_instance_assignment -name MEMORY_INTERFACE_DATA_PIN_GROUP 4 -from clock_A -to clock_A -disable
set_instance_assignment -name MEMORY_INTERFACE_DATA_PIN_GROUP 4 -from clock_B -to clock_B -disable
set_instance_assignment -name MEMORY_INTERFACE_DATA_PIN_GROUP 4 -from clock_C -to clock_C -disable
set_instance_assignment -name MEMORY_INTERFACE_DATA_PIN_GROUP 4 -from clock_D -to clock_D -disable
set_instance_assignment -name MEMORY_INTERFACE_DATA_PIN_GROUP 4 -from clock_E -to clock_E -disable

set_instance_assignment -name IO_STANDARD LVDS -to fast_reset_A
set_instance_assignment -name IO_STANDARD LVDS -to fast_reset_B
set_instance_assignment -name IO_STANDARD LVDS -to fast_reset_C
set_instance_assignment -name IO_STANDARD LVDS -to fast_reset_D
set_instance_assignment -name IO_STANDARD LVDS -to fast_reset_E
set_location_assignment PIN_W24 -to fast_reset_A
set_location_assignment PIN_N25 -to fast_reset_B
set_location_assignment PIN_N12 -to fast_reset_C
set_location_assignment PIN_N10 -to fast_reset_D
set_location_assignment PIN_AA9 -to fast_reset_E

set_instance_assignment -name IO_STANDARD LVDS -to systemclock
set_location_assignment PIN_B15 -to systemclock
set_instance_assignment -name IO_STANDARD LVDS -to clk_125_top
set_location_assignment PIN_B17 -to clk_125_top
set_instance_assignment -name IO_STANDARD LVDS -to clk_125_bottom
set_location_assignment PIN_AN17 -to clk_125_bottom
set_instance_assignment -name IO_STANDARD LVDS -to systemclock_bottom
set_location_assignment PIN_AN15 -to systemclock_bottom

set_instance_assignment -name IO_STANDARD "1.8 V" -to chip_reset_A
set_instance_assignment -name IO_STANDARD "1.8 V" -to chip_reset_B
set_instance_assignment -name IO_STANDARD "1.8 V" -to chip_reset_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to chip_reset_E
set_instance_assignment -name IO_STANDARD "1.8 V" -to chip_reset_C
set_location_assignment PIN_AP10 -to chip_reset_A
set_location_assignment PIN_AL22 -to chip_reset_B
set_location_assignment PIN_AP8 -to chip_reset_C
set_location_assignment PIN_AJ21 -to chip_reset_D
set_location_assignment PIN_AF14 -to chip_reset_E

set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_Load_A[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_Load_A[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_Load_A[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_Load_B[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_Load_B[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_Load_B[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_Load_C[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_Load_C[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_Load_C[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_Load_D[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_Load_D[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_Load_D[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_Load_E[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_Load_E[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_Load_E[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_SCK_A
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_SCK_B
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_SCK_C
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_SCK_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_SCK_E
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_SDI_A
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_SDI_B
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_SDI_C
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_SDI_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_SDI_E
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_SDO_A
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_SDO_B
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_SDO_C
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_SDO_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_SDO_E
set_location_assignment PIN_AH25 -to SPI_Load_A[2]
set_location_assignment PIN_AJ25 -to SPI_Load_A[1]
set_location_assignment PIN_AL27 -to SPI_Load_A[0]
set_location_assignment PIN_AL26 -to SPI_SCK_A
set_location_assignment PIN_AM26 -to SPI_SDI_A
set_location_assignment PIN_AP25 -to SPI_SDO_A
set_location_assignment PIN_AN29 -to SPI_Load_B[2]
set_location_assignment PIN_AP28 -to SPI_Load_B[1]
set_location_assignment PIN_AN30 -to SPI_Load_B[0]
set_location_assignment PIN_AP30 -to SPI_SCK_B
set_location_assignment PIN_AP31 -to SPI_SDI_B
set_location_assignment PIN_AP29 -to SPI_SDO_B
set_location_assignment PIN_AP6 -to SPI_Load_C[2]
set_location_assignment PIN_AP4 -to SPI_Load_C[1]
set_location_assignment PIN_AP5 -to SPI_Load_C[0]
set_location_assignment PIN_AN5 -to SPI_SCK_C
set_location_assignment PIN_AN6 -to SPI_SDI_C
set_location_assignment PIN_AP7 -to SPI_SDO_C
set_location_assignment PIN_AP22 -to SPI_Load_D[2]
set_location_assignment PIN_AH20 -to SPI_Load_D[1]
set_location_assignment PIN_AF20 -to SPI_Load_D[0]
set_location_assignment PIN_AM22 -to SPI_SCK_D
set_location_assignment PIN_AJ22 -to SPI_SDI_D
set_location_assignment PIN_AH22 -to SPI_SDO_D
set_location_assignment PIN_AH11 -to SPI_Load_E[2]
set_location_assignment PIN_AJ10 -to SPI_Load_E[1]
set_location_assignment PIN_AJ12 -to SPI_Load_E[0]
set_location_assignment PIN_AK12 -to SPI_SCK_E
set_location_assignment PIN_AL9 -to SPI_SDI_E
set_location_assignment PIN_AL10 -to SPI_SDO_E

set_instance_assignment -name IO_STANDARD "1.8 V" -to reset_n
set_location_assignment PIN_A5 -to reset_n

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to transmitter_pod_sda
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to transmitter_pod_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to transmitter_pod_reset
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to transmitter_pod_interrupt
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to receiver_pod_sda
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to receiver_pod_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to receiver_pod_reset
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to receiver_pod_interrupt
set_location_assignment PIN_AF19 -to transmitter_pod_sda
set_location_assignment PIN_AE19 -to transmitter_pod_scl
set_location_assignment PIN_AE18 -to transmitter_pod_reset
set_location_assignment PIN_AF18 -to transmitter_pod_interrupt
set_location_assignment PIN_AN18 -to receiver_pod_sda
set_location_assignment PIN_AL18 -to receiver_pod_scl
set_location_assignment PIN_AP18 -to receiver_pod_reset
set_location_assignment PIN_AM18 -to receiver_pod_interrupt

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to testpulse_spi_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to testpulse_spi_din
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to testpulse_spi_dout
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to testpulse_spi_load
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to testpulse_spi_load2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to test_pulse_A
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to test_pulse_B
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to test_pulse_C
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to test_pulse_D
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to test_pulse_E
set_location_assignment PIN_AF16 -to testpulse_spi_clk
set_location_assignment PIN_AF17 -to testpulse_spi_din
set_location_assignment PIN_AE17 -to testpulse_spi_load
set_location_assignment PIN_AE16 -to testpulse_spi_load2
set_location_assignment PIN_AP14 -to test_pulse_A
set_location_assignment PIN_AM15 -to test_pulse_B
set_location_assignment PIN_AL14 -to test_pulse_C
set_location_assignment PIN_AL17 -to test_pulse_D
set_location_assignment PIN_AK17 -to test_pulse_E

set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_csn
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[4]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[5]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[6]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[7]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_d_cn
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_wen
set_location_assignment PIN_B30 -to lcd_csn
set_location_assignment PIN_A23 -to lcd_data[0]
set_location_assignment PIN_A24 -to lcd_data[1]
set_location_assignment PIN_A25 -to lcd_data[2]
set_location_assignment PIN_A26 -to lcd_data[3]
set_location_assignment PIN_A27 -to lcd_data[4]
set_location_assignment PIN_A28 -to lcd_data[5]
set_location_assignment PIN_A29 -to lcd_data[6]
set_location_assignment PIN_A30 -to lcd_data[7]
set_location_assignment PIN_A31 -to lcd_d_cn
set_location_assignment PIN_A22 -to lcd_wen

set_location_assignment PIN_B23 -to FPGA_Test[0]
set_location_assignment PIN_B24 -to FPGA_Test[1]
set_location_assignment PIN_B26 -to FPGA_Test[2]
set_location_assignment PIN_B27 -to FPGA_Test[3]
set_location_assignment PIN_B29 -to FPGA_Test[4]
set_location_assignment PIN_C22 -to FPGA_Test[5]
set_location_assignment PIN_C23 -to FPGA_Test[6]
set_location_assignment PIN_C25 -to FPGA_Test[7]
set_location_assignment PIN_C26 -to PushButton[0]
set_location_assignment PIN_D22 -to PushButton[1]
set_location_assignment PIN_D23 -to LED[0]
set_location_assignment PIN_D24 -to LED[1]
set_location_assignment PIN_D25 -to LED[2]
set_location_assignment PIN_D26 -to LED[3]
set_location_assignment PIN_D27 -to LED[4]
set_location_assignment PIN_E23 -to LED[5]
set_location_assignment PIN_E24 -to LED[6]
set_location_assignment PIN_F21 -to LED[7]
set_location_assignment PIN_F22 -to LED[8]
set_location_assignment PIN_F23 -to LED[9]
set_location_assignment PIN_F25 -to LED[10]
set_location_assignment PIN_G20 -to LED[11]
set_location_assignment PIN_G22 -to LED[12]
set_location_assignment PIN_G23 -to LED[13]
set_location_assignment PIN_G24 -to LED[14]
set_location_assignment PIN_G25 -to LED[15]

set_instance_assignment -name IO_STANDARD LVDS -to clk_spare
set_location_assignment PIN_B18 -to clk_spare

set_instance_assignment -name IO_STANDARD "1.8 V" -to si42_intr_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to si42_lol_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to si42_los_n[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to si42_los_n[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to si42_los_n[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to si42_los_n[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to si42_los_xaxb_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to si42_oe_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to si42_rst_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to si42_spi_cs_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to si42_spi_in
set_instance_assignment -name IO_STANDARD "1.8 V" -to si42_spi_out
set_instance_assignment -name IO_STANDARD "1.8 V" -to si42_spi_sclk
set_location_assignment PIN_A12 -to si42_intr_n
set_location_assignment PIN_A13 -to si42_lol_n
set_location_assignment PIN_B5 -to si42_los_n[3]
set_location_assignment PIN_B6 -to si42_los_n[2]
set_location_assignment PIN_B8 -to si42_los_n[1]
set_location_assignment PIN_B9 -to si42_los_n[0]
set_location_assignment PIN_B11 -to si42_los_xaxb_n
set_location_assignment PIN_B12 -to si42_oe_n
set_location_assignment PIN_C10 -to si42_rst_n
set_location_assignment PIN_C12 -to si42_spi_cs_n
set_location_assignment PIN_D12 -to si42_spi_in
set_location_assignment PIN_D13 -to si42_spi_out
set_location_assignment PIN_H15 -to si42_spi_sclk

set_instance_assignment -name IO_STANDARD "1.8 V" -to si45_fdec
set_instance_assignment -name IO_STANDARD "1.8 V" -to si45_finc
set_instance_assignment -name IO_STANDARD "1.8 V" -to si45_intr_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to si45_lol_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to si45_oe_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to si45_rst_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to si45_spi_cs_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to si45_spi_in
set_instance_assignment -name IO_STANDARD "1.8 V" -to si45_spi_out
set_instance_assignment -name IO_STANDARD "1.8 V" -to si45_spi_sclk
set_location_assignment PIN_J15 -to si45_fdec
set_location_assignment PIN_A14 -to si45_finc
set_location_assignment PIN_C16 -to si45_intr_n
set_location_assignment PIN_C15 -to si45_lol_n
set_location_assignment PIN_D17 -to si45_oe_n
set_location_assignment PIN_D16 -to si45_rst_n
set_location_assignment PIN_D14 -to si45_spi_cs_n
set_location_assignment PIN_E17 -to si45_spi_in
set_location_assignment PIN_F15 -to si45_spi_out
set_location_assignment PIN_F14 -to si45_spi_sclk

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to temperature_i2c_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to temperature_i2c_sda
set_location_assignment PIN_AL16 -to temperature_i2c_scl
set_location_assignment PIN_AM16 -to temperature_i2c_sda

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to QSFP_Int_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to QSFP_LPM
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to QSFP_ModPrs_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to QSFP_ModSel_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to QSFP_Rst_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to QSFP_Scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to QSFP_Sda
set_location_assignment PIN_AP20 -to QSFP_Int_n
set_location_assignment PIN_AK21 -to QSFP_LPM
set_location_assignment PIN_AN20 -to QSFP_ModPrs_n
set_location_assignment PIN_AN21 -to QSFP_ModSel_n
set_location_assignment PIN_AP21 -to QSFP_Rst_n
set_location_assignment PIN_AM21 -to QSFP_Scl
set_location_assignment PIN_AM20 -to QSFP_Sda

set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 2.5-V SSTL CLASS I" -to mscb_n[0]
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 2.5-V SSTL CLASS I" -to mscb_p[0]
set_location_assignment PIN_AM30 -to mscb_n[0]
set_location_assignment PIN_AM29 -to mscb_p[0]

set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_Load_A
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_RB_A
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SDI_A
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SDO_A
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SCK1_A
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SCK2_A
set_location_assignment PIN_AH25 -to CTRL_Load_A
set_location_assignment PIN_AL26 -to CTRL_RB_A
set_location_assignment PIN_AM26 -to CTRL_SDI_A
set_location_assignment PIN_AP25 -to CTRL_SDO_A
set_location_assignment PIN_AL27 -to CTRL_SCK1_A
set_location_assignment PIN_AJ25 -to CTRL_SCK2_A
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_CLK_A
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_DIN0_A
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_DIN1_A
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_DOUT_ADC_0_A
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_DOUT_ADC_1_A
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_LD_ADC_A
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_LD_DAC_A
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_LD_TEMP_DAC_A
set_location_assignment PIN_AJ28 -to SPI_CLK_A
set_location_assignment PIN_AJ29 -to SPI_DIN0_A
set_location_assignment PIN_AM28 -to SPI_DIN1_A
set_location_assignment PIN_AH26 -to SPI_DOUT_ADC_0_A
set_location_assignment PIN_AJ27 -to SPI_DOUT_ADC_1_A
set_location_assignment PIN_AK29 -to SPI_LD_ADC_A
set_location_assignment PIN_AL28 -to SPI_LD_DAC_A
set_location_assignment PIN_AL29 -to SPI_LD_TEMP_DAC_A

set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_Load_B
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_RB_B
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SCK1_B
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SCK2_B
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SDI_B
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SDO_B
set_location_assignment PIN_AN29 -to CTRL_Load_B
set_location_assignment PIN_AP30 -to CTRL_RB_B
set_location_assignment PIN_AN30 -to CTRL_SCK1_B
set_location_assignment PIN_AP28 -to CTRL_SCK2_B
set_location_assignment PIN_AP31 -to CTRL_SDI_B
set_location_assignment PIN_AP29 -to CTRL_SDO_B
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_CLK_B
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_DIN0_B
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_DIN1_B
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_DOUT_ADC_0_B
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_DOUT_ADC_1_B
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_LD_ADC_B
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_LD_DAC_B
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_LD_TEMP_DAC_B
set_location_assignment PIN_F28 -to SPI_CLK_B
set_location_assignment PIN_F29 -to SPI_DIN0_B
set_location_assignment PIN_C28 -to SPI_DIN1_B
set_location_assignment PIN_G26 -to SPI_DOUT_ADC_0_B
set_location_assignment PIN_H27 -to SPI_DOUT_ADC_1_B
set_location_assignment PIN_E29 -to SPI_LD_ADC_B
set_location_assignment PIN_D28 -to SPI_LD_DAC_B
set_location_assignment PIN_D29 -to SPI_LD_TEMP_DAC_B

set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_Load_C
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_RB_C
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SCK1_C
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SCK2_C
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SDI_C
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SDO_C
set_location_assignment PIN_AP6 -to CTRL_Load_C
set_location_assignment PIN_AN5 -to CTRL_RB_C
set_location_assignment PIN_AP5 -to CTRL_SCK1_C
set_location_assignment PIN_AP4 -to CTRL_SCK2_C
set_location_assignment PIN_AN6 -to CTRL_SDI_C
set_location_assignment PIN_AP7 -to CTRL_SDO_C
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_CLK_C
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_DIN0_C
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_DIN1_C
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_DOUT_ADC_0_C
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_DOUT_ADC_1_C
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_LD_ADC_C
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_LD_DAC_C
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_LD_TEMP_DAC_C
set_location_assignment PIN_E11 -to SPI_CLK_C
set_location_assignment PIN_D11 -to SPI_DIN0_C
set_location_assignment PIN_H12 -to SPI_DIN1_C
set_location_assignment PIN_G9 -to SPI_DOUT_ADC_0_C
set_location_assignment PIN_H8 -to SPI_DOUT_ADC_1_C
set_location_assignment PIN_F11 -to SPI_LD_ADC_C
set_location_assignment PIN_G11 -to SPI_LD_DAC_C
set_location_assignment PIN_G12 -to SPI_LD_TEMP_DAC_C

set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_Load_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_RB_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SCK1_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SCK2_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SDI_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SDO_D
set_location_assignment PIN_AP22 -to CTRL_Load_D
set_location_assignment PIN_AM22 -to CTRL_RB_D
set_location_assignment PIN_AF20 -to CTRL_SCK1_D
set_location_assignment PIN_AH20 -to CTRL_SCK2_D
set_location_assignment PIN_AJ22 -to CTRL_SDI_D
set_location_assignment PIN_AH22 -to CTRL_SDO_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_CLK_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_DIN0_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_DIN1_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_DOUT_ADC_0_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_DOUT_ADC_1_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_LD_ADC_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_LD_DAC_D
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_LD_TEMP_DAC_D
set_location_assignment PIN_AL11 -to SPI_CLK_D
set_location_assignment PIN_AM11 -to SPI_DIN0_D
set_location_assignment PIN_AN12 -to SPI_DIN1_D
set_location_assignment PIN_AN27 -to SPI_DOUT_ADC_0_D
set_location_assignment PIN_AP27 -to SPI_DOUT_ADC_1_D
set_location_assignment PIN_AP11 -to SPI_LD_ADC_D
set_location_assignment PIN_AN11 -to SPI_LD_DAC_D
set_location_assignment PIN_AP12 -to SPI_LD_TEMP_DAC_D

set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_Load_E
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_RB_E
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SCK1_E
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SCK2_E
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SDI_E
set_instance_assignment -name IO_STANDARD "1.8 V" -to CTRL_SDO_E
set_location_assignment PIN_AH11 -to CTRL_Load_E
set_location_assignment PIN_AK12 -to CTRL_RB_E
set_location_assignment PIN_AJ12 -to CTRL_SCK1_E
set_location_assignment PIN_AJ10 -to CTRL_SCK2_E
set_location_assignment PIN_AL9 -to CTRL_SDI_E
set_location_assignment PIN_AL10 -to CTRL_SDO_E
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_CLK_E
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_DIN0_E
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_DIN1_E
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_DOUT_ADC_0_E
set_instance_assignment -name IO_STANDARD "2.5 V" -to SPI_DOUT_ADC_1_E
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_LD_ADC_E
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_LD_DAC_E
set_instance_assignment -name IO_STANDARD "1.8 V" -to SPI_LD_TEMP_DAC_E
set_location_assignment PIN_AH13 -to SPI_CLK_E
set_location_assignment PIN_AE15 -to SPI_DIN1_E
set_location_assignment PIN_AH14 -to SPI_LD_DAC_E
set_location_assignment PIN_AJ13 -to SPI_DIN0_E
set_location_assignment PIN_AK6 -to SPI_DOUT_ADC_0_E
set_location_assignment PIN_AL5 -to SPI_DOUT_ADC_1_E
set_location_assignment PIN_AJ14 -to SPI_LD_ADC_E
set_location_assignment PIN_AF15 -to SPI_LD_TEMP_DAC_E

set_location_assignment PIN_A20 -to power_good_09
set_location_assignment PIN_A21 -to power_good_other

set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 8C

# power rails supply voltages
set_global_assignment -name VCCT_L_USER_VOLTAGE 1.1V
set_global_assignment -name VCCT_R_USER_VOLTAGE 1.1V
set_global_assignment -name VCCL_GXBL_USER_VOLTAGE 1.1V
set_global_assignment -name VCCL_GXBR_USER_VOLTAGE 1.1V
set_global_assignment -name VCCR_L_USER_VOLTAGE 1.1V
set_global_assignment -name VCCR_R_USER_VOLTAGE 1.1V
set_global_assignment -name VCCA_L_USER_VOLTAGE 2.5V
set_global_assignment -name VCCA_R_USER_VOLTAGE 2.5V
set_global_assignment -name VCCH_GXBL_USER_VOLTAGE 1.4V
set_global_assignment -name VCCH_GXBR_USER_VOLTAGE 1.4V

# measurement voltages
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -rise
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -fall
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -rise
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -fall
# consider the PCI Express hard IP blocks on the left/right side of the device powered down
set_global_assignment -name POWER_HSSI_VCCHIP_LEFT "Opportunistically power off"
set_global_assignment -name POWER_HSSI_VCCHIP_RIGHT "Opportunistically power off"
# consider the transceivers on the left/right side of the device powered down
set_global_assignment -name POWER_HSSI_LEFT "Opportunistically power off"
set_global_assignment -name POWER_HSSI_RIGHT "Opportunistically power off"

# toggle rates
set_global_assignment -name POWER_USE_INPUT_FILES OFF
set_global_assignment -name POWER_DEFAULT_INPUT_IO_TOGGLE_RATE 100%
set_global_assignment -name POWER_USE_PVA ON
set_global_assignment -name POWER_DEFAULT_TOGGLE_RATE 100%

# conf scheme
set_global_assignment -name STRATIXIII_CONFIGURATION_SCHEME "ACTIVE SERIAL"
set_global_assignment -name USE_CONFIGURATION_DEVICE ON
set_global_assignment -name STRATIXII_CONFIGURATION_DEVICE EPCS128

# conf pins
set_global_assignment -name ENABLE_OCT_DONE OFF
set_global_assignment -name ENABLE_CONFIGURATION_PINS OFF
set_global_assignment -name ENABLE_BOOT_SEL_PIN OFF
