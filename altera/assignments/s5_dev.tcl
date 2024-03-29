#

set_global_assignment -name FAMILY "Stratix V"
set_global_assignment -name DEVICE 5SGSMD5K2F40C2
set_global_assignment -name DEVICE_FILTER_PACKAGE FBGA
set_global_assignment -name DEVICE_FILTER_PIN_COUNT 1517

set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "1.8 V"

#-----------clk-----------   
set_location_assignment PIN_AW29 -to "clk_125_p(n)"
set_location_assignment PIN_AV29 -to clk_125_p
set_location_assignment PIN_AN6 -to clkin_50
set_location_assignment PIN_AJ22 -to "clkinbot_p[0](n)"
set_location_assignment PIN_AG17 -to "clkinbot_p[1](n)"
set_location_assignment PIN_AH22 -to clkinbot_p[0]
set_location_assignment PIN_AF17 -to clkinbot_p[1]
set_location_assignment PIN_J24 -to "clkintop_p[0](n)"
set_location_assignment PIN_M32 -to "clkintop_p[1](n)"
set_location_assignment PIN_J23 -to clkintop_p[0]
set_location_assignment PIN_N32 -to clkintop_p[1]
 
#-----------Si571 VCXO-----
set_location_assignment PIN_AW28 -to sdi_clk148_up
set_location_assignment PIN_AU10 -to sdi_clk148_dn
set_instance_assignment -name IO_STANDARD "2.5 V" -to sdi_clk148_up
set_instance_assignment -name IO_STANDARD "2.5 V" -to sdi_clk148_dn
 
#-----------ddr3-----------   
set_location_assignment PIN_G31 -to ddr3_a[0]
set_location_assignment PIN_K31 -to ddr3_a[1]
set_location_assignment PIN_H31 -to ddr3_a[2]
set_location_assignment PIN_D31 -to ddr3_a[3]
set_location_assignment PIN_L30 -to ddr3_a[4]
set_location_assignment PIN_E31 -to ddr3_a[5]
set_location_assignment PIN_N31 -to ddr3_a[6]
set_location_assignment PIN_F30 -to ddr3_a[7]
set_location_assignment PIN_P31 -to ddr3_a[8]
set_location_assignment PIN_J29 -to ddr3_a[9]
set_location_assignment PIN_J30 -to ddr3_a[10]
set_location_assignment PIN_L31 -to ddr3_a[11]
set_location_assignment PIN_R30 -to ddr3_a[12]
set_location_assignment PIN_J31 -to ddr3_a[13]
set_location_assignment PIN_C31 -to ddr3_ba[0]
set_location_assignment PIN_K30 -to ddr3_ba[1]
set_location_assignment PIN_E30 -to ddr3_ba[2]
set_location_assignment PIN_B28 -to ddr3_casn
set_location_assignment PIN_R31 -to ddr3_cke
set_location_assignment PIN_M30 -to ddr3_clk_n
set_location_assignment PIN_N30 -to ddr3_clk_p
set_location_assignment PIN_B31 -to ddr3_csn
set_location_assignment PIN_A29 -to ddr3_dm[0]
set_location_assignment PIN_J28 -to ddr3_dm[1]
set_location_assignment PIN_A26 -to ddr3_dm[2]
set_location_assignment PIN_L27 -to ddr3_dm[3]
set_location_assignment PIN_A25 -to ddr3_dm[4]
set_location_assignment PIN_K25 -to ddr3_dm[5]
set_location_assignment PIN_A22 -to ddr3_dm[6]
set_location_assignment PIN_B20 -to ddr3_dm[7]
set_location_assignment PIN_M21 -to ddr3_dm[8]
set_location_assignment PIN_A28 -to ddr3_dq[0]
set_location_assignment PIN_E28 -to ddr3_dq[1]
set_location_assignment PIN_B29 -to ddr3_dq[2]
set_location_assignment PIN_F29 -to ddr3_dq[3]
set_location_assignment PIN_D28 -to ddr3_dq[4]
set_location_assignment PIN_H28 -to ddr3_dq[5]
set_location_assignment PIN_C28 -to ddr3_dq[6]
set_location_assignment PIN_G28 -to ddr3_dq[7]
set_location_assignment PIN_K28 -to ddr3_dq[8]
set_location_assignment PIN_M29 -to ddr3_dq[9]
set_location_assignment PIN_L28 -to ddr3_dq[10]
set_location_assignment PIN_R29 -to ddr3_dq[11]
set_location_assignment PIN_P29 -to ddr3_dq[12]
set_location_assignment PIN_V29 -to ddr3_dq[13]
set_location_assignment PIN_N28 -to ddr3_dq[14]
set_location_assignment PIN_U29 -to ddr3_dq[15]
set_location_assignment PIN_G26 -to ddr3_dq[16]
set_location_assignment PIN_D27 -to ddr3_dq[17]
set_location_assignment PIN_F26 -to ddr3_dq[18]
set_location_assignment PIN_C27 -to ddr3_dq[19]
set_location_assignment PIN_C26 -to ddr3_dq[20]
set_location_assignment PIN_J26 -to ddr3_dq[21]
set_location_assignment PIN_E27 -to ddr3_dq[22]
set_location_assignment PIN_H26 -to ddr3_dq[23]
set_location_assignment PIN_J27 -to ddr3_dq[24]
set_location_assignment PIN_N27 -to ddr3_dq[25]
set_location_assignment PIN_T27 -to ddr3_dq[26]
set_location_assignment PIN_M27 -to ddr3_dq[27]
set_location_assignment PIN_U26 -to ddr3_dq[28]
set_location_assignment PIN_P28 -to ddr3_dq[29]
set_location_assignment PIN_U27 -to ddr3_dq[30]
set_location_assignment PIN_R27 -to ddr3_dq[31]
set_location_assignment PIN_B25 -to ddr3_dq[32]
set_location_assignment PIN_F24 -to ddr3_dq[33]
set_location_assignment PIN_C25 -to ddr3_dq[34]
set_location_assignment PIN_G24 -to ddr3_dq[35]
set_location_assignment PIN_D24 -to ddr3_dq[36]
set_location_assignment PIN_H25 -to ddr3_dq[37]
set_location_assignment PIN_C24 -to ddr3_dq[38]
set_location_assignment PIN_G25 -to ddr3_dq[39]
set_location_assignment PIN_J25 -to ddr3_dq[40]
set_location_assignment PIN_N26 -to ddr3_dq[41]
set_location_assignment PIN_L26 -to ddr3_dq[42]
set_location_assignment PIN_P26 -to ddr3_dq[43]
set_location_assignment PIN_P25 -to ddr3_dq[44]
set_location_assignment PIN_T25 -to ddr3_dq[45]
set_location_assignment PIN_N25 -to ddr3_dq[46]
set_location_assignment PIN_U25 -to ddr3_dq[47]
set_location_assignment PIN_H22 -to ddr3_dq[48]
set_location_assignment PIN_B23 -to ddr3_dq[49]
set_location_assignment PIN_G22 -to ddr3_dq[50]
set_location_assignment PIN_G23 -to ddr3_dq[51]
set_location_assignment PIN_D22 -to ddr3_dq[52]
set_location_assignment PIN_H23 -to ddr3_dq[53]
set_location_assignment PIN_C22 -to ddr3_dq[54]
set_location_assignment PIN_A23 -to ddr3_dq[55]
set_location_assignment PIN_A20 -to ddr3_dq[56]
set_location_assignment PIN_C20 -to ddr3_dq[57]
set_location_assignment PIN_F20 -to ddr3_dq[58]
set_location_assignment PIN_C21 -to ddr3_dq[59]
set_location_assignment PIN_H20 -to ddr3_dq[60]
set_location_assignment PIN_D21 -to ddr3_dq[61]
set_location_assignment PIN_G20 -to ddr3_dq[62]
set_location_assignment PIN_E20 -to ddr3_dq[63]
set_location_assignment PIN_M20 -to ddr3_dq[64]
set_location_assignment PIN_L20 -to ddr3_dq[65]
set_location_assignment PIN_N22 -to ddr3_dq[66]
set_location_assignment PIN_J21 -to ddr3_dq[67]
set_location_assignment PIN_N21 -to ddr3_dq[68]
set_location_assignment PIN_K21 -to ddr3_dq[69]
set_location_assignment PIN_N20 -to ddr3_dq[70]
set_location_assignment PIN_L21 -to ddr3_dq[71]
set_location_assignment PIN_G29 -to ddr3_dqs_n[0]
set_location_assignment PIN_T30 -to ddr3_dqs_n[1]
set_location_assignment PIN_F27 -to ddr3_dqs_n[2]
set_location_assignment PIN_T28 -to ddr3_dqs_n[3]
set_location_assignment PIN_E25 -to ddr3_dqs_n[4]
set_location_assignment PIN_R26 -to ddr3_dqs_n[5]
set_location_assignment PIN_E23 -to ddr3_dqs_n[6]
set_location_assignment PIN_F21 -to ddr3_dqs_n[7]
set_location_assignment PIN_J22 -to ddr3_dqs_n[8]
set_location_assignment PIN_H29 -to ddr3_dqs_p[0]
set_location_assignment PIN_U30 -to ddr3_dqs_p[1]
set_location_assignment PIN_G27 -to ddr3_dqs_p[2]
set_location_assignment PIN_U28 -to ddr3_dqs_p[3]
set_location_assignment PIN_E24 -to ddr3_dqs_p[4]
set_location_assignment PIN_R25 -to ddr3_dqs_p[5]
set_location_assignment PIN_F23 -to ddr3_dqs_p[6]
set_location_assignment PIN_G21 -to ddr3_dqs_p[7]
set_location_assignment PIN_K22 -to ddr3_dqs_p[8]
set_location_assignment PIN_A31 -to ddr3_odt
set_location_assignment PIN_B26 -to ddr3_rasn
set_location_assignment PIN_G30 -to ddr3_resetn
set_location_assignment PIN_C30 -to ddr3_wen
   
#-----------qdr-----------   
set_location_assignment PIN_AU14 -to qdrii_a[0]
set_location_assignment PIN_AP13 -to qdrii_a[1]
set_location_assignment PIN_AF13 -to qdrii_a[2]
set_location_assignment PIN_AT14 -to qdrii_a[3]
set_location_assignment PIN_AG13 -to qdrii_a[4]
set_location_assignment PIN_AN13 -to qdrii_a[5]
set_location_assignment PIN_AD14 -to qdrii_a[6]
set_location_assignment PIN_AH13 -to qdrii_a[7]
set_location_assignment PIN_AJ13 -to qdrii_a[8]
set_location_assignment PIN_AC14 -to qdrii_a[9]
set_location_assignment PIN_AE14 -to qdrii_a[10]
set_location_assignment PIN_AM13 -to qdrii_a[11]
set_location_assignment PIN_AW14 -to qdrii_a[12]
set_location_assignment PIN_AB13 -to qdrii_a[13]
set_location_assignment PIN_AC13 -to qdrii_a[14]
set_location_assignment PIN_AF14 -to qdrii_a[15]
set_location_assignment PIN_AL13 -to qdrii_a[16]
set_location_assignment PIN_AN12 -to qdrii_a[17]
set_location_assignment PIN_AA12 -to qdrii_a[18]
set_location_assignment PIN_AP12 -to qdrii_a[19]
set_location_assignment PIN_AA13 -to qdrii_a[20]
set_location_assignment PIN_AH15 -to qdrii_bwsn[0]
set_location_assignment PIN_AJ15 -to qdrii_bwsn[1]
set_location_assignment PIN_AU18 -to qdrii_c_n
set_location_assignment PIN_AT18 -to qdrii_c_p
set_location_assignment PIN_AF19 -to qdrii_cq_n
set_location_assignment PIN_AN19 -to qdrii_cq_p
set_location_assignment PIN_AD15 -to qdrii_d[0]
set_location_assignment PIN_AB16 -to qdrii_d[1]
set_location_assignment PIN_AB15 -to qdrii_d[2]
set_location_assignment PIN_AC15 -to qdrii_d[3]
set_location_assignment PIN_AA15 -to qdrii_d[4]
set_location_assignment PIN_AA14 -to qdrii_d[5]
set_location_assignment PIN_AE15 -to qdrii_d[6]
set_location_assignment PIN_AD16 -to qdrii_d[7]
set_location_assignment PIN_AG14 -to qdrii_d[8]
set_location_assignment PIN_AL15 -to qdrii_d[9]
set_location_assignment PIN_AM14 -to qdrii_d[10]
set_location_assignment PIN_AN15 -to qdrii_d[11]
set_location_assignment PIN_AN14 -to qdrii_d[12]
set_location_assignment PIN_AT15 -to qdrii_d[13]
set_location_assignment PIN_AP15 -to qdrii_d[14]
set_location_assignment PIN_AR14 -to qdrii_d[15]
set_location_assignment PIN_AR15 -to qdrii_d[16]
set_location_assignment PIN_AU15 -to qdrii_d[17]
set_location_assignment PIN_AV13 -to qdrii_doffn
set_location_assignment PIN_AL14 -to qdrii_k_n
set_location_assignment PIN_AK14 -to qdrii_k_p
set_location_assignment PIN_AD17 -to qdrii_q[0]
set_location_assignment PIN_AE18 -to qdrii_q[1]
set_location_assignment PIN_AD18 -to qdrii_q[2]
set_location_assignment PIN_AE19 -to qdrii_q[3]
set_location_assignment PIN_AG18 -to qdrii_q[4]
set_location_assignment PIN_AG19 -to qdrii_q[5]
set_location_assignment PIN_AH18 -to qdrii_q[6]
set_location_assignment PIN_AJ18 -to qdrii_q[7]
set_location_assignment PIN_AH19 -to qdrii_q[8]
set_location_assignment PIN_AJ19 -to qdrii_q[9]
set_location_assignment PIN_AK18 -to qdrii_q[10]
set_location_assignment PIN_AL18 -to qdrii_q[11]
set_location_assignment PIN_AR19 -to qdrii_q[12]
set_location_assignment PIN_AP18 -to qdrii_q[13]
set_location_assignment PIN_AR18 -to qdrii_q[14]
set_location_assignment PIN_AP19 -to qdrii_q[15]
set_location_assignment PIN_AN18 -to qdrii_q[16]
set_location_assignment PIN_AM19 -to qdrii_q[17]
set_location_assignment PIN_AG15 -to qdrii_rpsn
set_location_assignment PIN_AK15 -to qdrii_wpsn
   
