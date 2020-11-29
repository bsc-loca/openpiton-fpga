# Copyright (c) 2016 Princeton University
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Princeton University nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# some constraints from the example design
#set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 8 [current_design]
#set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN div-1 [current_design]
#set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
#set_property BITSTREAM.CONFIG.SPI_OPCODE 8'h6B [current_design]
#set_property CONFIG_MODE SPIx8 [current_design]
#set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
#set_property BITSTREAM.CONFIG.UNUSEDPIN Pulldown [current_design]
#set_property CONFIG_VOLTAGE 1.8 [current_design]

# Clock signals 
set_property -dict {PACKAGE_PIN F31 IOSTANDARD LVDS}        [get_ports "chipset_clk_osc_n"] ;# SYS_CLK3_N 100MHz
set_property -dict {PACKAGE_PIN G31 IOSTANDARD LVDS}        [get_ports "chipset_clk_osc_p"] ;# SYS_CLK3_P

# ref clock for MIG
set_property PACKAGE_PIN BJ43 [ get_ports "mc_clk_p" ]
set_property IOSTANDARD LVDS  [ get_ports "mc_clk_p" ]
set_property PACKAGE_PIN BJ44 [ get_ports "mc_clk_n" ]
set_property IOSTANDARD LVDS  [ get_ports "mc_clk_n" ]

set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets chipset/clk_mmcm/inst/clk_in1_clk_mmcm]

# Reset, note that this is active high on this board!! MAKE LOW for ALVEO!
set_property -dict {PACKAGE_PIN BH26  IOSTANDARD LVCMOS12} [get_ports "sys_rst_n"] ;# CPU_RESET_FPGA

# False paths
set_false_path -to [get_cells -hierarchical *afifo_ui_rst_r*]
set_false_path -to [get_cells -hierarchical *ui_clk_sync_rst_r*]
set_false_path -to [get_cells -hierarchical *ui_clk_syn_rst_delayed*]
set_false_path -to [get_cells -hierarchical *init_calib_complete_f*]
set_false_path -to [get_cells -hierarchical *chipset_rst_n*]
# net not instantiated yet
#set_false_path -from [get_clocks chipset_clk_clk_mmcm] -to [get_clocks net_axi_clk_clk_mmcm]
#set_false_path -from [get_clocks net_axi_clk_clk_mmcm] -to [get_clocks chipset_clk_clk_mmcm]

# JTAG is connected to internal JTAG chain via the bscane2 primitive
###### Male PMOD1 Header J53
#set_property -dict {PACKAGE_PIN N28 IOSTANDARD LVCMOS12} [get_ports tck_i]   ;# Bank  47 VCCO - VCC1V2_FPGA - IO_L5P_T0U_N8_AD14P_47
#set_property -dict {PACKAGE_PIN M30 IOSTANDARD LVCMOS12} [get_ports td_i]    ;# Bank  47 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_47
#set_property -dict {PACKAGE_PIN N30 IOSTANDARD LVCMOS12} [get_ports td_o]    ;# Bank  47 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_47
#set_property -dict {PACKAGE_PIN P30 IOSTANDARD LVCMOS12} [get_ports tms_i]   ;# Bank  47 VCCO - VCC1V2_FPGA - IO_L3N_T0L_N5_AD15N_47
#set_property -dict {PACKAGE_PIN P29 IOSTANDARD LVCMOS12} [get_ports trst_ni] ;# Bank  47 VCCO - VCC1V2_FPGA - IO_L3P_T0L_N4_AD15P_47
# unused
#set_property -dict {PACKAGE_PIN L31 IOSTANDARD LVCMOS12} [get_ports ]    ;# Bank  47 VCCO - VCC1V2_FPGA - IO_L2N_T0L_N3_47
#set_property -dict {PACKAGE_PIN M31 IOSTANDARD LVCMOS12} [get_ports ]    ;# Bank  47 VCCO - VCC1V2_FPGA - IO_L2P_T0L_N2_47
#set_property -dict {PACKAGE_PIN R29 IOSTANDARD LVCMOS12} [get_ports ]    ;# Bank  47 VCCO - VCC1V2_FPGA - IO_L1N_T0L_N1_DBC_47

## To use FTDI FT2232 JTAG
## Add some additional constraints for JTAG signals, set to 10MHz to be on the safe side
#create_clock -period 100.000 -name tck_i -waveform {0.000 50.000} [get_ports tck_i]

#set_input_delay  -clock tck_i -clock_fall 5 [get_ports td_i    ]
#set_input_delay  -clock tck_i -clock_fall 5 [get_ports tms_i   ]
#set_output_delay -clock tck_i             5 [get_ports td_o    ]
#set_false_path   -from                      [get_ports trst_ni ]

