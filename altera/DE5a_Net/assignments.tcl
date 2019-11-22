#

set_global_assignment -name FAMILY "Arria 10"
set_global_assignment -name DEVICE 10AX115N2F45E1SG
set_global_assignment -name DEVICE_FILTER_PACKAGE FBGA
set_global_assignment -name DEVICE_FILTER_PIN_COUNT 1932

set_location_assignment PIN_AP24 -to CPU_RESET_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to CPU_RESET_n

set_location_assignment PIN_W36 -to CLK_50_B2J
set_instance_assignment -name IO_STANDARD "1.8 V" -to CLK_50_B2J

#============================================================
# FAN
#============================================================
set_location_assignment PIN_AL32 -to FAN_ALERT_n
set_instance_assignment -name IO_STANDARD "1.5 V" -to FAN_ALERT_n
set_location_assignment PIN_AJ33 -to FAN_I2C_SCL
set_instance_assignment -name IO_STANDARD "1.5 V" -to FAN_I2C_SCL
set_location_assignment PIN_AK33 -to FAN_I2C_SDA
set_instance_assignment -name IO_STANDARD "1.5 V" -to FAN_I2C_SDA

#============================================================
# FLASH
#============================================================
set_location_assignment PIN_H26 -to FLASH_A[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[1]
set_location_assignment PIN_J18 -to FLASH_A[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[2]
set_location_assignment PIN_N17 -to FLASH_A[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[3]
set_location_assignment PIN_P15 -to FLASH_A[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[4]
set_location_assignment PIN_B18 -to FLASH_A[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[5]
set_location_assignment PIN_E18 -to FLASH_A[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[6]
set_location_assignment PIN_D18 -to FLASH_A[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[7]
set_location_assignment PIN_J10 -to FLASH_A[8]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[8]
set_location_assignment PIN_B17 -to FLASH_A[9]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[9]
set_location_assignment PIN_J11 -to FLASH_A[10]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[10]
set_location_assignment PIN_H8 -to FLASH_A[11]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[11]
set_location_assignment PIN_A17 -to FLASH_A[12]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[12]
set_location_assignment PIN_G8 -to FLASH_A[13]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[13]
set_location_assignment PIN_G9 -to FLASH_A[14]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[14]
set_location_assignment PIN_A16 -to FLASH_A[15]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[15]
set_location_assignment PIN_K11 -to FLASH_A[16]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[16]
set_location_assignment PIN_B15 -to FLASH_A[17]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[17]
set_location_assignment PIN_G7 -to FLASH_A[18]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[18]
set_location_assignment PIN_F6 -to FLASH_A[19]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[19]
set_location_assignment PIN_A15 -to FLASH_A[20]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[20]
set_location_assignment PIN_A14 -to FLASH_A[21]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[21]
set_location_assignment PIN_H6 -to FLASH_A[22]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[22]
set_location_assignment PIN_T12 -to FLASH_A[23]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[23]
set_location_assignment PIN_U12 -to FLASH_A[24]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[24]
set_location_assignment PIN_F7 -to FLASH_A[25]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[25]
set_location_assignment PIN_B14 -to FLASH_A[26]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_A[26]
set_location_assignment PIN_H7 -to FLASH_ADV_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_ADV_n
set_location_assignment PIN_H10 -to FLASH_CE_n[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_CE_n[0]
set_location_assignment PIN_N16 -to FLASH_CE_n[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_CE_n[1]
set_location_assignment PIN_T9 -to FLASH_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_CLK
set_location_assignment PIN_B35 -to FLASH_D[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[0]
set_location_assignment PIN_A35 -to FLASH_D[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[1]
set_location_assignment PIN_C35 -to FLASH_D[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[2]
set_location_assignment PIN_C33 -to FLASH_D[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[3]
set_location_assignment PIN_C32 -to FLASH_D[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[4]
set_location_assignment PIN_A32 -to FLASH_D[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[5]
set_location_assignment PIN_C26 -to FLASH_D[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[6]
set_location_assignment PIN_B24 -to FLASH_D[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[7]
set_location_assignment PIN_C36 -to FLASH_D[8]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[8]
set_location_assignment PIN_B34 -to FLASH_D[9]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[9]
set_location_assignment PIN_A34 -to FLASH_D[10]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[10]
set_location_assignment PIN_B33 -to FLASH_D[11]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[11]
set_location_assignment PIN_B32 -to FLASH_D[12]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[12]
set_location_assignment PIN_A31 -to FLASH_D[13]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[13]
set_location_assignment PIN_E24 -to FLASH_D[14]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[14]
set_location_assignment PIN_C25 -to FLASH_D[15]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[15]
set_location_assignment PIN_K33 -to FLASH_D[16]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[16]
set_location_assignment PIN_J39 -to FLASH_D[17]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[17]
set_location_assignment PIN_AA32 -to FLASH_D[18]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[18]
set_location_assignment PIN_J35 -to FLASH_D[19]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[19]
set_location_assignment PIN_H36 -to FLASH_D[20]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[20]
set_location_assignment PIN_AB32 -to FLASH_D[21]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[21]
set_location_assignment PIN_J34 -to FLASH_D[22]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[22]
set_location_assignment PIN_AA31 -to FLASH_D[23]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[23]
set_location_assignment PIN_J36 -to FLASH_D[24]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[24]
set_location_assignment PIN_J38 -to FLASH_D[25]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[25]
set_location_assignment PIN_K34 -to FLASH_D[26]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[26]
set_location_assignment PIN_H38 -to FLASH_D[27]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[27]
set_location_assignment PIN_H37 -to FLASH_D[28]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[28]
set_location_assignment PIN_Y31 -to FLASH_D[29]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[29]
set_location_assignment PIN_H35 -to FLASH_D[30]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[30]
set_location_assignment PIN_J33 -to FLASH_D[31]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_D[31]
set_location_assignment PIN_C16 -to FLASH_OE_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_OE_n
set_location_assignment PIN_J8 -to FLASH_RDY_BSY_n[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_RDY_BSY_n[0]
set_location_assignment PIN_L36 -to FLASH_RDY_BSY_n[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_RDY_BSY_n[1]
set_location_assignment PIN_C17 -to FLASH_RESET_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_RESET_n
set_location_assignment PIN_U10 -to FLASH_WE_n
set_instance_assignment -name IO_STANDARD "1.8 V" -to FLASH_WE_n