#-----------rldc-----------   
set_location_assignment PIN_AD22 -to rldc_a[0]
set_location_assignment PIN_AW22 -to rldc_a[1]
set_location_assignment PIN_AW23 -to rldc_a[2]
set_location_assignment PIN_AD23 -to rldc_a[3]
set_location_assignment PIN_AE22 -to rldc_a[4]
set_location_assignment PIN_AU23 -to rldc_a[5]
set_location_assignment PIN_AT23 -to rldc_a[6]
set_location_assignment PIN_AT20 -to rldc_a[7]
set_location_assignment PIN_AG23 -to rldc_a[8]
set_location_assignment PIN_AM23 -to rldc_a[9]
set_location_assignment PIN_AM20 -to rldc_a[10]
set_location_assignment PIN_AW20 -to rldc_a[11]
set_location_assignment PIN_AV20 -to rldc_a[12]
set_location_assignment PIN_AG22 -to rldc_a[13]
set_location_assignment PIN_AF23 -to rldc_a[14]
set_location_assignment PIN_AR21 -to rldc_a[15]
set_location_assignment PIN_AP22 -to rldc_a[16]
set_location_assignment PIN_AR20 -to rldc_a[17]
set_location_assignment PIN_AR22 -to rldc_a[18]
set_location_assignment PIN_AN20 -to rldc_a[19]
set_location_assignment PIN_AU20 -to rldc_a[20]
set_location_assignment PIN_AV23 -to rldc_a[21]
set_location_assignment PIN_AV22 -to rldc_a[22]
set_location_assignment PIN_AE23 -to rldc_ba[0]
set_location_assignment PIN_AF22 -to rldc_ba[1]
set_location_assignment PIN_AK23 -to rldc_ba[2]
set_location_assignment PIN_AU21 -to rldc_ck_n
set_location_assignment PIN_AT21 -to rldc_ck_p
set_location_assignment PIN_AN23 -to rldc_csn
set_location_assignment PIN_AR25 -to rldc_dk_n
set_location_assignment PIN_AP25 -to rldc_dk_p
set_location_assignment PIN_AB25 -to rldc_dm
set_location_assignment PIN_AW26 -to rldc_dq[0]
set_location_assignment PIN_AN27 -to rldc_dq[1]
set_location_assignment PIN_AN26 -to rldc_dq[2]
set_location_assignment PIN_AM26 -to rldc_dq[3]
set_location_assignment PIN_AV26 -to rldc_dq[4]
set_location_assignment PIN_AU26 -to rldc_dq[5]
set_location_assignment PIN_AU27 -to rldc_dq[6]
set_location_assignment PIN_AT26 -to rldc_dq[7]
set_location_assignment PIN_AT27 -to rldc_dq[8]
set_location_assignment PIN_AC25 -to rldc_dq[9]
set_location_assignment PIN_AC26 -to rldc_dq[10]
set_location_assignment PIN_AD26 -to rldc_dq[11]
set_location_assignment PIN_AE26 -to rldc_dq[12]
set_location_assignment PIN_AF26 -to rldc_dq[13]
set_location_assignment PIN_AA25 -to rldc_dq[14]
set_location_assignment PIN_AG26 -to rldc_dq[15]
set_location_assignment PIN_AG25 -to rldc_dq[16]
set_location_assignment PIN_AH25 -to rldc_dq[17]
set_location_assignment PIN_AR27 -to rldc_qk_n[0]
set_location_assignment PIN_AK26 -to rldc_qk_n[1]
set_location_assignment PIN_AP27 -to rldc_qk_p[0]
set_location_assignment PIN_AJ26 -to rldc_qk_p[1]
set_location_assignment PIN_AL26 -to rldc_qvld
set_location_assignment PIN_AM22 -to rldc_refn
set_location_assignment PIN_AN22 -to rldc_wen
   
#-----------enet-----------   
set_location_assignment PIN_AA29 -to enet_intn
set_location_assignment PIN_AA26 -to enet_mdc
set_location_assignment PIN_AA27 -to enet_mdio
set_location_assignment PIN_AA28 -to enet_resetn
set_location_assignment PIN_AR34 -to "enet_rx_p(n)"
set_location_assignment PIN_AP34 -to enet_rx_p
set_location_assignment PIN_AC27 -to "enet_tx_p(n)"
set_location_assignment PIN_AB27 -to enet_tx_p
   
#-----------fm-----------   
set_location_assignment PIN_AW19 -to fm_a[0]
set_location_assignment PIN_AV19 -to fm_a[1]
set_location_assignment PIN_AM16 -to fm_a[2]
set_location_assignment PIN_AL16 -to fm_a[3]
set_location_assignment PIN_AF16 -to fm_a[4]
set_location_assignment PIN_AG16 -to fm_a[5]
set_location_assignment PIN_AN17 -to fm_a[6]
set_location_assignment PIN_AM17 -to fm_a[7]
set_location_assignment PIN_AP16 -to fm_a[8]
set_location_assignment PIN_AN16 -to fm_a[9]
set_location_assignment PIN_AT17 -to fm_a[10]
set_location_assignment PIN_AR17 -to fm_a[11]
set_location_assignment PIN_AU16 -to fm_a[12]
set_location_assignment PIN_AU17 -to fm_a[13]
set_location_assignment PIN_AW16 -to fm_a[14]
set_location_assignment PIN_AV16 -to fm_a[15]
set_location_assignment PIN_AW17 -to fm_a[16]
set_location_assignment PIN_AV17 -to fm_a[17]
set_location_assignment PIN_AU6 -to fm_a[18]
set_location_assignment PIN_AT6 -to fm_a[19]
set_location_assignment PIN_AL17 -to fm_a[20]
set_location_assignment PIN_AK17 -to fm_a[21]
set_location_assignment PIN_AE16 -to fm_a[22]
set_location_assignment PIN_AE17 -to fm_a[23]
set_location_assignment PIN_AH16 -to fm_a[24]
set_location_assignment PIN_AP21 -to fm_a[25]
set_location_assignment PIN_AJ17 -to fm_a[26]
set_location_assignment PIN_AN21 -to fm_d[0]
set_location_assignment PIN_AD21 -to fm_d[1]
set_location_assignment PIN_AD20 -to fm_d[2]
set_location_assignment PIN_AG21 -to fm_d[3]
set_location_assignment PIN_AH21 -to fm_d[4]
set_location_assignment PIN_AE21 -to fm_d[5]
set_location_assignment PIN_AE20 -to fm_d[6]
set_location_assignment PIN_AL22 -to fm_d[7]
set_location_assignment PIN_AK21 -to fm_d[8]
set_location_assignment PIN_AJ21 -to fm_d[9]
set_location_assignment PIN_AJ20 -to fm_d[10]
set_location_assignment PIN_AL21 -to fm_d[11]
set_location_assignment PIN_AL20 -to fm_d[12]
set_location_assignment PIN_AN25 -to fm_d[13]
set_location_assignment PIN_AM25 -to fm_d[14]
set_location_assignment PIN_AP24 -to fm_d[15]
set_location_assignment PIN_AN24 -to fm_d[16]
set_location_assignment PIN_AC24 -to fm_d[17]
set_location_assignment PIN_AB24 -to fm_d[18]
set_location_assignment PIN_AF25 -to fm_d[19]
set_location_assignment PIN_AE25 -to fm_d[20]
set_location_assignment PIN_AE24 -to fm_d[21]
set_location_assignment PIN_AD24 -to fm_d[22]
set_location_assignment PIN_AG24 -to fm_d[23]
set_location_assignment PIN_AH24 -to fm_d[24]
set_location_assignment PIN_AK24 -to fm_d[25]
set_location_assignment PIN_AJ24 -to fm_d[26]
set_location_assignment PIN_AL24 -to fm_d[27]
set_location_assignment PIN_AL25 -to fm_d[28]
set_location_assignment PIN_AW25 -to fm_d[29]
set_location_assignment PIN_AV25 -to fm_d[30]
set_location_assignment PIN_AT24 -to fm_d[31]
   
#-----------flash-----------   
set_location_assignment PIN_AP7 -to flash_advn
set_location_assignment PIN_AV14 -to flash_cen[0]
set_location_assignment PIN_AW13 -to flash_cen[1]
set_location_assignment PIN_AM8 -to flash_clk
set_location_assignment PIN_AJ7 -to flash_oen
set_location_assignment PIN_AL6 -to flash_rdybsyn[0]
set_location_assignment PIN_AN7 -to flash_rdybsyn[1]
set_location_assignment PIN_AJ6 -to flash_resetn
set_location_assignment PIN_AN8 -to flash_wen
   
#-----------max5-----------   
set_location_assignment PIN_U31 -to max5_ben[0]
set_location_assignment PIN_T31 -to max5_ben[1]
set_location_assignment PIN_N33 -to max5_ben[2]
set_location_assignment PIN_M33 -to max5_ben[3]
set_location_assignment PIN_E34 -to max5_clk
set_location_assignment PIN_B32 -to max5_csn
set_location_assignment PIN_A32 -to max5_oen
set_location_assignment PIN_A34 -to max5_wen
   
#-----------lcd-----------   
set_location_assignment PIN_AU9 -to lcd_csn
set_location_assignment PIN_AH10 -to lcd_d_cn
set_location_assignment PIN_AP10 -to lcd_data[0]
set_location_assignment PIN_AN10 -to lcd_data[1]
set_location_assignment PIN_AM10 -to lcd_data[2]
set_location_assignment PIN_AL10 -to lcd_data[3]
set_location_assignment PIN_AP9 -to lcd_data[4]
set_location_assignment PIN_AN9 -to lcd_data[5]
set_location_assignment PIN_AT9 -to lcd_data[6]
set_location_assignment PIN_AR9 -to lcd_data[7]
set_location_assignment PIN_AW10 -to lcd_wen
   
#-----------user-----------   
set_location_assignment PIN_E7 -to user_dipsw[0]
set_location_assignment PIN_H7 -to user_dipsw[1]
set_location_assignment PIN_J7 -to user_dipsw[2]
set_location_assignment PIN_K7 -to user_dipsw[3]
set_location_assignment PIN_M6 -to user_dipsw[4]
set_location_assignment PIN_N6 -to user_dipsw[5]
set_location_assignment PIN_P7 -to user_dipsw[6]
set_location_assignment PIN_N7 -to user_dipsw[7]
set_location_assignment PIN_J11 -to user_led_g[0]
set_location_assignment PIN_U10 -to user_led_g[1]
set_location_assignment PIN_U9 -to user_led_g[2]
set_location_assignment PIN_AU24 -to user_led_g[3]
set_location_assignment PIN_AF28 -to user_led_g[4]
set_location_assignment PIN_AE29 -to user_led_g[5]
set_location_assignment PIN_AR7 -to user_led_g[6]
#set_location_assignment PIN_AU10 -to user_led_g[6]
set_location_assignment PIN_AV10 -to user_led_g[7]
set_location_assignment PIN_AH28 -to user_led_r[0]
set_location_assignment PIN_AG30 -to user_led_r[1]
set_location_assignment PIN_AL7 -to user_led_r[2]
set_location_assignment PIN_AR24 -to user_led_r[3]
set_location_assignment PIN_AM7 -to user_led_r[4]
set_location_assignment PIN_AW7 -to user_led_r[5]
set_location_assignment PIN_AL23 -to user_led_r[6]
set_location_assignment PIN_AV7 -to user_led_r[7]
set_location_assignment PIN_A7 -to user_pb[0]
set_location_assignment PIN_B7 -to user_pb[1]
set_location_assignment PIN_C7 -to user_pb[2]
set_location_assignment PIN_AM34 -to cpu_resetn
   
#-----------pcie-----------   
set_location_assignment PIN_AL28 -to pcie_led_g2
set_location_assignment PIN_AN34 -to pcie_led_g3
set_location_assignment PIN_AL27 -to pcie_led_x1
set_location_assignment PIN_AN28 -to pcie_led_x4
set_location_assignment PIN_AM28 -to pcie_led_x8
set_location_assignment PIN_AC28 -to pcie_perstn
set_location_assignment PIN_AF35 -to "pcie_refclk_p(n)"
set_location_assignment PIN_AF34 -to pcie_refclk_p
set_location_assignment PIN_AV39 -to pcie_rx_n[0]
set_location_assignment PIN_AT39 -to pcie_rx_n[1]
set_location_assignment PIN_AP39 -to pcie_rx_n[2]
set_location_assignment PIN_AM39 -to pcie_rx_n[3]
set_location_assignment PIN_AH39 -to pcie_rx_n[4]
set_location_assignment PIN_AF39 -to pcie_rx_n[5]
set_location_assignment PIN_AD39 -to pcie_rx_n[6]
set_location_assignment PIN_AB39 -to pcie_rx_n[7]
set_location_assignment PIN_AV38 -to pcie_rx_p[0]
set_location_assignment PIN_AT38 -to pcie_rx_p[1]
set_location_assignment PIN_AP38 -to pcie_rx_p[2]
set_location_assignment PIN_AM38 -to pcie_rx_p[3]
set_location_assignment PIN_AH38 -to pcie_rx_p[4]
set_location_assignment PIN_AF38 -to pcie_rx_p[5]
set_location_assignment PIN_AD38 -to pcie_rx_p[6]
set_location_assignment PIN_AB38 -to pcie_rx_p[7]
set_location_assignment PIN_AN33 -to pcie_smbclk
set_location_assignment PIN_AL34 -to pcie_smbdat
set_location_assignment PIN_AU37 -to pcie_tx_n[0]
set_location_assignment PIN_AR37 -to pcie_tx_n[1]
set_location_assignment PIN_AN37 -to pcie_tx_n[2]
set_location_assignment PIN_AL37 -to pcie_tx_n[3]
set_location_assignment PIN_AG37 -to pcie_tx_n[4]
set_location_assignment PIN_AE37 -to pcie_tx_n[5]
set_location_assignment PIN_AC37 -to pcie_tx_n[6]
set_location_assignment PIN_AA37 -to pcie_tx_n[7]
set_location_assignment PIN_AU36 -to pcie_tx_p[0]
set_location_assignment PIN_AR36 -to pcie_tx_p[1]
set_location_assignment PIN_AN36 -to pcie_tx_p[2]
set_location_assignment PIN_AL36 -to pcie_tx_p[3]
set_location_assignment PIN_AG36 -to pcie_tx_p[4]
set_location_assignment PIN_AE36 -to pcie_tx_p[5]
set_location_assignment PIN_AC36 -to pcie_tx_p[6]
set_location_assignment PIN_AA36 -to pcie_tx_p[7]
set_location_assignment PIN_AN32 -to pcie_waken
   
#-----------usb-----------   
set_location_assignment PIN_G34 -to usb_addr[0]
set_location_assignment PIN_K34 -to usb_addr[1]
set_location_assignment PIN_AV28 -to usb_clk
set_location_assignment PIN_A35 -to usb_data[0]
set_location_assignment PIN_C34 -to usb_data[1]
set_location_assignment PIN_A36 -to usb_data[2]
set_location_assignment PIN_A37 -to usb_data[3]
set_location_assignment PIN_E32 -to usb_data[4]
set_location_assignment PIN_F32 -to usb_data[5]
set_location_assignment PIN_G33 -to usb_data[6]
set_location_assignment PIN_G32 -to usb_data[7]
set_location_assignment PIN_P34 -to usb_empty
set_location_assignment PIN_N34 -to usb_full
set_location_assignment PIN_E33 -to usb_oen
set_location_assignment PIN_K33 -to usb_rdn
set_location_assignment PIN_H34 -to usb_resetn
set_location_assignment PIN_J34 -to usb_scl
set_location_assignment PIN_F33 -to usb_sda
set_location_assignment PIN_J33 -to usb_wrn
   