## constrain clock domain crossing
#set_max_delay -datapath_only -from [get_clocks -include_generated_clocks chipset_clk_clk_mmcm] -to [get_clocks tck_i] 8.0
#set_max_delay -datapath_only -from [get_clocks tck_i] -to [get_clocks -include_generated_clocks chipset_clk_clk_mmcm] 8.0

## accept sub-optimal placement
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets tck_i_IBUF_inst/O]

## SD on female PMOD0 header (Digilent PMOD SD adapter)
#set_property -dict {PACKAGE_PIN AY14 IOSTANDARD LVCMOS18} [get_ports "sd_dat[3]"]  ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L10N_T1U_N7_QBC_AD4N_67
#set_property -dict {PACKAGE_PIN AY15 IOSTANDARD LVCMOS18} [get_ports "sd_cmd"]     ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L10P_T1U_N6_QBC_AD4P_67
#set_property -dict {PACKAGE_PIN AW15 IOSTANDARD LVCMOS18} [get_ports "sd_dat[0]"]  ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L9N_T1L_N5_AD12N_67
#set_property -dict {PACKAGE_PIN AV15 IOSTANDARD LVCMOS18} [get_ports "sd_clk_out"] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L9P_T1L_N4_AD12P_67
#set_property -dict {PACKAGE_PIN AV16 IOSTANDARD LVCMOS18} [get_ports "sd_dat[1]"]  ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L8N_T1L_N3_AD5N_67
#set_property -dict {PACKAGE_PIN AU16 IOSTANDARD LVCMOS18} [get_ports "sd_dat[2]"]  ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L8P_T1L_N2_AD5P_67
#set_property -dict {PACKAGE_PIN AT15 IOSTANDARD LVCMOS18} [get_ports "sd_cd"]      ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L7N_T1L_N1_QBC_AD13N_67
# no reset on this board. this is the write-protect signal.
#set_property -dict {PACKAGE_PIN AT16 IOSTANDARD LVCMOS18} [get_ports "sd_reset"]   ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L7P_T1L_N0_QBC_AD13P_67

#### UART
#IO_L11N_T1_SRCC_35 Sch=uart_rxd_out
set_property -dict {PACKAGE_PIN B33 IOSTANDARD LVCMOS18} [get_ports "uart_rx"] ;# Bank  64 VCCO - VCC1V8_FPGA - IO_L9P_T1L_N4_AD12P_64
set_property -dict {PACKAGE_PIN A28 IOSTANDARD LVCMOS18} [get_ports "uart_tx"] ;# Bank  64 VCCO - VCC1V8_FPGA - IO_L8N_T1L_N3_AD5N_64
# unused
#set_property -dict {PACKAGE_PIN AY25 IOSTANDARD LVCMOS18} [get_ports "uart_cts"] ;# Bank  64 VCCO - VCC1V8_FPGA - IO_L9N_T1L_N5_AD12N_64
#set_property -dict {PACKAGE_PIN BB22 IOSTANDARD LVCMOS18} [get_ports "uart_rts"] ;# Bank  64 VCCO - VCC1V8_FPGA - IO_L8P_T1L_N2_AD5P_64


## Switches.
#set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS12} [get_ports "sw[0]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L19N_T3L_N1_DBC_AD9N_73
#set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS12} [get_ports "sw[1]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_T2U_N12_73
#set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS12} [get_ports "sw[2]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L7N_T1L_N1_QBC_AD13N_73
#set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS12} [get_ports "sw[3]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_T3U_N12_72

### LEDs
#set_property -dict {PACKAGE_PIN AT32 IOSTANDARD LVCMOS12} [get_ports "leds[0]"] ;# Bank  40 VCCO - VCC1V2_FPGA - IO_L19N_T3L_N1_DBC_AD9N_40
#set_property -dict {PACKAGE_PIN AV34 IOSTANDARD LVCMOS12} [get_ports "leds[1]"] ;# Bank  40 VCCO - VCC1V2_FPGA - IO_T2U_N12_40
#set_property -dict {PACKAGE_PIN AY30 IOSTANDARD LVCMOS12} [get_ports "leds[2]"] ;# Bank  40 VCCO - VCC1V2_FPGA - IO_L7N_T1L_N1_QBC_AD13N_40
#set_property -dict {PACKAGE_PIN BB32 IOSTANDARD LVCMOS12} [get_ports "leds[3]"] ;# Bank  40 VCCO - VCC1V2_FPGA - IO_T1U_N12_40
#set_property -dict {PACKAGE_PIN BF32 IOSTANDARD LVCMOS12} [get_ports "leds[4]"] ;# Bank  40 VCCO - VCC1V2_FPGA - IO_L1N_T0L_N1_DBC_40
#set_property -dict {PACKAGE_PIN AU37 IOSTANDARD LVCMOS12} [get_ports "leds[5]"] ;# Bank  42 VCCO - VCC1V2_FPGA - IO_T3U_N12_42
#set_property -dict {PACKAGE_PIN AV36 IOSTANDARD LVCMOS12} [get_ports "leds[6]"] ;# Bank  42 VCCO - VCC1V2_FPGA - IO_L19N_T3L_N1_DBC_AD9N_42
#set_property -dict {PACKAGE_PIN BA37 IOSTANDARD LVCMOS12} [get_ports "leds[7]"] ;# Bank  42 VCCO - VCC1V2_FPGA - IO_L13N_T2L_N1_GC_QBC_42

