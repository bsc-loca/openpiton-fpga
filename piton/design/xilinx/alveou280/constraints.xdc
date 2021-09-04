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
set_property -dict {PACKAGE_PIN F31 IOSTANDARD LVDS} [get_ports chipset_clk_osc_n]
set_property -dict {PACKAGE_PIN G31 IOSTANDARD LVDS} [get_ports chipset_clk_osc_p]


# ref clock for MIG

set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets chipset/clk_mmcm/inst/clkin1_ibufds/O]

# Reset, note that this is active high on this board!! MAKE LOW for ALVEO!
#set_property -dict {PACKAGE_PIN BH26  IOSTANDARD LVCMOS12} [get_ports "sys_rst_n"] ;# CPU_RESET_FPGA

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
set_property -dict {PACKAGE_PIN B33 IOSTANDARD LVCMOS18} [get_ports uart_tx]
set_property -dict {PACKAGE_PIN A28 IOSTANDARD LVCMOS18} [get_ports uart_rx]
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


## ================ Ethernet ================
## Commented pin locations are applied automatically due to configurations inside Ethernet CMAC core (made in BD)
#--------------------------------------------
## Input Clocks and Controls for QSFP28 Port 0
#
## MGT_SI570_CLOCK0   -> MGT Ref Clock 0 156.25MHz Default (Not User re-programmable)
# set_property PACKAGE_PIN T43      [get_ports "MGT_SI570_CLOCK0_N"]  ;# Bank 134 - MGTREFCLK0N_134, platform: io_clk_gtyquad_refclk0_00_clk_n
# set_property PACKAGE_PIN T42      [get_ports "MGT_SI570_CLOCK0_P"]  ;# Bank 134 - MGTREFCLK0P_134, platform: io_clk_gtyquad_refclk0_00_clk_p
#
## QSFP0_CLOCK        -> MGT Ref Clock 1 User selectable by QSFP0_FS=0 161.132812 MHz and QSFP0_FS=1 156.250MHz; QSFP0_OEB must driven low to enable clock output
# set_property PACKAGE_PIN R41      [get_ports "QSFP0_CLOCK_N"]  ;# Bank 134 - MGTREFCLK1N_134, platform: io_clk_gtyquad_refclk1_00_clk_n
# set_property PACKAGE_PIN R40      [get_ports "QSFP0_CLOCK_P"]  ;# Bank 134 - MGTREFCLK1P_134, platform: io_clk_gtyquad_refclk1_00_clk_p
#
## QSFP0_CLOCK control signals
set_property PACKAGE_PIN G32       [get_ports "qsfp_fs" ]  ;# Bank  75 VCCO - VCC1V8 Net "QSFP0_FS"   - IO_L9N_T1L_N5_AD12N_75, platform: QSFP0_FS[0:0]
set_property IOSTANDARD  LVCMOS18  [get_ports "qsfp_fs" ]  ;# Bank  75 VCCO - VCC1V8 Net "QSFP0_FS"   - IO_L9N_T1L_N5_AD12N_75
set_property PACKAGE_PIN H32       [get_ports "qsfp_oeb"]  ;# Bank  75 VCCO - VCC1V8 Net "QSFP0_OEB"  - IO_L9P_T1L_N4_AD12P_75, platform: QSFP0_OEB[0:0]
set_property IOSTANDARD  LVCMOS18  [get_ports "qsfp_oeb"]  ;# Bank  75 VCCO - VCC1V8 Net "QSFP0_OEB"  - IO_L9P_T1L_N4_AD12P_75
#
## QSFP0 MGTY Interface
# set_property PACKAGE_PIN L54       [get_ports "QSFP0_RX1_N"]  ;# Bank 134 - MGTYRXN0_134, platform: io_gt_gtyquad_00[_grx_n[0]]
# set_property PACKAGE_PIN K52       [get_ports "QSFP0_RX2_N"]  ;# Bank 134 - MGTYRXN1_134, platform: io_gt_gtyquad_00[_grx_n[1]]
# set_property PACKAGE_PIN J54       [get_ports "QSFP0_RX3_N"]  ;# Bank 134 - MGTYRXN2_134, platform: io_gt_gtyquad_00[_grx_n[2]]
# set_property PACKAGE_PIN H52       [get_ports "QSFP0_RX4_N"]  ;# Bank 134 - MGTYRXN3_134, platform: io_gt_gtyquad_00[_grx_n[4]]
# set_property PACKAGE_PIN L53       [get_ports "QSFP0_RX1_P"]  ;# Bank 134 - MGTYRXP0_134, platform: io_gt_gtyquad_00[_grx_p[0]]
# set_property PACKAGE_PIN K51       [get_ports "QSFP0_RX2_P"]  ;# Bank 134 - MGTYRXP1_134, platform: io_gt_gtyquad_00[_grx_p[1]]
# set_property PACKAGE_PIN J53       [get_ports "QSFP0_RX3_P"]  ;# Bank 134 - MGTYRXP2_134, platform: io_gt_gtyquad_00[_grx_p[2]]
# set_property PACKAGE_PIN H51       [get_ports "QSFP0_RX4_P"]  ;# Bank 134 - MGTYRXP3_134, platform: io_gt_gtyquad_00[_grx_p[4]]
# set_property PACKAGE_PIN L49       [get_ports "QSFP0_TX1_N"]  ;# Bank 134 - MGTYTXN0_134, platform: io_gt_gtyquad_00[_gtx_n[0]]
# set_property PACKAGE_PIN L45       [get_ports "QSFP0_TX2_N"]  ;# Bank 134 - MGTYTXN1_134, platform: io_gt_gtyquad_00[_gtx_n[1]]
# set_property PACKAGE_PIN K47       [get_ports "QSFP0_TX3_N"]  ;# Bank 134 - MGTYTXN2_134, platform: io_gt_gtyquad_00[_gtx_n[2]]
# set_property PACKAGE_PIN J49       [get_ports "QSFP0_TX4_N"]  ;# Bank 134 - MGTYTXN3_134, platform: io_gt_gtyquad_00[_gtx_n[3]]
# set_property PACKAGE_PIN L48       [get_ports "QSFP0_TX1_P"]  ;# Bank 134 - MGTYTXP0_134, platform: io_gt_gtyquad_00[_gtx_p[0]]
# set_property PACKAGE_PIN L44       [get_ports "QSFP0_TX2_P"]  ;# Bank 134 - MGTYTXP1_134, platform: io_gt_gtyquad_00[_gtx_p[1]]
# set_property PACKAGE_PIN K46       [get_ports "QSFP0_TX3_P"]  ;# Bank 134 - MGTYTXP2_134, platform: io_gt_gtyquad_00[_gtx_p[2]]
# set_property PACKAGE_PIN J48       [get_ports "QSFP0_TX4_P"]  ;# Bank 134 - MGTYTXP3_134, platform: io_gt_gtyquad_00[_gtx_p[3]]
#
#--------------------------------------------
# Input Clocks and Controls for QSFP28 Port 1
#
## MGT_SI570_CLOCK1_N   -> MGT Ref Clock 0 156.25MHz Default (Not User re-programmable)
# set_property PACKAGE_PIN P43       [get_ports "MGT_SI570_CLOCK1_N"] ;# Bank 135 - MGTREFCLK0N_135, platform: io_clk_gtyquad_refclk0_01_clk_n
# set_property PACKAGE_PIN P42       [get_ports "MGT_SI570_CLOCK1_P"] ;# Bank 135 - MGTREFCLK0P_135, platform: io_clk_gtyquad_refclk0_01_clk_p
#
## QSFP1_CLOCK_N        -> MGT Ref Clock 1 User selectable by QSFP1_FS=0 161.132812 MHz and QSFP1_FS=1 156.250MHz; QSFP1_OEB must be low to enable clock output
# set_property PACKAGE_PIN M43       [get_ports "QSFP1_CLOCK_N"]  ;# Bank 135 - MGTREFCLK1N_135, platform: io_clk_gtyquad_refclk1_01_clk_n
# set_property PACKAGE_PIN M42       [get_ports "QSFP1_CLOCK_P"]  ;# Bank 135 - MGTREFCLK1P_135, platform: io_clk_gtyquad_refclk1_01_clk_p
#
## QSFP1_CLOCK control signals
# set_property PACKAGE_PIN H30       [get_ports "qsfp_oeb"]  ;# Bank  75 VCCO - VCC1V8 Net "QSFP1_OEB"  - IO_L8N_T1L_N3_AD5N_75     , platform: QSFP1_OEB[0:0]
# set_property IOSTANDARD  LVCMOS18  [get_ports "qsfp_oeb"]  ;# Bank  75 VCCO - VCC1V8 Net "QSFP1_OEB"  - IO_L8N_T1L_N3_AD5N_75
# set_property PACKAGE_PIN G33       [get_ports "qsfp_fs" ]  ;# Bank  75 VCCO - VCC1V8 Net "QSFP1_FS"   - IO_L7N_T1L_N1_QBC_AD13N_75, platform: QSFP1_FS[0:0]
# set_property IOSTANDARD  LVCMOS18  [get_ports "qsfp_fs" ]  ;# Bank  75 VCCO - VCC1V8 Net "QSFP1_FS"   - IO_L7N_T1L_N1_QBC_AD13N_75
#
## QSFP1 MGTY Interface
# set_property PACKAGE_PIN G54       [get_ports "QSFP1_RX1_N"]  ;# Bank 135 - MGTYRXN0_135, platform: io_gt_gtyquad_01[_grx_n[0]]
# set_property PACKAGE_PIN F52       [get_ports "QSFP1_RX2_N"]  ;# Bank 135 - MGTYRXN1_135, platform: io_gt_gtyquad_01[_grx_n[1]]
# set_property PACKAGE_PIN E54       [get_ports "QSFP1_RX3_N"]  ;# Bank 135 - MGTYRXN2_135, platform: io_gt_gtyquad_01[_grx_n[2]]
# set_property PACKAGE_PIN D52       [get_ports "QSFP1_RX4_N"]  ;# Bank 135 - MGTYRXN3_135, platform: io_gt_gtyquad_01[_grx_n[4]]
# set_property PACKAGE_PIN G53       [get_ports "QSFP1_RX1_P"]  ;# Bank 135 - MGTYRXP0_135, platform: io_gt_gtyquad_01[_grx_p[0]]
# set_property PACKAGE_PIN F51       [get_ports "QSFP1_RX2_P"]  ;# Bank 135 - MGTYRXP1_135, platform: io_gt_gtyquad_01[_grx_p[1]]
# set_property PACKAGE_PIN E53       [get_ports "QSFP1_RX3_P"]  ;# Bank 135 - MGTYRXP2_135, platform: io_gt_gtyquad_01[_grx_p[2]]
# set_property PACKAGE_PIN D51       [get_ports "QSFP1_RX4_P"]  ;# Bank 135 - MGTYRXP3_135, platform: io_gt_gtyquad_01[_grx_p[4]]
# set_property PACKAGE_PIN G49       [get_ports "QSFP1_TX1_N"]  ;# Bank 135 - MGTYTXN0_135, platform: io_gt_gtyquad_01[_gtx_n[0]]
# set_property PACKAGE_PIN E49       [get_ports "QSFP1_TX2_N"]  ;# Bank 135 - MGTYTXN1_135, platform: io_gt_gtyquad_01[_gtx_n[1]]
# set_property PACKAGE_PIN C49       [get_ports "QSFP1_TX3_N"]  ;# Bank 135 - MGTYTXN2_135, platform: io_gt_gtyquad_01[_gtx_n[2]]
# set_property PACKAGE_PIN A50       [get_ports "QSFP1_TX4_N"]  ;# Bank 135 - MGTYTXN3_135, platform: io_gt_gtyquad_01[_gtx_n[3]]
# set_property PACKAGE_PIN G48       [get_ports "QSFP1_TX1_P"]  ;# Bank 135 - MGTYTXP0_135, platform: io_gt_gtyquad_01[_gtx_p[0]]
# set_property PACKAGE_PIN E48       [get_ports "QSFP1_TX2_P"]  ;# Bank 135 - MGTYTXP1_135, platform: io_gt_gtyquad_01[_gtx_p[1]]
# set_property PACKAGE_PIN C48       [get_ports "QSFP1_TX3_P"]  ;# Bank 135 - MGTYTXP2_135, platform: io_gt_gtyquad_01[_gtx_p[2]]
# set_property PACKAGE_PIN A49       [get_ports "QSFP1_TX4_P"]  ;# Bank 135 - MGTYTXP3_135, platform: io_gt_gtyquad_01[_gtx_p[3]]
#
#--------------------------------------------
# Specifying the placement of QSFP clock domain modules into single SLR to facilitate routing
# https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_1/ug912-vivado-properties.pdf#page=386
set tx_clk_units [get_cells -of_objects [get_nets -of_objects [get_pins -hierarchical eth100gb/gt_txusrclk2]]]
set rx_clk_units [get_cells -of_objects [get_nets -of_objects [get_pins -hierarchical eth100gb/gt_rxusrclk2]]]
#As clocks are not applied to memories explicitly in BD, include them separately to SLR placement.
set eth_txmem [get_cells -hierarchical eth_tx_mem]
set eth_rxmem [get_cells -hierarchical eth_rx_mem]
#Setting specific SLR to which QSFP are wired since placer may miss it if just "group_name" is applied
set_property USER_SLR_ASSIGNMENT SLR2 [get_cells "$tx_clk_units $rx_clk_units $eth_txmem $eth_rxmem"]
#
#--------------------------------------------
# Timing constraints for clock domains crossings (CDC), which didn't apply automatically (e.g. for GPIO)
set sys_clk [get_clocks -of_objects [get_pins -hierarchical eth_cmac_syst/s_axi_clk]]
set tx_clk  [get_clocks -of_objects [get_pins -hierarchical eth100gb/gt_txusrclk2  ]]
set rx_clk  [get_clocks -of_objects [get_pins -hierarchical eth100gb/gt_rxusrclk2  ]]
# set_false_path -from $xxx_clk -to $yyy_clk
# controlling resync paths to be less than source clock period
# (-datapath_only to exclude clock paths)
set_max_delay -datapath_only -from $sys_clk -to $tx_clk  [expr [get_property -min period $sys_clk] * 0.9]
set_max_delay -datapath_only -from $sys_clk -to $rx_clk  [expr [get_property -min period $sys_clk] * 0.9]
set_max_delay -datapath_only -from $tx_clk  -to $sys_clk [expr [get_property -min period $tx_clk ] * 0.9]
set_max_delay -datapath_only -from $tx_clk  -to $rx_clk  [expr [get_property -min period $tx_clk ] * 0.9]
set_max_delay -datapath_only -from $rx_clk  -to $sys_clk [expr [get_property -min period $rx_clk ] * 0.9]
set_max_delay -datapath_only -from $rx_clk  -to $tx_clk  [expr [get_property -min period $rx_clk ] * 0.9]
## ================================


## DDR4

# we only use 64 bit out of the 80bit available






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

## contamination deselay fast
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



#set_false_path -from [get_pins {vio_sw_i/inst/PROBE_OUT_ALL_INST/G_PROBE_OUT[0].PROBE_OUT0_INST/Probe_out_reg[0]/C}]
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