#-----------qsfp-----------   
set_location_assignment PIN_AE27 -to qsfp_interruptn
set_location_assignment PIN_AD27 -to qsfp_lp_mode
set_location_assignment PIN_AH27 -to qsfp_mod_prsn
set_location_assignment PIN_AG27 -to qsfp_mod_seln
set_location_assignment PIN_AE30 -to qsfp_rstn
set_location_assignment PIN_P39 -to qsfp_rx_n[0]
set_location_assignment PIN_M39 -to qsfp_rx_n[1]
set_location_assignment PIN_K39 -to qsfp_rx_n[2]
set_location_assignment PIN_H39 -to qsfp_rx_n[3]
set_location_assignment PIN_P38 -to qsfp_rx_p[0]
set_location_assignment PIN_M38 -to qsfp_rx_p[1]
set_location_assignment PIN_K38 -to qsfp_rx_p[2]
set_location_assignment PIN_H38 -to qsfp_rx_p[3]
set_location_assignment PIN_AD30 -to qsfp_scl
set_location_assignment PIN_AC30 -to qsfp_sda
set_location_assignment PIN_N37 -to qsfp_tx_n[0]
set_location_assignment PIN_L37 -to qsfp_tx_n[1]
set_location_assignment PIN_J37 -to qsfp_tx_n[2]
set_location_assignment PIN_G37 -to qsfp_tx_n[3]
set_location_assignment PIN_N36 -to qsfp_tx_p[0]
set_location_assignment PIN_L36 -to qsfp_tx_p[1]
set_location_assignment PIN_J36 -to qsfp_tx_p[2]
set_location_assignment PIN_G36 -to qsfp_tx_p[3]
   
#-----------dp_-----------   
set_location_assignment PIN_P11 -to "dp_aux_p(n)"
set_location_assignment PIN_R11 -to dp_aux_p
set_location_assignment PIN_R10 -to "dp_aux_tx_p(n)"
set_location_assignment PIN_T10 -to dp_aux_tx_p
set_location_assignment PIN_K10 -to dp_direction
set_location_assignment PIN_L11 -to dp_hot_plug
set_location_assignment PIN_N3 -to "dp_ml_lane_p[0](n)"
set_location_assignment PIN_L3 -to "dp_ml_lane_p[1](n)"
set_location_assignment PIN_J3 -to "dp_ml_lane_p[2](n)"
set_location_assignment PIN_G3 -to "dp_ml_lane_p[3](n)"
set_location_assignment PIN_N4 -to dp_ml_lane_p[0]
set_location_assignment PIN_L4 -to dp_ml_lane_p[1]
set_location_assignment PIN_J4 -to dp_ml_lane_p[2]
set_location_assignment PIN_G4 -to dp_ml_lane_p[3]
set_location_assignment PIN_M11 -to dp_return
   
#-----------sdi-----------   
set_location_assignment PIN_AB30 -to sdi_rx_bypass
set_location_assignment PIN_F39 -to "sdi_rx_p(n)"
set_location_assignment PIN_F38 -to sdi_rx_p
set_location_assignment PIN_AB28 -to sdi_rx_en
set_location_assignment PIN_AK27 -to sdi_tx_en
set_location_assignment PIN_E37 -to "sdi_tx_p(n)"
set_location_assignment PIN_E36 -to sdi_tx_p
set_location_assignment PIN_AJ27 -to sdi_tx_sd_hdn
   
#-----------hsma-----------   
set_location_assignment PIN_AG28 -to hsma_clk_in0
set_location_assignment PIN_AT8 -to hsma_clk_in_n1
set_location_assignment PIN_G6 -to hsma_clk_in_n2
set_location_assignment PIN_AR8 -to hsma_clk_in_p1
set_location_assignment PIN_G7 -to hsma_clk_in_p2
set_location_assignment PIN_AJ10 -to hsma_clk_out0
set_location_assignment PIN_AH9 -to hsma_clk_out_n1
set_location_assignment PIN_G8 -to hsma_clk_out_n2
set_location_assignment PIN_AG9 -to hsma_clk_out_p1
set_location_assignment PIN_G9 -to hsma_clk_out_p2
set_location_assignment PIN_AJ29 -to hsma_d[0]
set_location_assignment PIN_AK29 -to hsma_d[1]
set_location_assignment PIN_AR28 -to hsma_d[2]
set_location_assignment PIN_AP28 -to hsma_d[3]
set_location_assignment PIN_AW8 -to hsma_prsntn
set_location_assignment PIN_AW11 -to "hsma_rx_d_p[0](n)"
set_location_assignment PIN_AU12 -to "hsma_rx_d_p[1](n)"
set_location_assignment PIN_AR12 -to "hsma_rx_d_p[2](n)"
set_location_assignment PIN_AK12 -to "hsma_rx_d_p[3](n)"
set_location_assignment PIN_AJ12 -to "hsma_rx_d_p[4](n)"
set_location_assignment PIN_AG10 -to "hsma_rx_d_p[5](n)"
set_location_assignment PIN_AE12 -to "hsma_rx_d_p[6](n)"
set_location_assignment PIN_AC10 -to "hsma_rx_d_p[7](n)"
set_location_assignment PIN_R9 -to "hsma_rx_d_p[8](n)"
set_location_assignment PIN_L9 -to "hsma_rx_d_p[9](n)"
set_location_assignment PIN_L8 -to "hsma_rx_d_p[10](n)"
set_location_assignment PIN_G11 -to "hsma_rx_d_p[11](n)"
set_location_assignment PIN_F9 -to "hsma_rx_d_p[12](n)"
set_location_assignment PIN_E8 -to "hsma_rx_d_p[13](n)"
set_location_assignment PIN_E11 -to "hsma_rx_d_p[14](n)"
set_location_assignment PIN_C9 -to "hsma_rx_d_p[15](n)"
set_location_assignment PIN_A10 -to "hsma_rx_d_p[16](n)"
set_location_assignment PIN_AV11 -to hsma_rx_d_p[0]
set_location_assignment PIN_AT12 -to hsma_rx_d_p[1]
set_location_assignment PIN_AR11 -to hsma_rx_d_p[2]
set_location_assignment PIN_AL12 -to hsma_rx_d_p[3]
set_location_assignment PIN_AH12 -to hsma_rx_d_p[4]
set_location_assignment PIN_AF10 -to hsma_rx_d_p[5]
set_location_assignment PIN_AD12 -to hsma_rx_d_p[6]
set_location_assignment PIN_AB10 -to hsma_rx_d_p[7]
set_location_assignment PIN_T9 -to hsma_rx_d_p[8]
set_location_assignment PIN_M9 -to hsma_rx_d_p[9]
set_location_assignment PIN_M8 -to hsma_rx_d_p[10]
set_location_assignment PIN_H11 -to hsma_rx_d_p[11]
set_location_assignment PIN_G10 -to hsma_rx_d_p[12]
set_location_assignment PIN_F8 -to hsma_rx_d_p[13]
set_location_assignment PIN_F11 -to hsma_rx_d_p[14]
set_location_assignment PIN_C8 -to hsma_rx_d_p[15]
set_location_assignment PIN_B10 -to hsma_rx_d_p[16]
set_location_assignment PIN_AV8 -to hsma_rx_led
set_location_assignment PIN_AV1 -to "hsma_rx_p[0](n)"
set_location_assignment PIN_AP1 -to "hsma_rx_p[1](n)"
set_location_assignment PIN_AM1 -to "hsma_rx_p[2](n)"
set_location_assignment PIN_AK1 -to "hsma_rx_p[3](n)"
set_location_assignment PIN_AH1 -to "hsma_rx_p[4](n)"
set_location_assignment PIN_AF1 -to "hsma_rx_p[5](n)"
set_location_assignment PIN_AD1 -to "hsma_rx_p[6](n)"
set_location_assignment PIN_AB1 -to "hsma_rx_p[7](n)"
set_location_assignment PIN_AV2 -to hsma_rx_p[0]
set_location_assignment PIN_AP2 -to hsma_rx_p[1]
set_location_assignment PIN_AM2 -to hsma_rx_p[2]
set_location_assignment PIN_AK2 -to hsma_rx_p[3]
set_location_assignment PIN_AH2 -to hsma_rx_p[4]
set_location_assignment PIN_AF2 -to hsma_rx_p[5]
set_location_assignment PIN_AD2 -to hsma_rx_p[6]
set_location_assignment PIN_AB2 -to hsma_rx_p[7]
set_location_assignment PIN_AM29 -to hsma_scl
set_location_assignment PIN_AL29 -to hsma_sda
set_location_assignment PIN_AU11 -to "hsma_tx_d_p[0](n)"
set_location_assignment PIN_AN11 -to "hsma_tx_d_p[1](n)"
set_location_assignment PIN_AL11 -to "hsma_tx_d_p[2](n)"
set_location_assignment PIN_AF11 -to "hsma_tx_d_p[3](n)"
set_location_assignment PIN_AE11 -to "hsma_tx_d_p[4](n)"
set_location_assignment PIN_AE9 -to "hsma_tx_d_p[5](n)"
set_location_assignment PIN_AC9 -to "hsma_tx_d_p[6](n)"
set_location_assignment PIN_AC12 -to "hsma_tx_d_p[7](n)"
set_location_assignment PIN_P8 -to "hsma_tx_d_p[8](n)"
set_location_assignment PIN_N10 -to "hsma_tx_d_p[9](n)"
set_location_assignment PIN_N9 -to "hsma_tx_d_p[10](n)"
set_location_assignment PIN_J9 -to "hsma_tx_d_p[11](n)"
set_location_assignment PIN_H10 -to "hsma_tx_d_p[12](n)"
set_location_assignment PIN_D9 -to "hsma_tx_d_p[13](n)"
set_location_assignment PIN_C10 -to "hsma_tx_d_p[14](n)"
set_location_assignment PIN_A11 -to "hsma_tx_d_p[15](n)"
set_location_assignment PIN_B8 -to "hsma_tx_d_p[16](n)"
set_location_assignment PIN_AT11 -to hsma_tx_d_p[0]
set_location_assignment PIN_AM11 -to hsma_tx_d_p[1]
set_location_assignment PIN_AK11 -to hsma_tx_d_p[2]
set_location_assignment PIN_AG12 -to hsma_tx_d_p[3]
set_location_assignment PIN_AE10 -to hsma_tx_d_p[4]
set_location_assignment PIN_AD9 -to hsma_tx_d_p[5]
set_location_assignment PIN_AB9 -to hsma_tx_d_p[6]
set_location_assignment PIN_AB12 -to hsma_tx_d_p[7]
set_location_assignment PIN_R8 -to hsma_tx_d_p[8]
set_location_assignment PIN_P10 -to hsma_tx_d_p[9]
set_location_assignment PIN_N8 -to hsma_tx_d_p[10]
set_location_assignment PIN_K9 -to hsma_tx_d_p[11]
set_location_assignment PIN_J10 -to hsma_tx_d_p[12]
set_location_assignment PIN_E9 -to hsma_tx_d_p[13]
set_location_assignment PIN_D10 -to hsma_tx_d_p[14]
set_location_assignment PIN_B11 -to hsma_tx_d_p[15]
set_location_assignment PIN_A8 -to hsma_tx_d_p[16]
set_location_assignment PIN_AU8 -to hsma_tx_led
set_location_assignment PIN_AU3 -to "hsma_tx_p[0](n)"
set_location_assignment PIN_AN3 -to "hsma_tx_p[1](n)"
set_location_assignment PIN_AL3 -to "hsma_tx_p[2](n)"
set_location_assignment PIN_AJ3 -to "hsma_tx_p[3](n)"
set_location_assignment PIN_AG3 -to "hsma_tx_p[4](n)"
set_location_assignment PIN_AE3 -to "hsma_tx_p[5](n)"
set_location_assignment PIN_AC3 -to "hsma_tx_p[6](n)"
set_location_assignment PIN_AA3 -to "hsma_tx_p[7](n)"
set_location_assignment PIN_AU4 -to hsma_tx_p[0]
set_location_assignment PIN_AN4 -to hsma_tx_p[1]
set_location_assignment PIN_AL4 -to hsma_tx_p[2]
set_location_assignment PIN_AJ4 -to hsma_tx_p[3]
set_location_assignment PIN_AG4 -to hsma_tx_p[4]
set_location_assignment PIN_AE4 -to hsma_tx_p[5]
set_location_assignment PIN_AC4 -to hsma_tx_p[6]
set_location_assignment PIN_AA4 -to hsma_tx_p[7]
   