### Buttons
#set_property -dict {PACKAGE_PIN BB24 IOSTANDARD LVCMOS18} [get_ports "btnu"] ;# Bank  64 VCCO - VCC1V8_FPGA - IO_L5P_T0U_N8_AD14P_64
#set_property -dict {PACKAGE_PIN BF22 IOSTANDARD LVCMOS18} [get_ports "btnl"] ;# Bank  64 VCCO - VCC1V8_FPGA - IO_L4N_T0U_N7_DBC_AD7N_64
#set_property -dict {PACKAGE_PIN BE22 IOSTANDARD LVCMOS18} [get_ports "btnd"] ;# Bank  64 VCCO - VCC1V8_FPGA - IO_L4P_T0U_N6_DBC_AD7P_64
#set_property -dict {PACKAGE_PIN BE23 IOSTANDARD LVCMOS18} [get_ports "btnr"] ;# Bank  64 VCCO - VCC1V8_FPGA - IO_L3N_T0L_N5_AD15N_64
#set_property -dict {PACKAGE_PIN BD23 IOSTANDARD LVCMOS18} [get_ports "btnc"] ;# Bank  64 VCCO - VCC1V8_FPGA - IO_L3P_T0L_N4_AD15P_64


## Ethernet

## not wired up yet...
## NOTUSED? set_property PACKAGE_PIN AK16 [get_ports net_ip2intc_irpt]
## NOTUSED? set_property IOSTANDARD LVCMOS18 [get_ports net_ip2intc_irpt]
## NOTUSED? set_property PULLUP true [get_ports net_ip2intc_irpt]
#set_property PACKAGE_PIN AF12 [get_ports net_phy_mdc]
#set_property IOSTANDARD LVCMOS15 [get_ports net_phy_mdc]
#set_property PACKAGE_PIN AG12 [get_ports net_phy_mdio_io]
#set_property IOSTANDARD LVCMOS15 [get_ports net_phy_mdio_io]
#set_property PACKAGE_PIN AH24 [get_ports net_phy_rst_n]
#set_property IOSTANDARD LVCMOS33 [get_ports net_phy_rst_n]
##set_property -dict { PACKAGE_PIN AK15  IOSTANDARD LVCMOS18 } [get_ports { ETH_PMEB }]; #IO_L1N_T0_32 Sch=eth_pmeb
#set_property PACKAGE_PIN AG10 [get_ports net_phy_rxc]
#set_property IOSTANDARD LVCMOS15 [get_ports net_phy_rxc]
#set_property PACKAGE_PIN AH11 [get_ports net_phy_rxctl]
#set_property IOSTANDARD LVCMOS15 [get_ports net_phy_rxctl]
#set_property PACKAGE_PIN AJ14 [get_ports {net_phy_rxd[0]}]
#set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_rxd[0]}]
#set_property PACKAGE_PIN AH14 [get_ports {net_phy_rxd[1]}]
#set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_rxd[1]}]
#set_property PACKAGE_PIN AK13 [get_ports {net_phy_rxd[2]}]
#set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_rxd[2]}]
#set_property PACKAGE_PIN AJ13 [get_ports {net_phy_rxd[3]}]
#set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_rxd[3]}]
#set_property PACKAGE_PIN AE10 [get_ports net_phy_txc]
#set_property IOSTANDARD LVCMOS15 [get_ports net_phy_txc]
#set_property PACKAGE_PIN AJ12 [get_ports {net_phy_txd[0]}]
#set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_txd[0]}]
#set_property PACKAGE_PIN AK11 [get_ports {net_phy_txd[1]}]
#set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_txd[1]}]
#set_property PACKAGE_PIN AJ11 [get_ports {net_phy_txd[2]}]
#set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_txd[2]}]
#set_property PACKAGE_PIN AK10 [get_ports {net_phy_txd[3]}]
#set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_txd[3]}]
#set_property PACKAGE_PIN AK14 [get_ports net_phy_txctl]
#set_property IOSTANDARD LVCMOS15 [get_ports net_phy_txctl]


## DDR4