#-----------hsmb-----------   
set_location_assignment PIN_N17 -to hsmb_a[0]
set_location_assignment PIN_P17 -to hsmb_a[1]
set_location_assignment PIN_H13 -to hsmb_a[2]
set_location_assignment PIN_G14 -to hsmb_a[3]
set_location_assignment PIN_L18 -to hsmb_a[4]
set_location_assignment PIN_L19 -to hsmb_a[5]
set_location_assignment PIN_K19 -to hsmb_a[6]
set_location_assignment PIN_J18 -to hsmb_a[7]
set_location_assignment PIN_A17 -to hsmb_a[8]
set_location_assignment PIN_B17 -to hsmb_a[9]
set_location_assignment PIN_G18 -to hsmb_a[10]
set_location_assignment PIN_C18 -to hsmb_a[11]
set_location_assignment PIN_D18 -to hsmb_a[12]
set_location_assignment PIN_A19 -to hsmb_a[13]
set_location_assignment PIN_B19 -to hsmb_a[14]
set_location_assignment PIN_C19 -to hsmb_a[15]
set_location_assignment PIN_M18 -to hsmb_addr_cmd[0]
set_location_assignment PIN_E18 -to hsmb_ba[0]
set_location_assignment PIN_D19 -to hsmb_ba[1]
set_location_assignment PIN_F18 -to hsmb_ba[2]
set_location_assignment PIN_E19 -to hsmb_ba[3]
set_location_assignment PIN_M15 -to hsmb_odt
set_location_assignment PIN_N15 -to hsmb_qvld
set_location_assignment PIN_R16 -to hsmb_casn
set_location_assignment PIN_G19 -to hsmb_cke
set_location_assignment PIN_AF29 -to hsmb_clk_in0
set_location_assignment PIN_T16 -to hsmb_clk_in_n1
set_location_assignment PIN_N16 -to hsmb_clk_in_n2
set_location_assignment PIN_U15 -to hsmb_clk_in_p1
set_location_assignment PIN_P16 -to hsmb_clk_in_p2
set_location_assignment PIN_L16 -to hsmb_clk_out0
set_location_assignment PIN_C16 -to hsmb_clk_out_n1
set_location_assignment PIN_A16 -to hsmb_clk_out_n2
set_location_assignment PIN_D16 -to hsmb_clk_out_p1
set_location_assignment PIN_B16 -to hsmb_clk_out_p2
set_location_assignment PIN_H19 -to hsmb_csn
set_location_assignment PIN_U11 -to hsmb_dm[0]
set_location_assignment PIN_J13 -to hsmb_dm[1]
set_location_assignment PIN_U12 -to hsmb_dm[2]
set_location_assignment PIN_H14 -to hsmb_dm[3]
set_location_assignment PIN_T12 -to hsmb_dq[0]
set_location_assignment PIN_R12 -to hsmb_dq[1]
set_location_assignment PIN_N12 -to hsmb_dq[2]
set_location_assignment PIN_N13 -to hsmb_dq[3]
set_location_assignment PIN_M12 -to hsmb_dq[4]
set_location_assignment PIN_L12 -to hsmb_dq[5]
set_location_assignment PIN_K12 -to hsmb_dq[6]
set_location_assignment PIN_J12 -to hsmb_dq[7]
set_location_assignment PIN_G12 -to hsmb_dq[8]
set_location_assignment PIN_G13 -to hsmb_dq[9]
set_location_assignment PIN_F12 -to hsmb_dq[10]
set_location_assignment PIN_E12 -to hsmb_dq[11]
set_location_assignment PIN_D12 -to hsmb_dq[12]
set_location_assignment PIN_C12 -to hsmb_dq[13]
set_location_assignment PIN_B13 -to hsmb_dq[14]
set_location_assignment PIN_A13 -to hsmb_dq[15]
set_location_assignment PIN_U13 -to hsmb_dq[16]
set_location_assignment PIN_T13 -to hsmb_dq[17]
set_location_assignment PIN_N14 -to hsmb_dq[18]
set_location_assignment PIN_M14 -to hsmb_dq[19]
set_location_assignment PIN_U14 -to hsmb_dq[20]
set_location_assignment PIN_L15 -to hsmb_dq[21]
set_location_assignment PIN_J14 -to hsmb_dq[22]
set_location_assignment PIN_J15 -to hsmb_dq[23]
set_location_assignment PIN_G15 -to hsmb_dq[24]
set_location_assignment PIN_F14 -to hsmb_dq[25]
set_location_assignment PIN_F15 -to hsmb_dq[26]
set_location_assignment PIN_E14 -to hsmb_dq[27]
set_location_assignment PIN_B14 -to hsmb_dq[28]
set_location_assignment PIN_A14 -to hsmb_dq[29]
set_location_assignment PIN_C14 -to hsmb_dq[30]
set_location_assignment PIN_C15 -to hsmb_dq[31]
set_location_assignment PIN_K13 -to hsmb_dqs_n[0]
set_location_assignment PIN_C13 -to hsmb_dqs_n[1]
set_location_assignment PIN_P14 -to hsmb_dqs_n[2]
set_location_assignment PIN_D15 -to hsmb_dqs_n[3]
set_location_assignment PIN_L13 -to hsmb_dqs_p[0]
set_location_assignment PIN_D13 -to hsmb_dqs_p[1]
set_location_assignment PIN_R14 -to hsmb_dqs_p[2]
set_location_assignment PIN_E15 -to hsmb_dqs_p[3]
set_location_assignment PIN_AU7 -to hsmb_prsntn
set_location_assignment PIN_P13 -to hsmb_rasn
set_location_assignment PIN_AR6 -to hsmb_rx_led
set_location_assignment PIN_F1 -to "hsmb_rx_p[0](n)"
set_location_assignment PIN_D1 -to "hsmb_rx_p[1](n)"
set_location_assignment PIN_Y1 -to "hsmb_rx_p[2](n)"
set_location_assignment PIN_V1 -to "hsmb_rx_p[3](n)"
set_location_assignment PIN_F2 -to hsmb_rx_p[0]
set_location_assignment PIN_D2 -to hsmb_rx_p[1]
set_location_assignment PIN_Y2 -to hsmb_rx_p[2]
set_location_assignment PIN_V2 -to hsmb_rx_p[3]
set_location_assignment PIN_AL30 -to hsmb_scl
set_location_assignment PIN_AK30 -to hsmb_sda
set_location_assignment PIN_AP6 -to hsmb_tx_led
set_location_assignment PIN_E3 -to "hsmb_tx_p[0](n)"
set_location_assignment PIN_C3 -to "hsmb_tx_p[1](n)"
set_location_assignment PIN_W3 -to "hsmb_tx_p[2](n)"
set_location_assignment PIN_U3 -to "hsmb_tx_p[3](n)"
set_location_assignment PIN_E4 -to hsmb_tx_p[0]
set_location_assignment PIN_C4 -to hsmb_tx_p[1]
set_location_assignment PIN_W4 -to hsmb_tx_p[2]
set_location_assignment PIN_U4 -to hsmb_tx_p[3]
set_location_assignment PIN_M17 -to hsmb_wen
   
#-----------Others-----------   
set_location_assignment PIN_AF5 -to "refclk0_qr0_p(n)"
set_location_assignment PIN_AF6 -to refclk0_qr0_p
set_location_assignment PIN_AD34 -to "refclk1_ql0_p(n)"
set_location_assignment PIN_AD33 -to refclk1_ql0_p
set_location_assignment PIN_AD6 -to "refclk1_qr0_p(n)"
set_location_assignment PIN_AD7 -to refclk1_qr0_p
set_location_assignment PIN_AB34 -to "refclk2_ql1_p(n)"
set_location_assignment PIN_AB35 -to refclk2_ql1_p
set_location_assignment PIN_AB5 -to "refclk2_qr1_p(n)"
set_location_assignment PIN_AB6 -to refclk2_qr1_p
set_location_assignment PIN_V35 -to "refclk4_ql2_p(n)"
set_location_assignment PIN_V34 -to refclk4_ql2_p
set_location_assignment PIN_V5 -to "refclk4_qr2_p(n)"
set_location_assignment PIN_V6 -to refclk4_qr2_p
set_location_assignment PIN_T34 -to "refclk5_ql2_p(n)"
set_location_assignment PIN_T33 -to refclk5_ql2_p
set_location_assignment PIN_T6 -to "refclk5_qr2_p(n)"
set_location_assignment PIN_T7 -to refclk5_qr2_p
   
set_location_assignment PIN_R3 -to sma_tx_n
set_location_assignment PIN_R4 -to sma_tx_p

########################################################################

set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_a[14]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_a[13]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_a[12]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_a[11]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_a[10]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_a[9]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_a[8]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_a[7]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_a[6]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_a[5]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_a[4]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_a[3]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_a[2]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_a[1]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_a[0]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_ba[2]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_ba[1]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_ba[0]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_casn
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_cke
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_csn
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dm[8]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dm[7]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dm[6]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dm[5]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dm[4]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dm[3]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dm[2]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dm[1]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dm[0]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[71]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[70]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[69]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[68]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[67]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[66]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[65]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[64]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[63]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[62]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[61]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[60]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[59]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[58]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[57]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[56]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[55]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[54]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[53]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[52]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[51]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[50]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[49]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[48]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[47]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[46]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[45]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[44]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[43]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[42]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[41]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[40]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[39]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[38]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[37]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[36]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[35]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[34]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[33]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[32]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[31]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[30]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[29]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[28]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[27]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[26]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[25]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[24]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[23]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[22]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[21]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[20]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[19]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[18]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[17]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[16]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[15]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[14]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[13]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[12]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[11]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[10]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[9]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[8]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[7]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[6]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[5]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[4]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[3]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[2]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[1]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dq[0]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_odt
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_rasn
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_resetn
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_wen

set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[19]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[18]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[17]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[16]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[15]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[14]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[13]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[12]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[11]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[10]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[9]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[8]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[7]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[6]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[5]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[4]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[3]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[2]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[1]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_a[0]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_bwsn[1]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_bwsn[0]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_cq_n
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_cq_p
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[17]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[16]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[15]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[14]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[13]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[12]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[11]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[10]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[9]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[8]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[7]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[6]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[5]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[4]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[3]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[2]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[1]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_d[0]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_k_n
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_k_p
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_odt
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[17]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[16]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[15]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[14]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[13]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[12]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[11]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[10]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[9]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[8]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[7]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[6]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[5]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[4]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[3]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[2]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[1]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_q[0]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_qvld
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_rpsn
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_wpsn
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[22]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[21]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[20]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[19]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[18]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[17]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[16]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[15]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[14]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[13]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[12]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[11]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[10]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[9]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[8]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[7]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[6]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[5]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[4]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[3]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[2]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[1]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_a[0]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_ba[2]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_ba[1]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_ba[0]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_ck_n
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_ck_p
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_csn
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dk_n
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dk_p
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dm
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[17]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[16]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[15]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[14]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[13]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[12]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[11]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[10]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[9]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[8]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[7]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[6]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[5]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[4]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[3]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[2]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[1]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_dq[0]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_qk_n[1]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_qk_n[0]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_qk_p[1]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_qk_p[0]
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_qvld
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_refn
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to rldc_wen
set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "PASSIVE PARALLEL X32"
set_global_assignment -name USE_CONFIGURATION_DEVICE OFF
set_global_assignment -name CRC_ERROR_OPEN_DRAIN ON
set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED"
set_global_assignment -name RESERVE_DATA31_THROUGH_DATA16_AFTER_CONFIGURATION "AS INPUT TRI-STATED"
set_global_assignment -name RESERVE_DATA15_THROUGH_DATA8_AFTER_CONFIGURATION "AS INPUT TRI-STATED"
set_global_assignment -name RESERVE_DATA7_THROUGH_DATA1_AFTER_CONFIGURATION "AS INPUT TRI-STATED"
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -rise
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -fall
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -rise
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -fall
set_global_assignment -name ON_CHIP_BITSTREAM_DECOMPRESSION OFF


#set_location_assignment PIN_AM34 -to cpu_resetn

#set_location_assignment PIN_R30 -to ddr3_a[0]
#set_location_assignment PIN_K30 -to ddr3_a[1]
#set_location_assignment PIN_J30 -to ddr3_a[10]
#set_location_assignment PIN_N31 -to ddr3_a[11]
#set_location_assignment PIN_C31 -to ddr3_a[12]
#set_location_assignment PIN_L31 -to ddr3_a[13]
#set_location_assignment PIN_D30 -to ddr3_a[14]
#set_location_assignment PIN_K31 -to ddr3_a[2]
#set_location_assignment PIN_P31 -to ddr3_a[3]
#set_location_assignment PIN_E30 -to ddr3_a[4]
#set_location_assignment PIN_B31 -to ddr3_a[5]
#set_location_assignment PIN_B28 -to ddr3_a[6]
#set_location_assignment PIN_D31 -to ddr3_a[7]
#set_location_assignment PIN_R31 -to ddr3_a[8]
#set_location_assignment PIN_J31 -to ddr3_a[9]
#set_location_assignment PIN_E31 -to ddr3_ba[0]
#set_location_assignment PIN_G31 -to ddr3_ba[1]
#set_location_assignment PIN_H31 -to ddr3_ba[2]
#set_location_assignment PIN_C30 -to ddr3_casn
#set_location_assignment PIN_N30 -to ddr3_clk_p
#set_location_assignment PIN_M30 -to ddr3_clk_n
#set_location_assignment PIN_G30 -to ddr3_cke
#set_location_assignment PIN_J29 -to ddr3_csn
#set_location_assignment PIN_A29 -to ddr3_dm[0]
#set_location_assignment PIN_K28 -to ddr3_dm[1]
#set_location_assignment PIN_C27 -to ddr3_dm[2]
#set_location_assignment PIN_L27 -to ddr3_dm[3]
#set_location_assignment PIN_A25 -to ddr3_dm[4]
#set_location_assignment PIN_J25 -to ddr3_dm[5]
#set_location_assignment PIN_A23 -to ddr3_dm[6]
#set_location_assignment PIN_A20 -to ddr3_dm[7]
#set_location_assignment PIN_N21 -to ddr3_dm[8]
#set_location_assignment PIN_A28 -to ddr3_dq[0]
#set_location_assignment PIN_B29 -to ddr3_dq[1]
#set_location_assignment PIN_V29 -to ddr3_dq[10]
#set_location_assignment PIN_U29 -to ddr3_dq[11]
#set_location_assignment PIN_R29 -to ddr3_dq[12]
#set_location_assignment PIN_P29 -to ddr3_dq[13]
#set_location_assignment PIN_N28 -to ddr3_dq[14]
#set_location_assignment PIN_M29 -to ddr3_dq[15]
#set_location_assignment PIN_A26 -to ddr3_dq[16]
#set_location_assignment PIN_C26 -to ddr3_dq[17]
#set_location_assignment PIN_G26 -to ddr3_dq[18]
#set_location_assignment PIN_F26 -to ddr3_dq[19]
#set_location_assignment PIN_F29 -to ddr3_dq[2]
#set_location_assignment PIN_J26 -to ddr3_dq[20]
#set_location_assignment PIN_H26 -to ddr3_dq[21]
#set_location_assignment PIN_E27 -to ddr3_dq[22]
#set_location_assignment PIN_D27 -to ddr3_dq[23]
#set_location_assignment PIN_J27 -to ddr3_dq[24]
#set_location_assignment PIN_M27 -to ddr3_dq[25]
#set_location_assignment PIN_U26 -to ddr3_dq[26]
#set_location_assignment PIN_U27 -to ddr3_dq[27]
#set_location_assignment PIN_T27 -to ddr3_dq[28]
#set_location_assignment PIN_R27 -to ddr3_dq[29]
#set_location_assignment PIN_E28 -to ddr3_dq[3]
#set_location_assignment PIN_N27 -to ddr3_dq[30]
#set_location_assignment PIN_P28 -to ddr3_dq[31]
#set_location_assignment PIN_C25 -to ddr3_dq[32]
#set_location_assignment PIN_B25 -to ddr3_dq[33]
#set_location_assignment PIN_G24 -to ddr3_dq[34]
#set_location_assignment PIN_F24 -to ddr3_dq[35]
#set_location_assignment PIN_H25 -to ddr3_dq[36]
#set_location_assignment PIN_G25 -to ddr3_dq[37]
#set_location_assignment PIN_D24 -to ddr3_dq[38]
#set_location_assignment PIN_C24 -to ddr3_dq[39]
#set_location_assignment PIN_H28 -to ddr3_dq[4]
#set_location_assignment PIN_L26 -to ddr3_dq[40]
#set_location_assignment PIN_K25 -to ddr3_dq[41]
#set_location_assignment PIN_P25 -to ddr3_dq[42]
#set_location_assignment PIN_N25 -to ddr3_dq[43]
#set_location_assignment PIN_U25 -to ddr3_dq[44]
#set_location_assignment PIN_T25 -to ddr3_dq[45]
#set_location_assignment PIN_P26 -to ddr3_dq[46]
#set_location_assignment PIN_N26 -to ddr3_dq[47]
#set_location_assignment PIN_A22 -to ddr3_dq[48]
#set_location_assignment PIN_B23 -to ddr3_dq[49]
#set_location_assignment PIN_G28 -to ddr3_dq[5]
#set_location_assignment PIN_H23 -to ddr3_dq[50]
#set_location_assignment PIN_G23 -to ddr3_dq[51]
#set_location_assignment PIN_H22 -to ddr3_dq[52]
#set_location_assignment PIN_G22 -to ddr3_dq[53]
#set_location_assignment PIN_C22 -to ddr3_dq[54]
#set_location_assignment PIN_D22 -to ddr3_dq[55]
#set_location_assignment PIN_D21 -to ddr3_dq[56]
#set_location_assignment PIN_B20 -to ddr3_dq[57]
#set_location_assignment PIN_F20 -to ddr3_dq[58]
#set_location_assignment PIN_E20 -to ddr3_dq[59]
#set_location_assignment PIN_D28 -to ddr3_dq[6]
#set_location_assignment PIN_H20 -to ddr3_dq[60]
#set_location_assignment PIN_G20 -to ddr3_dq[61]
#set_location_assignment PIN_C20 -to ddr3_dq[62]
#set_location_assignment PIN_C21 -to ddr3_dq[63]
#set_location_assignment PIN_N22 -to ddr3_dq[64]
#set_location_assignment PIN_N20 -to ddr3_dq[65]
#set_location_assignment PIN_K21 -to ddr3_dq[66]
#set_location_assignment PIN_J21 -to ddr3_dq[67]
#set_location_assignment PIN_M20 -to ddr3_dq[68]
#set_location_assignment PIN_L20 -to ddr3_dq[69]
#set_location_assignment PIN_C28 -to ddr3_dq[7]
#set_location_assignment PIN_M21 -to ddr3_dq[70]
#set_location_assignment PIN_L21 -to ddr3_dq[71]
#set_location_assignment PIN_J28 -to ddr3_dq[8]
#set_location_assignment PIN_L28 -to ddr3_dq[9]
#set_location_assignment PIN_H29 -to ddr3_dqs_p[0]
#set_location_assignment PIN_U30 -to ddr3_dqs_p[1]
#set_location_assignment PIN_G27 -to ddr3_dqs_p[2]
#set_location_assignment PIN_U28 -to ddr3_dqs_p[3]
#set_location_assignment PIN_E24 -to ddr3_dqs_p[4]
#set_location_assignment PIN_R25 -to ddr3_dqs_p[5]
#set_location_assignment PIN_F23 -to ddr3_dqs_p[6]
#set_location_assignment PIN_G21 -to ddr3_dqs_p[7]
#set_location_assignment PIN_K22 -to ddr3_dqs_p[8]
#set_location_assignment PIN_G29 -to ddr3_dqs_n[0]
#set_location_assignment PIN_T30 -to ddr3_dqs_n[1]
#set_location_assignment PIN_F27 -to ddr3_dqs_n[2]
#set_location_assignment PIN_T28 -to ddr3_dqs_n[3]
#set_location_assignment PIN_E25 -to ddr3_dqs_n[4]
#set_location_assignment PIN_R26 -to ddr3_dqs_n[5]
#set_location_assignment PIN_E23 -to ddr3_dqs_n[6]
#set_location_assignment PIN_F21 -to ddr3_dqs_n[7]
#set_location_assignment PIN_J22 -to ddr3_dqs_n[8]
#set_location_assignment PIN_A31 -to ddr3_odt
#set_location_assignment PIN_F30 -to ddr3_rasn
#set_location_assignment PIN_B26 -to ddr3_resetn
#set_location_assignment PIN_L30 -to ddr3_wen

#set_location_assignment PIN_AA26 -to enet_mdc
#set_location_assignment PIN_AA27 -to enet_mdio
#set_location_assignment PIN_AA28 -to enet_resetn
#set_location_assignment PIN_AU25 -to enet_rx_n
#set_location_assignment PIN_AU24 -to enet_rx_p
#set_location_assignment PIN_AC27 -to enet_tx_n
#set_location_assignment PIN_AB27 -to enet_tx_p
#set_location_assignment PIN_AP7 -to flash_advn
#set_location_assignment PIN_AV14 -to flash_cen[0]
#set_location_assignment PIN_AW13 -to flash_cen[1]
#set_location_assignment PIN_AM8 -to flash_clk
#set_location_assignment PIN_AJ7 -to flash_oen
#set_location_assignment PIN_AL6 -to flash_rdybsyn[0]
#set_location_assignment PIN_AN7 -to flash_rdybsyn[1]
#set_location_assignment PIN_AJ6 -to flash_resetn
#set_location_assignment PIN_AN8 -to flash_wen
#set_location_assignment PIN_AW19 -to fm_a[0]
#set_location_assignment PIN_AV19 -to fm_a[1]
#set_location_assignment PIN_AT17 -to fm_a[10]
#set_location_assignment PIN_AR17 -to fm_a[11]
#set_location_assignment PIN_AU16 -to fm_a[12]
#set_location_assignment PIN_AU17 -to fm_a[13]
#set_location_assignment PIN_AW16 -to fm_a[14]
#set_location_assignment PIN_AV16 -to fm_a[15]
#set_location_assignment PIN_AW17 -to fm_a[16]
#set_location_assignment PIN_AV17 -to fm_a[17]
#set_location_assignment PIN_AU6 -to fm_a[18]
#set_location_assignment PIN_AT6 -to fm_a[19]
#set_location_assignment PIN_AM16 -to fm_a[2]
#set_location_assignment PIN_AL17 -to fm_a[20]
#set_location_assignment PIN_AK17 -to fm_a[21]
#set_location_assignment PIN_AE16 -to fm_a[22]
#set_location_assignment PIN_AE17 -to fm_a[23]
#set_location_assignment PIN_AH16 -to fm_a[24]
#set_location_assignment PIN_AP21 -to fm_a[25]
#set_location_assignment PIN_AJ17 -to fm_a[26]
#set_location_assignment PIN_AL16 -to fm_a[3]
#set_location_assignment PIN_AG16 -to fm_a[4]
#set_location_assignment PIN_AF16 -to fm_a[5]
#set_location_assignment PIN_AN17 -to fm_a[6]
#set_location_assignment PIN_AM17 -to fm_a[7]
#set_location_assignment PIN_AP16 -to fm_a[8]
#set_location_assignment PIN_AN16 -to fm_a[9]
#set_location_assignment PIN_AN21 -to fm_d[0]
#set_location_assignment PIN_AD21 -to fm_d[1]
#set_location_assignment PIN_AJ20 -to fm_d[10]
#set_location_assignment PIN_AL21 -to fm_d[11]
#set_location_assignment PIN_AL20 -to fm_d[12]
#set_location_assignment PIN_AN25 -to fm_d[13]
#set_location_assignment PIN_AM25 -to fm_d[14]
#set_location_assignment PIN_AP24 -to fm_d[15]
#set_location_assignment PIN_AN24 -to fm_d[16]
#set_location_assignment PIN_AC24 -to fm_d[17]
#set_location_assignment PIN_AB24 -to fm_d[18]
#set_location_assignment PIN_AF25 -to fm_d[19]
#set_location_assignment PIN_AD20 -to fm_d[2]
#set_location_assignment PIN_AE25 -to fm_d[20]
#set_location_assignment PIN_AE24 -to fm_d[21]
#set_location_assignment PIN_AD24 -to fm_d[22]
#set_location_assignment PIN_AG24 -to fm_d[23]
#set_location_assignment PIN_AH24 -to fm_d[24]
#set_location_assignment PIN_AK24 -to fm_d[25]
#set_location_assignment PIN_AJ24 -to fm_d[26]
#set_location_assignment PIN_AL24 -to fm_d[27]
#set_location_assignment PIN_AL25 -to fm_d[28]
#set_location_assignment PIN_AW25 -to fm_d[29]
#set_location_assignment PIN_AG21 -to fm_d[3]
#set_location_assignment PIN_AV25 -to fm_d[30]
#set_location_assignment PIN_AT24 -to fm_d[31]
#set_location_assignment PIN_AH21 -to fm_d[4]
#set_location_assignment PIN_AE21 -to fm_d[5]
#set_location_assignment PIN_AE20 -to fm_d[6]
#set_location_assignment PIN_AL22 -to fm_d[7]
#set_location_assignment PIN_AK21 -to fm_d[8]
#set_location_assignment PIN_AJ21 -to fm_d[9]
#
#set_location_assignment PIN_AU9 -to lcd_csn
#set_location_assignment PIN_AH10 -to lcd_d_cn
#set_location_assignment PIN_AP10 -to lcd_data[0]
#set_location_assignment PIN_AN10 -to lcd_data[1]
#set_location_assignment PIN_AM10 -to lcd_data[2]
#set_location_assignment PIN_AL10 -to lcd_data[3]
#set_location_assignment PIN_AP9 -to lcd_data[4]
#set_location_assignment PIN_AN9 -to lcd_data[5]
#set_location_assignment PIN_AT9 -to lcd_data[6]
#set_location_assignment PIN_AR9 -to lcd_data[7]
#set_location_assignment PIN_AW10 -to lcd_wen
#
#set_location_assignment PIN_U31 -to max5_ben[0]
#set_location_assignment PIN_T31 -to max5_ben[1]
#set_location_assignment PIN_N33 -to max5_ben[2]
#set_location_assignment PIN_M33 -to max5_ben[3]
#set_location_assignment PIN_E34 -to max5_clk
#set_location_assignment PIN_B32 -to max5_csn
#set_location_assignment PIN_A32 -to max5_oen
#set_location_assignment PIN_A34 -to max5_wen

set_location_assignment PIN_B34 -to rzqin_1p5
set_instance_assignment -name IO_STANDARD "1.5 V" -to rzqin_1p5
set_location_assignment PIN_AK6 -to rzqin_1p8
set_instance_assignment -name IO_STANDARD "1.8 V" -to rzqin_1p8