# we only use 64 bit out of the 80bit available
set_property PACKAGE_PIN BF45      [get_ports "ddr_parity"]         ;# Bank  65 VCCO - VCC1V2 Net "DDR4_C0_PAR"     - IO_L20P_T3L_N2_AD1P_D08_65
set_property PACKAGE_PIN BG33      [get_ports "ddr_reset_n"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L1N_T0L_N1_DBC_72
set_property PACKAGE_PIN BJ46      [get_ports "ddr_ck_c"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L16N_T2U_N7_QBC_AD3N_71
set_property PACKAGE_PIN BH46      [get_ports "ddr_ck_t"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_71
set_property PACKAGE_PIN BF41      [get_ports "ddr_bg[0]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L15P_T2L_N4_AD11P_71
set_property PACKAGE_PIN BE41      [get_ports "ddr_bg[1]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L15P_T2L_N4_AD11P_71
set_property PACKAGE_PIN BH41      [get_ports "ddr_act_n"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L14N_T2L_N3_GC_71
set_property PACKAGE_PIN BK46      [get_ports "ddr_cs_n"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L14P_T2L_N2_GC_71
set_property PACKAGE_PIN BG44      [get_ports "ddr_odt"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L7N_T1L_N1_QBC_AD13N_71
set_property PACKAGE_PIN BH42      [get_ports "ddr_cke"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_T1U_N12_71

set_property PACKAGE_PIN BH45      [get_ports "ddr_ba[0]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L17P_T2U_N8_AD10P_71
set_property PACKAGE_PIN BM47      [get_ports "ddr_ba[1]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L15N_T2L_N5_AD11N_71

set_property PACKAGE_PIN BF46      [get_ports "ddr_addr[0]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_T3U_N12_71
set_property PACKAGE_PIN BG43      [get_ports "ddr_addr[1]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L24N_T3U_N11_71
set_property PACKAGE_PIN BK45      [get_ports "ddr_addr[2]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L24P_T3U_N10_71
set_property PACKAGE_PIN BF42      [get_ports "ddr_addr[3]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L23N_T3U_N9_71
set_property PACKAGE_PIN BL45      [get_ports "ddr_addr[4]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L23P_T3U_N8_71
set_property PACKAGE_PIN BF43      [get_ports "ddr_addr[5]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L22N_T3U_N7_DBC_AD0N_71
set_property PACKAGE_PIN BG42      [get_ports "ddr_addr[6]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L22P_T3U_N6_DBC_AD0P_71
set_property PACKAGE_PIN BL43      [get_ports "ddr_addr[7]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L21N_T3L_N5_AD8N_71
set_property PACKAGE_PIN BK43      [get_ports "ddr_addr[8]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L21P_T3L_N4_AD8P_71
set_property PACKAGE_PIN BM42      [get_ports "ddr_addr[9]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L20N_T3L_N3_AD1N_71
set_property PACKAGE_PIN BG45      [get_ports "ddr_addr[10]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L20P_T3L_N2_AD1P_71
set_property PACKAGE_PIN BD41      [get_ports "ddr_addr[11]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L19N_T3L_N1_DBC_AD9N_71
set_property PACKAGE_PIN BL42      [get_ports "ddr_addr[12]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L19P_T3L_N0_DBC_AD9P_71
set_property PACKAGE_PIN BE44      [get_ports "ddr_addr[13]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_T2U_N12_71
set_property PACKAGE_PIN BE43      [get_ports "ddr_addr[14]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L18N_T2U_N11_AD2N_71
set_property PACKAGE_PIN BL46      [get_ports "ddr_addr[15]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L18P_T2U_N10_AD2P_71
set_property PACKAGE_PIN BH44      [get_ports "ddr_addr[16]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L17N_T2U_N9_AD10N_71

set_property PACKAGE_PIN BJ53      [get_ports "ddr_dqs_c[17]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L16N_T2U_N7_QBC_AD3N_72
set_property PACKAGE_PIN BJ54      [get_ports "ddr_dqs_c[16]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_72
set_property PACKAGE_PIN BP42      [get_ports "ddr_dqs_c[15]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_72
set_property PACKAGE_PIN BP46      [get_ports "ddr_dqs_c[14]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L22N_T3U_N7_DBC_AD0N_73
set_property PACKAGE_PIN BK49      [get_ports "ddr_dqs_c[13]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L16N_T2U_N7_QBC_AD3N_73
set_property PACKAGE_PIN BJ47      [get_ports "ddr_dqs_c[12]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_73
set_property PACKAGE_PIN BG49      [get_ports "ddr_dqs_c[11]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_73
set_property PACKAGE_PIN BF48      [get_ports "ddr_dqs_c[10]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_71
set_property PACKAGE_PIN BP49      [get_ports "ddr_dqs_c[9]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_71
set_property PACKAGE_PIN BM50      [get_ports "ddr_dqs_c[8]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L22N_T3U_N7_DBC_AD0N_72
set_property PACKAGE_PIN BJ32      [get_ports "ddr_dqs_c[7]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L16N_T2U_N7_QBC_AD3N_72
set_property PACKAGE_PIN BK35      [get_ports "ddr_dqs_c[6]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_72
set_property PACKAGE_PIN BN35      [get_ports "ddr_dqs_c[5]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_72
set_property PACKAGE_PIN BM35      [get_ports "ddr_dqs_c[4]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L22N_T3U_N7_DBC_AD0N_73
set_property PACKAGE_PIN BG30      [get_ports "ddr_dqs_c[3]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L16N_T2U_N7_QBC_AD3N_73
set_property PACKAGE_PIN BK30      [get_ports "ddr_dqs_c[2]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L10N_T1U_N7_QBC_AD4N_73
set_property PACKAGE_PIN BM29      [get_ports "ddr_dqs_c[1]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_73
set_property PACKAGE_PIN BN30      [get_ports "ddr_dqs_c[0]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L4N_T0U_N7_DBC_AD7N_71

set_property PACKAGE_PIN BJ52      [get_ports "ddr_dqs_t[17]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_72
set_property PACKAGE_PIN BH54      [get_ports "ddr_dqs_t[16]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_72
set_property PACKAGE_PIN BN42      [get_ports "ddr_dqs_t[15]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_72
set_property PACKAGE_PIN BN46      [get_ports "ddr_dqs_t[14]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_72
set_property PACKAGE_PIN BK48      [get_ports "ddr_dqs_t[13]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_72
set_property PACKAGE_PIN BH47      [get_ports "ddr_dqs_t[12]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L22P_T3U_N6_DBC_AD0P_73
set_property PACKAGE_PIN BG48      [get_ports "ddr_dqs_t[11]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_73
set_property PACKAGE_PIN BF47      [get_ports "ddr_dqs_t[10]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_73
set_property PACKAGE_PIN BP48      [get_ports "ddr_dqs_t[9]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_73
set_property PACKAGE_PIN BM49      [get_ports "ddr_dqs_t[8]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_71
set_property PACKAGE_PIN BH32      [get_ports "ddr_dqs_t[7]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_72
set_property PACKAGE_PIN BK34      [get_ports "ddr_dqs_t[6]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_72
set_property PACKAGE_PIN BM34      [get_ports "ddr_dqs_t[5]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_72
set_property PACKAGE_PIN BL35      [get_ports "ddr_dqs_t[4]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L22P_T3U_N6_DBC_AD0P_73
set_property PACKAGE_PIN BG29      [get_ports "ddr_dqs_t[3]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L16P_T2U_N6_QBC_AD3P_73
set_property PACKAGE_PIN BJ29      [get_ports "ddr_dqs_t[2]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L10P_T1U_N6_QBC_AD4P_73
set_property PACKAGE_PIN BM28      [get_ports "ddr_dqs_t[1]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_73
set_property PACKAGE_PIN BN29      [get_ports "ddr_dqs_t[0]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_71

set_property PACKAGE_PIN BK53      [get_ports "ddr_dq[71]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L24N_T3U_N11_72
set_property PACKAGE_PIN BK54      [get_ports "ddr_dq[70]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L24P_T3U_N10_72
set_property PACKAGE_PIN BG52      [get_ports "ddr_dq[69]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L23N_T3U_N9_72
set_property PACKAGE_PIN BH52      [get_ports "ddr_dq[68]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L23P_T3U_N8_72
set_property PACKAGE_PIN BE54      [get_ports "ddr_dq[67]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L21N_T3L_N5_AD8N_72
set_property PACKAGE_PIN BE53      [get_ports "ddr_dq[66]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L21P_T3L_N4_AD8P_72
set_property PACKAGE_PIN BG53      [get_ports "ddr_dq[65]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L20N_T3L_N3_AD1N_72
set_property PACKAGE_PIN BG54      [get_ports "ddr_dq[64]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L20P_T3L_N2_AD1P_72
set_property PACKAGE_PIN BP47      [get_ports "ddr_dq[63]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L18N_T2U_N11_AD2N_72
set_property PACKAGE_PIN BN47      [get_ports "ddr_dq[62]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L18P_T2U_N10_AD2P_72
set_property PACKAGE_PIN BP44      [get_ports "ddr_dq[61]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L17N_T2U_N9_AD10N_72
set_property PACKAGE_PIN BP43      [get_ports "ddr_dq[60]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L17P_T2U_N8_AD10P_72
set_property PACKAGE_PIN BM45      [get_ports "ddr_dq[59]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L15N_T2L_N5_AD11N_72
set_property PACKAGE_PIN BM44      [get_ports "ddr_dq[58]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L15P_T2L_N4_AD11P_72
set_property PACKAGE_PIN BN45      [get_ports "ddr_dq[57]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L14N_T2L_N3_GC_72
set_property PACKAGE_PIN BN44      [get_ports "ddr_dq[56]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L14P_T2L_N2_GC_72
set_property PACKAGE_PIN BJ48      [get_ports "ddr_dq[55]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L12N_T1U_N11_GC_72
set_property PACKAGE_PIN BJ49      [get_ports "ddr_dq[54]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L12P_T1U_N10_GC_72
set_property PACKAGE_PIN BK51      [get_ports "ddr_dq[53]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L11N_T1U_N9_GC_72
set_property PACKAGE_PIN BK50      [get_ports "ddr_dq[52]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L11P_T1U_N8_GC_72
set_property PACKAGE_PIN BH49      [get_ports "ddr_dq[51]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L9N_T1L_N5_AD12N_72
set_property PACKAGE_PIN BH51      [get_ports "ddr_dq[50]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L9P_T1L_N4_AD12P_72
set_property PACKAGE_PIN BJ51      [get_ports "ddr_dq[49]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L8N_T1L_N3_AD5N_72
set_property PACKAGE_PIN BH50      [get_ports "ddr_dq[48]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L8P_T1L_N2_AD5P_72
set_property PACKAGE_PIN BF50      [get_ports "ddr_dq[47]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_72
set_property PACKAGE_PIN BG50      [get_ports "ddr_dq[46]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_72
set_property PACKAGE_PIN BF51      [get_ports "ddr_dq[45]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L5N_T0U_N9_AD14N_72
set_property PACKAGE_PIN BF52      [get_ports "ddr_dq[44]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L5P_T0U_N8_AD14P_72
set_property PACKAGE_PIN BD51      [get_ports "ddr_dq[43]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L3N_T0L_N5_AD15N_72
set_property PACKAGE_PIN BE51      [get_ports "ddr_dq[42]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L3P_T0L_N4_AD15P_72
set_property PACKAGE_PIN BE49      [get_ports "ddr_dq[41]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L2N_T0L_N3_72
set_property PACKAGE_PIN BE50      [get_ports "ddr_dq[40]"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_L2P_T0L_N2_72
set_property PACKAGE_PIN BM48      [get_ports "ddr_dq[39]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L24N_T3U_N11_73
set_property PACKAGE_PIN BN49      [get_ports "ddr_dq[38]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L24P_T3U_N10_73
set_property PACKAGE_PIN BN51      [get_ports "ddr_dq[37]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L23N_T3U_N9_73
set_property PACKAGE_PIN BN50      [get_ports "ddr_dq[36]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L23P_T3U_N8_73
set_property PACKAGE_PIN BL51      [get_ports "ddr_dq[35]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L21N_T3L_N5_AD8N_73
set_property PACKAGE_PIN BL52      [get_ports "ddr_dq[34]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L21P_T3L_N4_AD8P_73
set_property PACKAGE_PIN BL53      [get_ports "ddr_dq[33]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L20N_T3L_N3_AD1N_73
set_property PACKAGE_PIN BM52      [get_ports "ddr_dq[32]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L20P_T3L_N2_AD1P_73
set_property PACKAGE_PIN BG35      [get_ports "ddr_dq[31]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L18N_T2U_N11_AD2N_73
set_property PACKAGE_PIN BG34      [get_ports "ddr_dq[30]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L18P_T2U_N10_AD2P_73
set_property PACKAGE_PIN BJ34      [get_ports "ddr_dq[29]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L17N_T2U_N9_AD10N_73
set_property PACKAGE_PIN BJ33      [get_ports "ddr_dq[28]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L17P_T2U_N8_AD10P_73
set_property PACKAGE_PIN BF36      [get_ports "ddr_dq[27]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L15N_T2L_N5_AD11N_73
set_property PACKAGE_PIN BF35      [get_ports "ddr_dq[26]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L15P_T2L_N4_AD11P_73
set_property PACKAGE_PIN BH35      [get_ports "ddr_dq[25]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L14N_T2L_N3_GC_73
set_property PACKAGE_PIN BH34      [get_ports "ddr_dq[24]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L14P_T2L_N2_GC_73
set_property PACKAGE_PIN BP34      [get_ports "ddr_dq[23]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L12N_T1U_N11_GC_73
set_property PACKAGE_PIN BN34      [get_ports "ddr_dq[22]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L12P_T1U_N10_GC_73
set_property PACKAGE_PIN BM33      [get_ports "ddr_dq[21]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L11N_T1U_N9_GC_73
set_property PACKAGE_PIN BL32      [get_ports "ddr_dq[20]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L11P_T1U_N8_GC_73
set_property PACKAGE_PIN BL33      [get_ports "ddr_dq[19]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L9N_T1L_N5_AD12N_73
set_property PACKAGE_PIN BK33      [get_ports "ddr_dq[18]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L9P_T1L_N4_AD12P_73
set_property PACKAGE_PIN BL31      [get_ports "ddr_dq[17]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L8N_T1L_N3_AD5N_73
set_property PACKAGE_PIN BK31      [get_ports "ddr_dq[16]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L8P_T1L_N2_AD5P_73
set_property PACKAGE_PIN BG32      [get_ports "ddr_dq[15]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_73
set_property PACKAGE_PIN BF31      [get_ports "ddr_dq[14]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_73
set_property PACKAGE_PIN BH30      [get_ports "ddr_dq[13]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L5N_T0U_N9_AD14N_73
set_property PACKAGE_PIN BH29      [get_ports "ddr_dq[12]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L5P_T0U_N8_AD14P_73
set_property PACKAGE_PIN BF33      [get_ports "ddr_dq[11]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L3N_T0L_N5_AD15N_73
set_property PACKAGE_PIN BF32      [get_ports "ddr_dq[10]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L3P_T0L_N4_AD15P_73
set_property PACKAGE_PIN BH31      [get_ports "ddr_dq[9]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L2N_T0L_N3_73
set_property PACKAGE_PIN BJ31      [get_ports "ddr_dq[8]"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L2P_T0L_N2_73
set_property PACKAGE_PIN BN31      [get_ports "ddr_dq[7]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_71
set_property PACKAGE_PIN BP31      [get_ports "ddr_dq[6]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_71
set_property PACKAGE_PIN BP28      [get_ports "ddr_dq[5]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L5N_T0U_N9_AD14N_71
set_property PACKAGE_PIN BP29      [get_ports "ddr_dq[4]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L5P_T0U_N8_AD14P_71
set_property PACKAGE_PIN BM30      [get_ports "ddr_dq[3]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L3N_T0L_N5_AD15N_71
set_property PACKAGE_PIN BL30      [get_ports "ddr_dq[2]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L3P_T0L_N4_AD15P_71
set_property PACKAGE_PIN BP32      [get_ports "ddr_dq[1]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L2N_T0L_N3_71
set_property PACKAGE_PIN BN32      [get_ports "ddr_dq[0]"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L2P_T0L_N2_71

# unused
#set_property PACKAGE_PIN R17      [get_ports "ddr_addr[LERT_B"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_L1N_T0L_N1_DBC_73
#set_property PACKAGE_PIN G10      [get_ports "DDR4_C1_PAR"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_L1N_T0L_N1_DBC_71
#set_property PACKAGE_PIN A20      [get_ports "DDR4_C1_TEN"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_T3U_N12_73

## False paths
#set_clock_groups -name sync_gr1 -logically_exclusive -group [get_clocks chipset_clk_clk_mmcm] -group [get_clocks -include_generated_clocks mc_sys_clk_clk_mmcm]

## Ethernet Constraints for 100 Mb/s

########## Input constraints
## hint from here: https://forums.xilinx.com/t5/Timing-Analysis/XDC-constraints-Source-Synchronous-ADC-DDR/td-p/292807
#create_clock -period 40.000 -name net_phy_rxc_virt
## conservatively assuming +/- 2ns skew of rxd/rxctl
#create_clock -period 40.000 -name net_phy_rxc -waveform {2.000 22.000} [get_ports net_phy_rxc]
#set_clock_groups -asynchronous -group [get_clocks chipset_clk_clk_mmcm] -group [get_clocks net_phy_rxc]
#set_input_delay -clock [get_clocks net_phy_rxc_virt] -min -add_delay 0.000 [get_ports {net_phy_rxd[*]}]
#set_input_delay -clock [get_clocks net_phy_rxc_virt] -max -add_delay 4.000 [get_ports {net_phy_rxd[*]}]
#set_input_delay -clock [get_clocks net_phy_rxc_virt] -clock_fall -min -add_delay 0.000 [get_ports net_phy_rxctl]
#set_input_delay -clock [get_clocks net_phy_rxc_virt] -clock_fall -max -add_delay 4.000 [get_ports net_phy_rxctl]
#set_input_delay -clock [get_clocks net_phy_rxc_virt] -min -add_delay 0.000 [get_ports net_phy_rxctl]
#set_input_delay -clock [get_clocks net_phy_rxc_virt] -max -add_delay 4.000 [get_ports net_phy_rxctl]
#
########### Output Constraints
#create_generated_clock -name net_phy_txc -source [get_pins chipset/net_phy_txc_oddr/C] -divide_by 1 -invert [get_ports net_phy_txc]


#############################################
# SD Card Constraints for 25MHz
#############################################
#create_generated_clock -name sd_fast_clk -source [get_pins chipset/clk_mmcm/sd_sys_clk] -divide_by 2 [get_pins chipset/chipset_impl/piton_sd_top/sdc_controller/clock_divider0/fast_clk_reg/Q]
#create_generated_clock -name sd_slow_clk -source [get_pins chipset/clk_mmcm/sd_sys_clk] -divide_by 200 [get_pins chipset/chipset_impl/piton_sd_top/sdc_controller/clock_divider0/slow_clk_reg/Q]
#create_generated_clock -name sd_clk_out   -source [get_pins chipset/sd_clk_oddr/C] -divide_by 1 -add -master_clock sd_fast_clk [get_ports sd_clk_out]
#create_generated_clock -name sd_clk_out_1 -source [get_pins chipset/sd_clk_oddr/C] -divide_by 1 -add -master_clock sd_slow_clk [get_ports sd_clk_out]

## compensate for board trace and level shifter uncertainty
#set_clock_uncertainty 2.0 [get_clocks sd_clk_out]
#set_clock_uncertainty 2.0 [get_clocks sd_clk_out_1]

##################
## FPGA out / card in
## data is aligned with clock (source synchronous)

## hold fast (spec requires minimum 2ns), note that data is launched on falling edge, so 0.0 is ok here
#set_output_delay -clock [get_clocks sd_clk_out]   -min -add_delay 0.000 [get_ports {sd_dat[*]}]
#set_output_delay -clock [get_clocks sd_clk_out]   -min -add_delay 0.000 [get_ports sd_cmd]

## setup fast (spec requires minimum 6ns)
#set_output_delay -clock [get_clocks sd_clk_out]   -max -add_delay 8.000 [get_ports {sd_dat[*]}]
#set_output_delay -clock [get_clocks sd_clk_out]   -max -add_delay 8.000 [get_ports sd_cmd]

## hold slow (spec requires minimum 5ns), note that data is launched on falling edge, so 0.0 is ok here
#set_output_delay -clock [get_clocks sd_clk_out_1] -min -add_delay 0.000 [get_ports {sd_dat[*]}]
#set_output_delay -clock [get_clocks sd_clk_out_1] -min -add_delay 0.000 [get_ports sd_cmd]

## setup slow (spec requires minimum 5ns)
#set_output_delay -clock [get_clocks sd_clk_out_1] -max -add_delay 8.000 [get_ports {sd_dat[*]}]
#set_output_delay -clock [get_clocks sd_clk_out_1] -max -add_delay 8.000 [get_ports sd_cmd]

##################
## card out / FPGA in
## assume ~15cm/ns propagation time
## 14ns pd from card + 2 x 1ns trace + 2 x 2ns level shifter
## data is launched on negative clock edge here

## propdelay fast
#set_input_delay -clock [get_clocks sd_clk_out]   -max -add_delay 20.000 [get_ports {sd_dat[*]}] -clock_fall
#set_input_delay -clock [get_clocks sd_clk_out]   -max -add_delay 20.000 [get_ports sd_cmd]      -clock_fall

## contamination delay fast
#set_input_delay -clock [get_clocks sd_clk_out]   -min -add_delay -1.000 [get_ports {sd_dat[*]}] -clock_fall
#set_input_delay -clock [get_clocks sd_clk_out]   -min -add_delay -1.000 [get_ports sd_cmd]      -clock_fall

## propdelay slow
#set_input_delay -clock [get_clocks sd_clk_out_1] -max -add_delay 20.000 [get_ports {sd_dat[*]}] -clock_fall
#set_input_delay -clock [get_clocks sd_clk_out_1] -max -add_delay 20.000 [get_ports sd_cmd]      -clock_fall

## contamination  slow
#set_input_delay -clock [get_clocks sd_clk_out_1] -min -add_delay -1.000 [get_ports {sd_dat[*]}] -clock_fall
#set_input_delay -clock [get_clocks sd_clk_out_1] -min -add_delay -1.000 [get_ports sd_cmd]      -clock_fall

#################
# clock groups

#set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks sd_clk_out] -group [get_clocks -include_generated_clocks sd_clk_out_1]
#set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clocks {sd_fast_clk}] -group [get_clocks -include_generated_clocks {sd_slow_clk}]
#set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks chipset_clk_clk_mmcm] -group [get_clocks -filter { NAME =~  "*sd*" }]

set_false_path -from [get_pins {chipset/vio_sw_i/inst/PROBE_OUT_ALL_INST/G_PROBE_OUT[0].PROBE_OUT0_INST/Probe_out_reg[0]/C}] -to [get_pins {chipset/chipset_impl/mc_top/noc_mig_bridge/cl_addr_reg_reg[1]/D}]

# Bitstream Configuration                                                 
# ------------------------------------------------------------------------
set_property CONFIG_VOLTAGE 1.8 [current_design]                          
set_property BITSTREAM.CONFIG.CONFIGFALLBACK Enable [current_design]      
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]             
set_property CONFIG_MODE SPIx4 [current_design]                           
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]             
set_property BITSTREAM.CONFIG.CONFIGRATE 85.0 [current_design]            
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN disable [current_design]   
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]          
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]           
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR Yes [current_design]         
# ------------------------------------------------------------------------
set_property PACKAGE_PIN D32              [get_ports HBM_CATTRIP]   		
set_property IOSTANDARD  LVCMOS18         [get_ports HBM_CATTRIP]   