#set_location_assignment PIN_AB13 -to qdrii_a[0]
#set_location_assignment PIN_AD14 -to qdrii_a[1]
#set_location_assignment PIN_AF13 -to qdrii_a[10]
#set_location_assignment PIN_AM13 -to qdrii_a[11]
#set_location_assignment PIN_AL13 -to qdrii_a[12]
#set_location_assignment PIN_AP12 -to qdrii_a[13]
#set_location_assignment PIN_AN12 -to qdrii_a[14]
#set_location_assignment PIN_AP13 -to qdrii_a[15]
#set_location_assignment PIN_AN13 -to qdrii_a[16]
#set_location_assignment PIN_AU14 -to qdrii_a[17]
#set_location_assignment PIN_AT14 -to qdrii_a[18]
#set_location_assignment PIN_AW14 -to qdrii_a[19]
#set_location_assignment PIN_AC14 -to qdrii_a[2]
#set_location_assignment PIN_AC13 -to qdrii_a[20]
#set_location_assignment PIN_AA13 -to qdrii_a[3]
#set_location_assignment PIN_AA12 -to qdrii_a[4]
#set_location_assignment PIN_AF14 -to qdrii_a[5]
#set_location_assignment PIN_AE14 -to qdrii_a[6]
#set_location_assignment PIN_AJ13 -to qdrii_a[7]
#set_location_assignment PIN_AH13 -to qdrii_a[8]
#set_location_assignment PIN_AG13 -to qdrii_a[9]
#set_location_assignment PIN_AB15 -to qdrii_bwsn[0]
#set_location_assignment PIN_AB16 -to qdrii_bwsn[1]
#set_location_assignment PIN_AF19 -to qdrii_cq_n
#set_location_assignment PIN_AN19 -to qdrii_cq_p
#set_location_assignment PIN_AA15 -to qdrii_d[0]
#set_location_assignment PIN_AA14 -to qdrii_d[1]
#set_location_assignment PIN_AN14 -to qdrii_d[10]
#set_location_assignment PIN_AM14 -to qdrii_d[11]
#set_location_assignment PIN_AP15 -to qdrii_d[12]
#set_location_assignment PIN_AN15 -to qdrii_d[13]
#set_location_assignment PIN_AR15 -to qdrii_d[14]
#set_location_assignment PIN_AR14 -to qdrii_d[15]
#set_location_assignment PIN_AU15 -to qdrii_d[16]
#set_location_assignment PIN_AT15 -to qdrii_d[17]
#set_location_assignment PIN_AE15 -to qdrii_d[2]
#set_location_assignment PIN_AD15 -to qdrii_d[3]
#set_location_assignment PIN_AJ15 -to qdrii_d[4]
#set_location_assignment PIN_AH15 -to qdrii_d[5]
#set_location_assignment PIN_AG14 -to qdrii_d[6]
#set_location_assignment PIN_AG15 -to qdrii_d[7]
#set_location_assignment PIN_AL15 -to qdrii_d[8]
#set_location_assignment PIN_AK15 -to qdrii_d[9]
#set_location_assignment PIN_AV13 -to qdrii_doffn
#set_location_assignment PIN_AL14 -to qdrii_k_n
#set_location_assignment PIN_AK14 -to qdrii_k_p
#set_location_assignment PIN_AU18 -to qdrii_odt
#set_location_assignment PIN_AH19 -to qdrii_q[0]
#set_location_assignment PIN_AG19 -to qdrii_q[1]
#set_location_assignment PIN_AD18 -to qdrii_q[10]
#set_location_assignment PIN_AM19 -to qdrii_q[11]
#set_location_assignment PIN_AL18 -to qdrii_q[12]
#set_location_assignment PIN_AN18 -to qdrii_q[13]
#set_location_assignment PIN_AR18 -to qdrii_q[14]
#set_location_assignment PIN_AP18 -to qdrii_q[15]
#set_location_assignment PIN_AR19 -to qdrii_q[16]
#set_location_assignment PIN_AP19 -to qdrii_q[17]
#set_location_assignment PIN_AK18 -to qdrii_q[2]
#set_location_assignment PIN_AJ19 -to qdrii_q[3]
#set_location_assignment PIN_AJ18 -to qdrii_q[4]
#set_location_assignment PIN_AH18 -to qdrii_q[5]
#set_location_assignment PIN_AG18 -to qdrii_q[6]
#set_location_assignment PIN_AE19 -to qdrii_q[7]
#set_location_assignment PIN_AE18 -to qdrii_q[8]
#set_location_assignment PIN_AD17 -to qdrii_q[9]
#set_location_assignment PIN_AT18 -to qdrii_qvld
#set_location_assignment PIN_AC15 -to qdrii_rpsn
#set_location_assignment PIN_AD16 -to qdrii_wpsn
#
#set_location_assignment PIN_AE27 -to qsfp_interruptn
#set_location_assignment PIN_AD27 -to qsfp_lp_mode
#set_location_assignment PIN_AH27 -to qsfp_mod_prsn
#set_location_assignment PIN_AG27 -to qsfp_mod_seln
#set_location_assignment PIN_AE30 -to qsfp_rstn
#set_location_assignment PIN_AD30 -to qsfp_scl
#set_location_assignment PIN_AC30 -to qsfp_sda
#
#set_location_assignment PIN_AW23 -to rldc_a[0]
#set_location_assignment PIN_AV23 -to rldc_a[1]
#set_location_assignment PIN_AN23 -to rldc_a[10]
#set_location_assignment PIN_AM23 -to rldc_a[11]
#set_location_assignment PIN_AE23 -to rldc_a[12]
#set_location_assignment PIN_AD23 -to rldc_a[13]
#set_location_assignment PIN_AG23 -to rldc_a[14]
#set_location_assignment PIN_AF23 -to rldc_a[15]
#set_location_assignment PIN_AE22 -to rldc_a[16]
#set_location_assignment PIN_AD22 -to rldc_a[17]
#set_location_assignment PIN_AG22 -to rldc_a[18]
#set_location_assignment PIN_AF22 -to rldc_a[19]
#set_location_assignment PIN_AW22 -to rldc_a[2]
#set_location_assignment PIN_AW20 -to rldc_a[20]
#set_location_assignment PIN_AV20 -to rldc_a[21]
#set_location_assignment PIN_AK23 -to rldc_a[22]
#set_location_assignment PIN_AV22 -to rldc_a[3]
#set_location_assignment PIN_AU23 -to rldc_a[4]
#set_location_assignment PIN_AT23 -to rldc_a[5]
#set_location_assignment PIN_AR22 -to rldc_a[6]
#set_location_assignment PIN_AP22 -to rldc_a[7]
#set_location_assignment PIN_AN22 -to rldc_a[8]
#set_location_assignment PIN_AM22 -to rldc_a[9]
#set_location_assignment PIN_AR20 -to rldc_ba[0]
#set_location_assignment PIN_AM20 -to rldc_ba[1]
#set_location_assignment PIN_AN20 -to rldc_ba[2]
#set_location_assignment PIN_AU21 -to rldc_ck_n
#set_location_assignment PIN_AT21 -to rldc_ck_p
#set_location_assignment PIN_AU20 -to rldc_csn
#set_location_assignment PIN_AR25 -to rldc_dk_n
#set_location_assignment PIN_AP25 -to rldc_dk_p
#set_location_assignment PIN_AG25 -to rldc_dm
#set_location_assignment PIN_AU27 -to rldc_dq[0]
#set_location_assignment PIN_AT27 -to rldc_dq[1]
#set_location_assignment PIN_AD26 -to rldc_dq[10]
#set_location_assignment PIN_AA25 -to rldc_dq[11]
#set_location_assignment PIN_AB25 -to rldc_dq[12]
#set_location_assignment PIN_AC26 -to rldc_dq[13]
#set_location_assignment PIN_AC25 -to rldc_dq[14]
#set_location_assignment PIN_AG26 -to rldc_dq[15]
#set_location_assignment PIN_AF26 -to rldc_dq[16]
#set_location_assignment PIN_AH25 -to rldc_dq[17]
#set_location_assignment PIN_AW26 -to rldc_dq[2]
#set_location_assignment PIN_AV26 -to rldc_dq[3]
#set_location_assignment PIN_AU26 -to rldc_dq[4]
#set_location_assignment PIN_AT26 -to rldc_dq[5]
#set_location_assignment PIN_AM26 -to rldc_dq[6]
#set_location_assignment PIN_AL26 -to rldc_dq[7]
#set_location_assignment PIN_AN27 -to rldc_dq[8]
#set_location_assignment PIN_AE26 -to rldc_dq[9]
#set_location_assignment PIN_AR27 -to rldc_qk_n[0]
#set_location_assignment PIN_AK26 -to rldc_qk_n[1]
#set_location_assignment PIN_AP27 -to rldc_qk_p[0]
#set_location_assignment PIN_AJ26 -to rldc_qk_p[1]
#set_location_assignment PIN_AN26 -to rldc_qvld
#set_location_assignment PIN_AR21 -to rldc_refn
#set_location_assignment PIN_AT20 -to rldc_wen
#
#set_location_assignment PIN_AB30 -to sdi_rx_bypass
#set_location_assignment PIN_AK27 -to sdi_tx_en
#set_location_assignment PIN_AJ27 -to sdi_tx_sd_hdn
#
#set_location_assignment PIN_A35 -to usb_data[0]
#set_location_assignment PIN_C34 -to usb_data[1]
#set_location_assignment PIN_A36 -to usb_data[2]
#set_location_assignment PIN_A37 -to usb_data[3]
#set_location_assignment PIN_E32 -to usb_data[4]
#set_location_assignment PIN_F32 -to usb_data[5]
#set_location_assignment PIN_G33 -to usb_data[6]
#set_location_assignment PIN_G32 -to usb_data[7]
#set_location_assignment PIN_G34 -to usb_addr[0]
#set_location_assignment PIN_K34 -to usb_addr[1]
#set_location_assignment PIN_N34 -to usb_full
#set_location_assignment PIN_P34 -to usb_empty
#set_location_assignment PIN_J34 -to usb_scl
#set_location_assignment PIN_F33 -to usb_sda
#set_location_assignment PIN_H34 -to usb_resetn
#set_location_assignment PIN_E33 -to usb_oen
#set_location_assignment PIN_K33 -to usb_rdn
#set_location_assignment PIN_J33 -to usb_wrn
#set_location_assignment PIN_A7 -to user_pb[0]
#set_location_assignment PIN_B7 -to user_pb[1]
#set_location_assignment PIN_C7 -to user_pb[2]
#
#set_location_assignment PIN_J11 -to user_led_g[0]
#set_location_assignment PIN_U10 -to user_led_g[1]
#set_location_assignment PIN_U9 -to user_led_g[2]
#set_location_assignment PIN_AN33 -to user_led_g[3]
#set_location_assignment PIN_AF28 -to user_led_g[4]
#set_location_assignment PIN_AE29 -to user_led_g[5]
#set_location_assignment PIN_AU10 -to user_led_g[6]
#set_location_assignment PIN_AV10 -to user_led_g[7]
#set_location_assignment PIN_AH28 -to user_led_r[0]
#set_location_assignment PIN_AG30 -to user_led_r[1]
#set_location_assignment PIN_AL7 -to user_led_r[2]
#set_location_assignment PIN_AR24 -to user_led_r[3]
#set_location_assignment PIN_AM7 -to user_led_r[4]
#set_location_assignment PIN_AW7 -to user_led_r[5]
#set_location_assignment PIN_AL23 -to user_led_r[6]
#set_location_assignment PIN_AV7 -to user_led_r[7]
#
#set_location_assignment PIN_E7 -to user_dipsw[0]
#set_location_assignment PIN_H7 -to user_dipsw[1]
#set_location_assignment PIN_J7 -to user_dipsw[2]
#set_location_assignment PIN_K7 -to user_dipsw[3]
#set_location_assignment PIN_M6 -to user_dipsw[4]
#set_location_assignment PIN_N6 -to user_dipsw[5]
#set_location_assignment PIN_P7 -to user_dipsw[6]
#set_location_assignment PIN_N7 -to user_dipsw[7]



set_instance_assignment -name IO_STANDARD "1.8 V" -to clkin_50
#set_location_assignment PIN_AN6 -to clkin_50

set_instance_assignment -name IO_STANDARD LVDS -to clk_125_p
set_instance_assignment -name IO_STANDARD LVDS -to clkinbot_p[0]
set_instance_assignment -name IO_STANDARD LVDS -to clkinbot_p[1]
set_instance_assignment -name IO_STANDARD LVDS -to clkintop_p[0]
set_instance_assignment -name IO_STANDARD LVDS -to clkintop_p[1]
#set_location_assignment PIN_AJ22 -to "clk_125_p(n)"
#set_location_assignment PIN_AH22 -to clk_125_p
#set_location_assignment PIN_AW29 -to "clkinbot_p[0](n)"
#set_location_assignment PIN_AV29 -to clkinbot_p[0]
#set_location_assignment PIN_AF17 -to clkinbot_p[1]
#set_location_assignment PIN_AG17 -to "clkinbot_p[1](n)"
#set_location_assignment PIN_J23 -to clkintop_p[0]
#set_location_assignment PIN_J24 -to "clkintop_p[0](n)"
#set_location_assignment PIN_N32 -to clkintop_p[1]
#set_location_assignment PIN_M32 -to "clkintop_p[1](n)"


set_instance_assignment -name IO_STANDARD "2.5 V" -to cpu_resetn
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_clk_n
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_clk_p
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_p[0]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_p[1]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_p[2]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_p[3]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_p[4]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_p[5]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_p[6]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_p[7]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_p[8]
set_instance_assignment -name IO_STANDARD "2.5 V" -to enet_intn
set_instance_assignment -name IO_STANDARD "2.5 V" -to enet_mdc
set_instance_assignment -name IO_STANDARD "2.5 V" -to enet_mdio
set_instance_assignment -name IO_STANDARD "2.5 V" -to enet_resetn
set_instance_assignment -name IO_STANDARD LVDS -to enet_rx_p
set_instance_assignment -name IO_STANDARD LVDS -to enet_tx_p
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_oen
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_rdybsyn
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_resetn
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_wen
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[25]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[24]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[23]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[22]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[21]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[20]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[19]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[18]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[17]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[16]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[15]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[14]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[13]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[12]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[11]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[10]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[9]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[8]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_a[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[31]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[30]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[29]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[28]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[27]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[26]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[25]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[24]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[23]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[22]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[21]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[20]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[19]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[18]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[17]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[16]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[15]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[14]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[13]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[12]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[11]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[10]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[9]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[8]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fm_d[0]

set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_csn
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[6]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[5]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[4]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_wen
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_d_cn
set_instance_assignment -name IO_STANDARD "2.5 V" -to lcd_data[7]
set_instance_assignment -name IO_STANDARD "1.5 V" -to max5_ben[3]
set_instance_assignment -name IO_STANDARD "1.5 V" -to max5_ben[2]
set_instance_assignment -name IO_STANDARD "1.5 V" -to max5_ben[1]
set_instance_assignment -name IO_STANDARD "1.5 V" -to max5_ben[0]
set_instance_assignment -name IO_STANDARD "1.5 V" -to max5_clk
set_instance_assignment -name IO_STANDARD "1.5 V" -to max5_csn
set_instance_assignment -name IO_STANDARD "1.5 V" -to max5_oen
set_instance_assignment -name IO_STANDARD "1.5 V" -to max5_wen
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_rx_p[0]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_rx_p[1]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_rx_p[2]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_rx_p[3]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_rx_p[4]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_rx_p[5]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_rx_p[6]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_rx_p[7]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_tx_p[0]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_tx_p[1]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_tx_p[3]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_tx_p[4]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_tx_p[5]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_tx_p[6]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_tx_p[7]

set_instance_assignment -name IO_STANDARD "2.5 V" -to qsfp_interruptn
set_instance_assignment -name IO_STANDARD "2.5 V" -to qsfp_lp_mode
set_instance_assignment -name IO_STANDARD "2.5 V" -to qsfp_mod_prsn
set_instance_assignment -name IO_STANDARD "2.5 V" -to qsfp_mod_seln
set_instance_assignment -name IO_STANDARD "2.5 V" -to qsfp_rstn
set_instance_assignment -name IO_STANDARD "2.5 V" -to sdi_rx_bypass
set_instance_assignment -name IO_STANDARD "2.5 V" -to sdi_rx_en
set_instance_assignment -name IO_STANDARD "2.5 V" -to sdi_tx_en
set_instance_assignment -name IO_STANDARD "2.5 V" -to sdi_tx_sd_hdn
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_data[7]
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_data[6]
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_data[5]
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_data[4]
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_data[3]
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_data[2]
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_data[1]
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_data[0]
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_addr[1]
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_addr[0]
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_full
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_empty
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_scl
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_sda
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_resetn
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_oen
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_rdn
set_instance_assignment -name IO_STANDARD "1.5 V" -to usb_wrn
set_instance_assignment -name IO_STANDARD "1.5 V" -to user_pb[2]
set_instance_assignment -name IO_STANDARD "1.5 V" -to user_pb[1]
set_instance_assignment -name IO_STANDARD "1.5 V" -to user_pb[0]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to qsfp_rx_n[0]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to qsfp_rx_n[1]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to qsfp_rx_n[2]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to qsfp_rx_n[3]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to qsfp_rx_p[0]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to qsfp_rx_p[1]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to qsfp_rx_p[2]
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to qsfp_rx_p[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to qsfp_tx_n[0]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to qsfp_tx_n[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to qsfp_tx_n[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to qsfp_tx_n[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to qsfp_tx_p[0]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to qsfp_tx_p[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to qsfp_tx_p[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to qsfp_tx_p[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to qsfp_scl
set_instance_assignment -name IO_STANDARD "2.5 V" -to qsfp_sda

set_instance_assignment -name IO_STANDARD "2.5 V" -to user_led_g[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to user_led_g[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to user_led_g[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to user_led_g[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to user_led_g[4]
set_instance_assignment -name IO_STANDARD "2.5 V" -to user_led_g[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to user_led_g[6]
set_instance_assignment -name IO_STANDARD "2.5 V" -to user_led_g[7]
set_instance_assignment -name IO_STANDARD "2.5 V" -to user_led_r[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to user_led_r[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to user_led_r[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to user_led_r[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to user_led_r[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to user_led_r[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to user_led_r[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to user_led_r[7]

set_instance_assignment -name IO_STANDARD "1.5 V" -to user_dipsw[7]
set_instance_assignment -name IO_STANDARD "1.5 V" -to user_dipsw[0]
set_instance_assignment -name IO_STANDARD "1.5 V" -to user_dipsw[1]
set_instance_assignment -name IO_STANDARD "1.5 V" -to user_dipsw[2]
set_instance_assignment -name IO_STANDARD "1.5 V" -to user_dipsw[3]
set_instance_assignment -name IO_STANDARD "1.5 V" -to user_dipsw[4]
set_instance_assignment -name IO_STANDARD "1.5 V" -to user_dipsw[5]
set_instance_assignment -name IO_STANDARD "1.5 V" -to user_dipsw[6]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_n[8]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_n[7]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_n[6]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_n[5]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_n[4]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_n[3]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_n[2]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_n[1]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to ddr3_dqs_n[0]

#set_location_assignment PIN_AA29 -to enet_intn
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_advn
set_instance_assignment -name IO_STANDARD "1.8 V" -to flash_cen
set_instance_assignment -name IO_STANDARD "1.8-V HSTL CLASS I" -to qdrii_doffn
set_global_assignment -name FORCE_CONFIGURATION_VCCIO ON
set_global_assignment -name CONFIGURATION_VCCIO_LEVEL 2.5V

########## DisplayPort Signals ################
#set_location_assignment PIN_N3 -to "dp_ml_lane_p[0](n)"
#set_location_assignment PIN_N4 -to dp_ml_lane_p[0]
#set_location_assignment PIN_L3 -to "dp_ml_lane_p[1](n)"
#set_location_assignment PIN_L4 -to dp_ml_lane_p[1]
#set_location_assignment PIN_J3 -to "dp_ml_lane_p[2](n)"
#set_location_assignment PIN_J4 -to dp_ml_lane_p[2]
#set_location_assignment PIN_G3 -to "dp_ml_lane_p[3](n)"
#set_location_assignment PIN_G4 -to dp_ml_lane_p[3]

set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to dp_ml_lane_p

#set_location_assignment PIN_P11 -to "dp_aux_p(n)"
#set_location_assignment PIN_R11 -to dp_aux_p
#set_location_assignment PIN_R10 -to "dp_aux_tx_p(n)"
#set_location_assignment PIN_T10 -to dp_aux_tx_p
#set_location_assignment PIN_K10 -to dp_direction
#set_location_assignment PIN_L11 -to dp_hot_plug
#set_location_assignment PIN_M11 -to dp_return

set_instance_assignment -name IO_STANDARD LVDS -to dp_aux_p
set_instance_assignment -name IO_STANDARD LVDS -to dp_aux_tx_p
set_instance_assignment -name IO_STANDARD "2.5 V" -to dp_direction
set_instance_assignment -name IO_STANDARD "2.5 V" -to dp_hot_plug
set_instance_assignment -name IO_STANDARD "2.5 V" -to dp_return

set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 2.5-V SSTL CLASS I" -to dp_aux_ch_n
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to dp_aux_ch_n -disable
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION" -to dp_aux_p -disable
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to dp_aux_ch_n -disable
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION" -to dp_aux_p -disable

##########################################################

###Transceivers###
#set_location_assignment PIN_P39 -to "qsfp_rx_p[0](n)"
#set_location_assignment PIN_P38 -to qsfp_rx_p[0]
#set_location_assignment PIN_M39 -to "qsfp_rx_p[1](n)"
#set_location_assignment PIN_M38 -to qsfp_rx_p[1]
#set_location_assignment PIN_K39 -to "qsfp_rx_p[2](n)"
#set_location_assignment PIN_K38 -to qsfp_rx_p[2]
#set_location_assignment PIN_H39 -to "qsfp_rx_p[3](n)"
#set_location_assignment PIN_H38 -to qsfp_rx_p[3]
#
#set_location_assignment PIN_N37 -to "qsfp_tx_p[0](n)"
#set_location_assignment PIN_N36 -to qsfp_tx_p[0]
#set_location_assignment PIN_L37 -to "qsfp_tx_p[1](n)"
#set_location_assignment PIN_L36 -to qsfp_tx_p[1]
#set_location_assignment PIN_J37 -to "qsfp_tx_p[2](n)"
#set_location_assignment PIN_J36 -to qsfp_tx_p[2]
#set_location_assignment PIN_G37 -to "qsfp_tx_p[3](n)"
#set_location_assignment PIN_G36 -to qsfp_tx_p[3]
#
#set_location_assignment PIN_F39 -to "sdi_rx_p(n)"
#set_location_assignment PIN_F38 -to sdi_rx_p
#set_location_assignment PIN_E37 -to "sdi_tx_p(n)"
#set_location_assignment PIN_E36 -to sdi_tx_p
#
#set_location_assignment PIN_R3 -to "sma_tx_p(n)"
#set_location_assignment PIN_R4 -to sma_tx_p
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to sma_tx_p


##Ref Clock##
#set_location_assignment PIN_AD34 -to "refclk1_ql0_p(n)"
#set_location_assignment PIN_AD33 -to refclk1_ql0_p
#set_location_assignment PIN_V35 -to "refclk4_ql2_p(n)"
#set_location_assignment PIN_V34 -to refclk4_ql2_p
#set_location_assignment PIN_T34 -to "refclk5_ql2_p(n)"
#set_location_assignment PIN_T33 -to refclk5_ql2_p
#set_location_assignment PIN_AF5 -to "refclk0_qr0_p(n)"
#set_location_assignment PIN_AF6 -to refclk0_qr0_p
#set_location_assignment PIN_AD6 -to "refclk1_qr0_p(n)"
#set_location_assignment PIN_AD7 -to refclk1_qr0_p
#set_location_assignment PIN_AB5 -to "refclk2_qr1_p(n)"
#set_location_assignment PIN_AB6 -to refclk2_qr1_p
#set_location_assignment PIN_V5 -to "refclk4_qr2_p(n)"
#set_location_assignment PIN_V6 -to refclk4_qr2_p
#set_location_assignment PIN_T6 -to "refclk5_qr2_p(n)"
#set_location_assignment PIN_T7 -to refclk5_qr2_p
#set_location_assignment PIN_AB34 -to "refclk2_ql1_p(n)"
#set_location_assignment PIN_AB35 -to refclk2_ql1_p


##set_instance_assignment -name IO_STANDARD LVDS -to pcie_refclk_n
#set_instance_assignment -name IO_STANDARD LVDS -to pcie_refclk_p
##set_instance_assignment -name IO_STANDARD LVDS -to refclk1_ql0_n
#set_instance_assignment -name IO_STANDARD LVDS -to refclk1_ql0_p
##set_instance_assignment -name IO_STANDARD LVDS -to refclk4_ql2_n
#set_instance_assignment -name IO_STANDARD LVDS -to refclk4_ql2_p
##set_instance_assignment -name IO_STANDARD LVDS -to refclk5_ql2_n
#set_instance_assignment -name IO_STANDARD LVDS -to refclk5_ql2_p
##set_instance_assignment -name IO_STANDARD LVDS -to refclk0_qr0_n
#set_instance_assignment -name IO_STANDARD LVDS -to refclk0_qr0_p
##set_instance_assignment -name IO_STANDARD LVDS -to refclk1_qr0_n
#set_instance_assignment -name IO_STANDARD LVDS -to refclk1_qr0_p
##set_instance_assignment -name IO_STANDARD LVDS -to refclk2_qr1_n
#set_instance_assignment -name IO_STANDARD LVDS -to refclk2_qr1_p
##set_instance_assignment -name IO_STANDARD LVDS -to refclk4_qr2_n
#set_instance_assignment -name IO_STANDARD LVDS -to refclk4_qr2_p
##set_instance_assignment -name IO_STANDARD LVDS -to refclk5_qr2_n
#set_instance_assignment -name IO_STANDARD LVDS -to refclk5_qr2_p

set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to refclk1_ql0_p
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to refclk4_ql2_p
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to refclk5_ql2_p
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to refclk0_qr0_p
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to refclk1_qr0_p
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to refclk2_qr1_p
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to refclk4_qr2_p
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to refclk5_qr2_p
##########################################################

########## HSMC Port A Signals ################
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsma_tx_p
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsma_rx_p

#set_location_assignment PIN_AV1 -to "hsma_rx_p[0](n)"
#set_location_assignment PIN_AV2 -to hsma_rx_p[0]
#set_location_assignment PIN_AP1 -to "hsma_rx_p[1](n)"
#set_location_assignment PIN_AP2 -to hsma_rx_p[1]
#set_location_assignment PIN_AM1 -to "hsma_rx_p[2](n)"
#set_location_assignment PIN_AM2 -to hsma_rx_p[2]
#set_location_assignment PIN_AK1 -to "hsma_rx_p[3](n)"
#set_location_assignment PIN_AK2 -to hsma_rx_p[3]
#set_location_assignment PIN_AH1 -to "hsma_rx_p[4](n)"
#set_location_assignment PIN_AH2 -to hsma_rx_p[4]
#set_location_assignment PIN_AF1 -to "hsma_rx_p[5](n)"
#set_location_assignment PIN_AF2 -to hsma_rx_p[5]
#set_location_assignment PIN_AD1 -to "hsma_rx_p[6](n)"
#set_location_assignment PIN_AD2 -to hsma_rx_p[6]
#set_location_assignment PIN_AB1 -to "hsma_rx_p[7](n)"
#set_location_assignment PIN_AB2 -to hsma_rx_p[7]
#set_location_assignment PIN_AU3 -to "hsma_tx_p[0](n)"
#set_location_assignment PIN_AU4 -to hsma_tx_p[0]
#set_location_assignment PIN_AN3 -to "hsma_tx_p[1](n)"
#set_location_assignment PIN_AN4 -to hsma_tx_p[1]
#set_location_assignment PIN_AL3 -to "hsma_tx_p[2](n)"
#set_location_assignment PIN_AL4 -to hsma_tx_p[2]
#set_location_assignment PIN_AJ3 -to "hsma_tx_p[3](n)"
#set_location_assignment PIN_AJ4 -to hsma_tx_p[3]
#set_location_assignment PIN_AG3 -to "hsma_tx_p[4](n)"
#set_location_assignment PIN_AG4 -to hsma_tx_p[4]
#set_location_assignment PIN_AE3 -to "hsma_tx_p[5](n)"
#set_location_assignment PIN_AE4 -to hsma_tx_p[5]
#set_location_assignment PIN_AC3 -to "hsma_tx_p[6](n)"
#set_location_assignment PIN_AC4 -to hsma_tx_p[6]
#set_location_assignment PIN_AA3 -to "hsma_tx_p[7](n)"
#set_location_assignment PIN_AA4 -to hsma_tx_p[7]

set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to hsma_rx_d_p
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[16]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[15]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[14]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[13]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[12]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[11]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[10]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[9]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[8]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[7]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[6]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[5]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[4]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[3]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[2]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[1]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_rx_d_p[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hsma_rx_led
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[16]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[15]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[14]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[13]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[12]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[11]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[10]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[9]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[8]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[7]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[6]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[5]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[4]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[3]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[2]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[1]
set_instance_assignment -name IO_STANDARD LVDS -to hsma_tx_d_p[0]
#set_location_assignment PIN_AG28 -to hsma_clk_in0
#set_location_assignment PIN_AJ10 -to hsma_clk_out0
#set_location_assignment PIN_AJ29 -to hsma_d[0]
#set_location_assignment PIN_AK29 -to hsma_d[1]
#set_location_assignment PIN_AR28 -to hsma_d[2]
#set_location_assignment PIN_AP28 -to hsma_d[3]
#set_location_assignment PIN_AW8 -to hsma_prsntn
#set_location_assignment PIN_AE12 -to "hsma_rx_d_p[0](n)"
#set_location_assignment PIN_AJ12 -to "hsma_rx_d_p[1](n)"
#set_location_assignment PIN_C9 -to "hsma_rx_d_p[10](n)"
#set_location_assignment PIN_L8 -to "hsma_rx_d_p[11](n)"
#set_location_assignment PIN_L9 -to "hsma_rx_d_p[12](n)"
#set_location_assignment PIN_R9 -to "hsma_rx_d_p[13](n)"
#set_location_assignment PIN_G11 -to "hsma_rx_d_p[14](n)"
#set_location_assignment PIN_E11 -to "hsma_rx_d_p[15](n)"
#set_location_assignment PIN_A10 -to "hsma_rx_d_p[16](n)"
#set_location_assignment PIN_AK12 -to "hsma_rx_d_p[2](n)"
#set_location_assignment PIN_AR12 -to "hsma_rx_d_p[3](n)"
#set_location_assignment PIN_AU12 -to "hsma_rx_d_p[4](n)"
#set_location_assignment PIN_AW11 -to "hsma_rx_d_p[5](n)"
#set_location_assignment PIN_AC10 -to "hsma_rx_d_p[6](n)"
#set_location_assignment PIN_AG10 -to "hsma_rx_d_p[7](n)"
#set_location_assignment PIN_E8 -to "hsma_rx_d_p[8](n)"
#set_location_assignment PIN_F9 -to "hsma_rx_d_p[9](n)"
#set_location_assignment PIN_AD12 -to hsma_rx_d_p[0]
#set_location_assignment PIN_AH12 -to hsma_rx_d_p[1]
#set_location_assignment PIN_C8 -to hsma_rx_d_p[10]
#set_location_assignment PIN_M8 -to hsma_rx_d_p[11]
#set_location_assignment PIN_M9 -to hsma_rx_d_p[12]
#set_location_assignment PIN_T9 -to hsma_rx_d_p[13]
#set_location_assignment PIN_H11 -to hsma_rx_d_p[14]
#set_location_assignment PIN_F11 -to hsma_rx_d_p[15]
#set_location_assignment PIN_B10 -to hsma_rx_d_p[16]
#set_location_assignment PIN_AL12 -to hsma_rx_d_p[2]
#set_location_assignment PIN_AR11 -to hsma_rx_d_p[3]
#set_location_assignment PIN_AT12 -to hsma_rx_d_p[4]
#set_location_assignment PIN_AV11 -to hsma_rx_d_p[5]
#set_location_assignment PIN_AB10 -to hsma_rx_d_p[6]
#set_location_assignment PIN_AF10 -to hsma_rx_d_p[7]
#set_location_assignment PIN_F8 -to hsma_rx_d_p[8]
#set_location_assignment PIN_G10 -to hsma_rx_d_p[9]
#set_location_assignment PIN_AV8 -to hsma_rx_led
#set_location_assignment PIN_AM29 -to hsma_scl
#set_location_assignment PIN_AL29 -to hsma_sda
#set_location_assignment PIN_J9 -to "hsma_tx_d_p[10](n)"
#set_location_assignment PIN_N9 -to "hsma_tx_d_p[11](n)"
#set_location_assignment PIN_P8 -to "hsma_tx_d_p[12](n)"
#set_location_assignment PIN_H10 -to "hsma_tx_d_p[13](n)"
#set_location_assignment PIN_C10 -to "hsma_tx_d_p[14](n)"
#set_location_assignment PIN_A11 -to "hsma_tx_d_p[15](n)"
#set_location_assignment PIN_N10 -to "hsma_tx_d_p[16](n)"
#set_location_assignment PIN_AF11 -to "hsma_tx_d_p[2](n)"
#set_location_assignment PIN_AL11 -to "hsma_tx_d_p[3](n)"
#set_location_assignment PIN_AN11 -to "hsma_tx_d_p[4](n)"
#set_location_assignment PIN_AU11 -to "hsma_tx_d_p[5](n)"
#set_location_assignment PIN_AC9 -to "hsma_tx_d_p[6](n)"
#set_location_assignment PIN_AE9 -to "hsma_tx_d_p[7](n)"
#set_location_assignment PIN_B8 -to "hsma_tx_d_p[8](n)"
#set_location_assignment PIN_D9 -to "hsma_tx_d_p[9](n)"
#set_location_assignment PIN_AB12 -to hsma_tx_d_p[0]
#set_location_assignment PIN_AE10 -to hsma_tx_d_p[1]
#set_location_assignment PIN_K9 -to hsma_tx_d_p[10]
#set_location_assignment PIN_N8 -to hsma_tx_d_p[11]
#set_location_assignment PIN_R8 -to hsma_tx_d_p[12]
#set_location_assignment PIN_J10 -to hsma_tx_d_p[13]
#set_location_assignment PIN_D10 -to hsma_tx_d_p[14]
#set_location_assignment PIN_B11 -to hsma_tx_d_p[15]
#set_location_assignment PIN_P10 -to hsma_tx_d_p[16]
#set_location_assignment PIN_AG12 -to hsma_tx_d_p[2]
#set_location_assignment PIN_AK11 -to hsma_tx_d_p[3]
#set_location_assignment PIN_AM11 -to hsma_tx_d_p[4]
#set_location_assignment PIN_AT11 -to hsma_tx_d_p[5]
#set_location_assignment PIN_AB9 -to hsma_tx_d_p[6]
#set_location_assignment PIN_AD9 -to hsma_tx_d_p[7]
#set_location_assignment PIN_A8 -to hsma_tx_d_p[8]
#set_location_assignment PIN_E9 -to hsma_tx_d_p[9]
#set_location_assignment PIN_AU8 -to hsma_tx_led

set_instance_assignment -name IO_STANDARD LVDS -to hsma_clk_in_p1
set_instance_assignment -name IO_STANDARD LVDS -to hsma_clk_in_p2
set_instance_assignment -name IO_STANDARD LVDS -to hsma_clk_out_p1
set_instance_assignment -name IO_STANDARD LVDS -to hsma_clk_out_p2
set_instance_assignment -name IO_STANDARD "2.5 V" -to hsma_clk_in0
set_instance_assignment -name IO_STANDARD "2.5 V" -to hsma_clk_out0
set_instance_assignment -name IO_STANDARD "2.5 V" -to hsma_d[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to hsma_d[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to hsma_d[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to hsma_d[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to hsma_prsntn
set_instance_assignment -name IO_STANDARD "2.5 V" -to hsma_scl
set_instance_assignment -name IO_STANDARD "2.5 V" -to hsma_sda
set_instance_assignment -name IO_STANDARD "1.8 V" -to hsma_tx_led
#set_location_assignment PIN_AT8 -to hsma_clk_in_n1
#set_location_assignment PIN_G6 -to hsma_clk_in_n2
#set_location_assignment PIN_AR8 -to hsma_clk_in_p1
#set_location_assignment PIN_G7 -to hsma_clk_in_p2
#set_location_assignment PIN_AH9 -to hsma_clk_out_n1
#set_location_assignment PIN_G8 -to hsma_clk_out_n2
#set_location_assignment PIN_AG9 -to hsma_clk_out_p1
#set_location_assignment PIN_G9 -to hsma_clk_out_p2

##########################################################

########## HSMC Port B Signals ################
#set_location_assignment PIN_F1 -to "hsmb_rx_p[0](n)"
#set_location_assignment PIN_F2 -to hsmb_rx_p[0]
#set_location_assignment PIN_D1 -to "hsmb_rx_p[1](n)"
#set_location_assignment PIN_D2 -to hsmb_rx_p[1]
#set_location_assignment PIN_Y1 -to "hsmb_rx_p[2](n)"
#set_location_assignment PIN_Y2 -to hsmb_rx_p[2]
#set_location_assignment PIN_V1 -to "hsmb_rx_p[3](n)"
#set_location_assignment PIN_V2 -to hsmb_rx_p[3]
#
#set_location_assignment PIN_E3 -to "hsmb_tx_p[0](n)"
#set_location_assignment PIN_E4 -to hsmb_tx_p[0]
#set_location_assignment PIN_C3 -to "hsmb_tx_p[1](n)"
#set_location_assignment PIN_C4 -to hsmb_tx_p[1]
#set_location_assignment PIN_W3 -to "hsmb_tx_p[2](n)"
#set_location_assignment PIN_W4 -to hsmb_tx_p[2]
#set_location_assignment PIN_U3 -to "hsmb_tx_p[3](n)"
#set_location_assignment PIN_U4 -to hsmb_tx_p[3]

set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmb_rx_p
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to hsmb_tx_p

#set_location_assignment PIN_H17 -to hsmb_a[0]
#set_location_assignment PIN_G17 -to hsmb_a[1]
#set_location_assignment PIN_D19 -to hsmb_a[10]
#set_location_assignment PIN_C19 -to hsmb_a[11]
#set_location_assignment PIN_E18 -to hsmb_a[12]
#set_location_assignment PIN_E19 -to hsmb_a[13]
#set_location_assignment PIN_G18 -to hsmb_a[14]
#set_location_assignment PIN_F18 -to hsmb_a[15]
#set_location_assignment PIN_T15 -to hsmb_a[2]
#set_location_assignment PIN_R15 -to hsmb_a[3]
#set_location_assignment PIN_N15 -to hsmb_a[4]
#set_location_assignment PIN_M15 -to hsmb_a[5]
#set_location_assignment PIN_B19 -to hsmb_a[6]
#set_location_assignment PIN_A19 -to hsmb_a[7]
#set_location_assignment PIN_D18 -to hsmb_a[8]
#set_location_assignment PIN_C18 -to hsmb_a[9]
#set_location_assignment PIN_H19 -to hsmb_addr_cmd[0]
#set_location_assignment PIN_G19 -to hsmb_addr_cmd[1]
#set_location_assignment PIN_F17 -to hsmb_ba[0]
#set_location_assignment PIN_E17 -to hsmb_ba[1]
#set_location_assignment PIN_H16 -to hsmb_ba[2]
#set_location_assignment PIN_G16 -to hsmb_ba[3]
#set_location_assignment PIN_G14 -to hsmb_casn
#set_location_assignment PIN_H13 -to hsmb_cke
#set_location_assignment PIN_AF29 -to hsmb_clk_in0
#set_location_assignment PIN_L16 -to hsmb_clk_out0
#set_location_assignment PIN_P13 -to hsmb_csn
#
#set_location_assignment PIN_M12 -to hsmb_dm[0]
#set_location_assignment PIN_B13 -to hsmb_dm[1]
#set_location_assignment PIN_U13 -to hsmb_dm[2]
#set_location_assignment PIN_C14 -to hsmb_dm[3]
#set_location_assignment PIN_J12 -to hsmb_dq[0]
#set_location_assignment PIN_N13 -to hsmb_dq[1]
#set_location_assignment PIN_A13 -to hsmb_dq[10]
#set_location_assignment PIN_D12 -to hsmb_dq[11]
#set_location_assignment PIN_C12 -to hsmb_dq[12]
#set_location_assignment PIN_F12 -to hsmb_dq[13]
#set_location_assignment PIN_G12 -to hsmb_dq[14]
#set_location_assignment PIN_G13 -to hsmb_dq[15]
#set_location_assignment PIN_U12 -to hsmb_dq[16]
#set_location_assignment PIN_T13 -to hsmb_dq[17]
#set_location_assignment PIN_U14 -to hsmb_dq[18]
#set_location_assignment PIN_N14 -to hsmb_dq[19]
#set_location_assignment PIN_N12 -to hsmb_dq[2]
#set_location_assignment PIN_M14 -to hsmb_dq[20]
#set_location_assignment PIN_J14 -to hsmb_dq[21]
#set_location_assignment PIN_J15 -to hsmb_dq[22]
#set_location_assignment PIN_L15 -to hsmb_dq[23]
#set_location_assignment PIN_C15 -to hsmb_dq[24]
#set_location_assignment PIN_B14 -to hsmb_dq[25]
#set_location_assignment PIN_A14 -to hsmb_dq[26]
#set_location_assignment PIN_F14 -to hsmb_dq[27]
#set_location_assignment PIN_E14 -to hsmb_dq[28]
#set_location_assignment PIN_G15 -to hsmb_dq[29]
#set_location_assignment PIN_T12 -to hsmb_dq[3]
#set_location_assignment PIN_F15 -to hsmb_dq[30]
#set_location_assignment PIN_H14 -to hsmb_dq[31]
#set_location_assignment PIN_R12 -to hsmb_dq[4]
#set_location_assignment PIN_U11 -to hsmb_dq[5]
#set_location_assignment PIN_L12 -to hsmb_dq[6]
#set_location_assignment PIN_K12 -to hsmb_dq[7]
#set_location_assignment PIN_E12 -to hsmb_dq[8]
#set_location_assignment PIN_J13 -to hsmb_dq[9]
#set_location_assignment PIN_L13 -to hsmb_dqs_p[0]
#set_location_assignment PIN_D13 -to hsmb_dqs_p[1]
#set_location_assignment PIN_R14 -to hsmb_dqs_p[2]
#set_location_assignment PIN_E15 -to hsmb_dqs_p[3]
#set_location_assignment PIN_K13 -to hsmb_dqs_n[0]
#set_location_assignment PIN_C13 -to hsmb_dqs_n[1]
#set_location_assignment PIN_P14 -to hsmb_dqs_n[2]
#set_location_assignment PIN_D15 -to hsmb_dqs_n[3]
#
#set_location_assignment PIN_K15 -to hsmb_odt
#set_location_assignment PIN_AU7 -to hsmb_prsntn
#set_location_assignment PIN_B17 -to hsmb_rasn
#set_location_assignment PIN_AR6 -to hsmb_rx_led
#set_location_assignment PIN_AL30 -to hsmb_scl
#set_location_assignment PIN_AK30 -to hsmb_sda
#set_location_assignment PIN_AP6 -to hsmb_tx_led
#set_location_assignment PIN_A17 -to hsmb_wen
#set_location_assignment PIN_N16 -to hsmb_clk_in_n2
#set_location_assignment PIN_T16 -to hsmb_clk_in_n1
#set_location_assignment PIN_P16 -to hsmb_clk_in_p2
#set_location_assignment PIN_U15 -to hsmb_clk_in_p1
#set_location_assignment PIN_C16 -to hsmb_clk_out_n1
#set_location_assignment PIN_A16 -to hsmb_clk_out_n2
#set_location_assignment PIN_D16 -to hsmb_clk_out_p1
#set_location_assignment PIN_B16 -to hsmb_clk_out_p2

set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_clk_out_n1
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_clk_out_n2
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[15]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[14]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[13]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[12]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[11]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[10]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[9]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[8]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[7]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[6]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[5]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[4]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[3]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[2]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[1]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_a[0]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_addr_cmd[1]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_addr_cmd[0]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_ba[3]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_ba[2]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_ba[1]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_ba[0]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_casn
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_cke
set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmb_clk_in0
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_clk_in_p1
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_clk_in_p2
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_clk_out0
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_clk_out_p1
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_clk_out_p2
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_csn
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dm[3]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dm[2]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dm[1]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dm[0]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[31]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[30]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[29]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[28]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[27]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[26]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[25]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[24]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[23]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[22]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[21]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[20]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[19]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[18]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[17]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[16]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[15]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[14]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[13]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[12]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[11]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[10]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[9]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[8]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[7]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[6]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[5]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[4]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[3]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[2]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[1]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dq[0]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dqs_p[3]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dqs_p[2]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dqs_p[1]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dqs_p[0]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dqs_n[3]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dqs_n[2]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dqs_n[1]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_dqs_n[0]
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_odt
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_qvld
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_rasn
set_instance_assignment -name IO_STANDARD "1.5-V HSTL CLASS I" -to hsmb_wen
set_instance_assignment -name IO_STANDARD LVDS -to hsmb_c_p


set_instance_assignment -name IO_STANDARD "1.8 V" -to hsmb_prsntn
set_instance_assignment -name IO_STANDARD "1.8 V" -to hsmb_rx_led
set_instance_assignment -name IO_STANDARD "1.8 V" -to hsmb_tx_led
set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmb_scl
set_instance_assignment -name IO_STANDARD "2.5 V" -to hsmb_sda

set_instance_assignment -name IO_STANDARD "1.5 V" -to rzqin_hsmb_var
set_location_assignment PIN_J6 -to rzqin_hsmb_var
##########################################################

########## PCIe Signals ################
#set_location_assignment PIN_AF35 -to "pcie_refclk_p(n)"
#set_location_assignment PIN_AF34 -to pcie_refclk_p
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_refclk_p

#set_location_assignment PIN_AV39 -to "pcie_rx_p[0](n)"
#set_location_assignment PIN_AV38 -to pcie_rx_p[0]
#set_location_assignment PIN_AT39 -to "pcie_rx_p[1](n)"
#set_location_assignment PIN_AT38 -to pcie_rx_p[1]
#set_location_assignment PIN_AP39 -to "pcie_rx_p[2](n)"
#set_location_assignment PIN_AP38 -to pcie_rx_p[2]
#set_location_assignment PIN_AM39 -to "pcie_rx_p[3](n)"
#set_location_assignment PIN_AM38 -to pcie_rx_p[3]
#set_location_assignment PIN_AH39 -to "pcie_rx_p[4](n)"
#set_location_assignment PIN_AH38 -to pcie_rx_p[4]
#set_location_assignment PIN_AF39 -to "pcie_rx_p[5](n)"
#set_location_assignment PIN_AF38 -to pcie_rx_p[5]
#set_location_assignment PIN_AD39 -to "pcie_rx_p[6](n)"
#set_location_assignment PIN_AD38 -to pcie_rx_p[6]
#set_location_assignment PIN_AB39 -to "pcie_rx_p[7](n)"
#set_location_assignment PIN_AB38 -to pcie_rx_p[7]
#
#set_location_assignment PIN_AU37 -to "pcie_tx_p[0](n)"
#set_location_assignment PIN_AU36 -to pcie_tx_p[0]
#set_location_assignment PIN_AR37 -to "pcie_tx_p[1](n)"
#set_location_assignment PIN_AR36 -to pcie_tx_p[1]
#set_location_assignment PIN_AN37 -to "pcie_tx_p[2](n)"
#set_location_assignment PIN_AN36 -to pcie_tx_p[2]
#set_location_assignment PIN_AL37 -to "pcie_tx_p[3](n)"
#set_location_assignment PIN_AL36 -to pcie_tx_p[3]
#set_location_assignment PIN_AG37 -to "pcie_tx_p[4](n)"
#set_location_assignment PIN_AG36 -to pcie_tx_p[4]
#set_location_assignment PIN_AE37 -to "pcie_tx_p[5](n)"
#set_location_assignment PIN_AE36 -to pcie_tx_p[5]
#set_location_assignment PIN_AC37 -to "pcie_tx_p[6](n)"
#set_location_assignment PIN_AC36 -to pcie_tx_p[6]
#set_location_assignment PIN_AA37 -to "pcie_tx_p[7](n)"
#set_location_assignment PIN_AA36 -to pcie_tx_p[7]

set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_rx_p
set_instance_assignment -name IO_STANDARD "1.4-V PCML" -to pcie_tx_p

#set_location_assignment PIN_AL28 -to pcie_led_g2
#set_location_assignment PIN_AN34 -to pcie_led_g3
#set_location_assignment PIN_AL27 -to pcie_led_x1
#set_location_assignment PIN_AN28 -to pcie_led_x4
#set_location_assignment PIN_AM28 -to pcie_led_x8
#set_location_assignment PIN_AR34 -to pcie_perstn
#set_location_assignment PIN_AP34 -to pcie_smbclk
#set_location_assignment PIN_AL34 -to pcie_smbdat
#set_location_assignment PIN_AN32 -to pcie_waken
set_instance_assignment -name IO_STANDARD "2.5 V" -to pcie_led_g2
set_instance_assignment -name IO_STANDARD "2.5 V" -to pcie_led_g3
set_instance_assignment -name IO_STANDARD "2.5 V" -to pcie_led_x1
set_instance_assignment -name IO_STANDARD "2.5 V" -to pcie_led_x4
set_instance_assignment -name IO_STANDARD "2.5 V" -to pcie_led_x8
set_instance_assignment -name IO_STANDARD "2.5 V" -to pcie_perstn
set_instance_assignment -name IO_STANDARD "2.5 V" -to pcie_smbclk
set_instance_assignment -name IO_STANDARD "2.5 V" -to pcie_smbdat
set_instance_assignment -name IO_STANDARD "2.5 V" -to pcie_waken

###########################################################

#set_location_assignment PIN_AV28 -to usb_clk
set_instance_assignment -name IO_STANDARD "2.5 V" -to usb_clk
set_global_assignment -name SEARCH_PATH custom_phy_x1/ -tag from_archive
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to enet_rx_p
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to clk_125_p
