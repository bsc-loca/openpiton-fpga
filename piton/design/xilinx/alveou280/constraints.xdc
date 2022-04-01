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
set_property -dict {PACKAGE_PIN BJ6 IOSTANDARD LVDS} [get_ports chipset_clk_osc_n]
set_property -dict {PACKAGE_PIN BH6 IOSTANDARD LVDS} [get_ports chipset_clk_osc_p]

# set_property -dict {PACKAGE_PIN BJ44 IOSTANDARD LVDS} [get_ports mc_clk_n]
# set_property -dict {PACKAGE_PIN BJ43 IOSTANDARD LVDS} [get_ports mc_clk_p]

# ref clock for MIG

set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets chipset/clk_mmcm/inst/clkin1_ibufds/O]

# Reset, note that this is active high on this board!! MAKE LOW for ALVEO!
#set_property -dict {PACKAGE_PIN BH26  IOSTANDARD LVCMOS12} [get_ports "sys_rst_n"] ;# CPU_RESET_FPGA

set_property PACKAGE_PIN BH26             [get_ports pcie_perstn]                          ;# Bank  67 VCCO - VCC1V8   - IO_L13P_T2L_N0_GC_QBC_67
set_property IOSTANDARD  LVCMOS18         [get_ports pcie_perstn]                          ;# Bank  67 VCCO - VCC1V8   - IO_L13P_T2L_N0_GC_QBC_67
set_property PACKAGE_PIN AR14              [get_ports pcie_refclk_n]                        ;# Bank 225 - MGTREFCLK0N_225
set_property PACKAGE_PIN AR15              [get_ports pcie_refclk_p]                        ;# Bank 225 - MGTREFCLK0P_225
create_clock -period 10.000 -name PCIE_CLK [get_ports pcie_refclk_p]

## PCIe MGTY Interface
##
# set_property PACKAGE_PIN BC1              [get_ports {pci_express_x16_rxn[15]} ]                   ;# Bank 224 - MGTYRXN0_224
# set_property PACKAGE_PIN BB3              [get_ports {pci_express_x16_rxn[14]} ]                   ;# Bank 224 - MGTYRXN1_224
# set_property PACKAGE_PIN BA1              [get_ports {pci_express_x16_rxn[13]} ]                   ;# Bank 224 - MGTYRXN2_224
# set_property PACKAGE_PIN BA5              [get_ports {pci_express_x16_rxn[12]} ]                   ;# Bank 224 - MGTYRXN3_224
# set_property PACKAGE_PIN BC2              [get_ports {pci_express_x16_rxp[15]} ]                   ;# Bank 224 - MGTYRXP0_224
# set_property PACKAGE_PIN BB4              [get_ports {pci_express_x16_rxp[14]} ]                   ;# Bank 224 - MGTYRXP1_224
# set_property PACKAGE_PIN BA2              [get_ports {pci_express_x16_rxp[13]} ]                   ;# Bank 224 - MGTYRXP2_224
# set_property PACKAGE_PIN BA6              [get_ports {pci_express_x16_rxp[12]} ]                   ;# Bank 224 - MGTYRXP3_224
# set_property PACKAGE_PIN BC6              [get_ports {pci_express_x16_txn[15]} ]                   ;# Bank 224 - MGTYTXN0_224
# set_property PACKAGE_PIN BC10             [get_ports {pci_express_x16_txn[14]} ]                   ;# Bank 224 - MGTYTXN1_224
# set_property PACKAGE_PIN BB8              [get_ports {pci_express_x16_txn[13]} ]                   ;# Bank 224 - MGTYTXN2_224
# set_property PACKAGE_PIN BA10             [get_ports {pci_express_x16_txn[12]} ]                   ;# Bank 224 - MGTYTXN3_224
# set_property PACKAGE_PIN BC7              [get_ports {pci_express_x16_txp[15]} ]                   ;# Bank 224 - MGTYTXP0_224
# set_property PACKAGE_PIN BC11             [get_ports {pci_express_x16_txp[14]} ]                   ;# Bank 224 - MGTYTXP1_224
# set_property PACKAGE_PIN BB9              [get_ports {pci_express_x16_txp[13]} ]                   ;# Bank 224 - MGTYTXP2_224
# set_property PACKAGE_PIN BA11             [get_ports {pci_express_x16_txp[12]} ]                   ;# Bank 224 - MGTYTXP3_224
# #set_property PACKAGE_PIN AR14             [get_ports "pcie_clk0_p" ]                       ;# Bank 225 - MGTREFCLK0N_225
# #set_property PACKAGE_PIN AR15             [get_ports "pcie_clk0_p" ]                       ;# Bank 225 - MGTREFCLK0P_225
# #set_property PACKAGE_PIN AP12             [get_ports "SYSCLK5_N"]                          ;# Bank 225 - MGTREFCLK1N_225
# #set_property PACKAGE_PIN AP13             [get_ports "SYSCLK5_P"]                          ;# Bank 225 - MGTREFCLK1P_225
# set_property PACKAGE_PIN AY3              [get_ports {pci_express_x16_rxn[11]}]                    ;# Bank 225 - MGTYRXN0_225
# set_property PACKAGE_PIN AW1              [get_ports {pci_express_x16_rxn[10]}]                    ;# Bank 225 - MGTYRXN1_225
# set_property PACKAGE_PIN AW5              [get_ports {pci_express_x16_rxn[9]} ]                    ;# Bank 225 - MGTYRXN2_225
# set_property PACKAGE_PIN AV3              [get_ports {pci_express_x16_rxn[8]} ]                    ;# Bank 225 - MGTYRXN3_225
# set_property PACKAGE_PIN AY4              [get_ports {pci_express_x16_rxp[11]}]                    ;# Bank 225 - MGTYRXP0_225
# set_property PACKAGE_PIN AW2              [get_ports {pci_express_x16_rxp[10]}]                    ;# Bank 225 - MGTYRXP1_225
# set_property PACKAGE_PIN AW6              [get_ports {pci_express_x16_rxp[9]} ]                    ;# Bank 225 - MGTYRXP2_225
# set_property PACKAGE_PIN AV4              [get_ports {pci_express_x16_rxp[8]} ]                    ;# Bank 225 - MGTYRXP3_225
# set_property PACKAGE_PIN AY8              [get_ports {pci_express_x16_txn[11]}]                    ;# Bank 225 - MGTYTXN0_225
# set_property PACKAGE_PIN AW10             [get_ports {pci_express_x16_txn[10]}]                    ;# Bank 225 - MGTYTXN1_225
# set_property PACKAGE_PIN AV8              [get_ports {pci_express_x16_txn[9]} ]                    ;# Bank 225 - MGTYTXN2_225
# set_property PACKAGE_PIN AU6              [get_ports {pci_express_x16_txn[8]} ]                    ;# Bank 225 - MGTYTXN3_225
# set_property PACKAGE_PIN AY9              [get_ports {pci_express_x16_txp[11]}]                    ;# Bank 225 - MGTYTXP0_225
# set_property PACKAGE_PIN AW11             [get_ports {pci_express_x16_txp[10]}]                    ;# Bank 225 - MGTYTXP1_225
# set_property PACKAGE_PIN AV9              [get_ports {pci_express_x16_txp[9]} ]                    ;# Bank 225 - MGTYTXP2_225
# set_property PACKAGE_PIN AU7              [get_ports {pci_express_x16_txp[8]} ]                    ;# Bank 225 - MGTYTXP3_225
# set_property PACKAGE_PIN AU1              [get_ports {pci_express_x16_rxn[7]} ]                    ;# Bank 226 - MGTYRXN0_226
# set_property PACKAGE_PIN AT3              [get_ports {pci_express_x16_rxn[6]} ]                    ;# Bank 226 - MGTYRXN1_226
# set_property PACKAGE_PIN AR1              [get_ports {pci_express_x16_rxn[5]} ]                    ;# Bank 226 - MGTYRXN2_226
# set_property PACKAGE_PIN AP3              [get_ports {pci_express_x16_rxn[4]} ]                    ;# Bank 226 - MGTYRXN3_226
# set_property PACKAGE_PIN AU2              [get_ports {pci_express_x16_rxp[7]} ]                    ;# Bank 226 - MGTYRXP0_226
# set_property PACKAGE_PIN AT4              [get_ports {pci_express_x16_rxp[6]} ]                    ;# Bank 226 - MGTYRXP1_226
# set_property PACKAGE_PIN AR2              [get_ports {pci_express_x16_rxp[5]} ]                    ;# Bank 226 - MGTYRXP2_226
# set_property PACKAGE_PIN AP4              [get_ports {pci_express_x16_rxp[4]} ]                    ;# Bank 226 - MGTYRXP3_226
# set_property PACKAGE_PIN AU10             [get_ports {pci_express_x16_txn[7]} ]                    ;# Bank 226 - MGTYTXN0_226
# set_property PACKAGE_PIN AT8              [get_ports {pci_express_x16_txn[6]} ]                    ;# Bank 226 - MGTYTXN1_226
# set_property PACKAGE_PIN AR6              [get_ports {pci_express_x16_txn[5]} ]                    ;# Bank 226 - MGTYTXN2_226
# set_property PACKAGE_PIN AR10             [get_ports {pci_express_x16_txn[4]} ]                    ;# Bank 226 - MGTYTXN3_226
# set_property PACKAGE_PIN AU11             [get_ports {pci_express_x16_txp[7]} ]                    ;# Bank 226 - MGTYTXP0_226
# set_property PACKAGE_PIN AT9              [get_ports {pci_express_x16_txp[6]} ]                    ;# Bank 226 - MGTYTXP1_226
# set_property PACKAGE_PIN AR7              [get_ports {pci_express_x16_txp[5]} ]                    ;# Bank 226 - MGTYTXP2_226
# set_property PACKAGE_PIN AR11             [get_ports {pci_express_x16_txp[4]} ]                    ;# Bank 226 - MGTYTXP3_226
# #set_property PACKAGE_PIN AL14             [get_ports {pcie_clk0_n} ]                       ;# Bank 227 - MGTREFCLK0N_227
# #set_property PACKAGE_PIN AL15             [get_ports {pcie_clk0_n} ]                       ;# Bank 227 - MGTREFCLK0P_227
# #set_property PACKAGE_PIN AK12             [get_ports {sys_clk2_n} ]                        ;# Bank 227 - MGTREFCLK1N_227
# #set_property PACKAGE_PIN AK13             [get_ports {sys_clk2_n} ]                        ;# Bank 227 - MGTREFCLK1P_227
# set_property PACKAGE_PIN AN1              [get_ports {pci_express_x16_rxn[3]} ]                    ;# Bank 227 - MGTYRXN0_227
# set_property PACKAGE_PIN AN5              [get_ports {pci_express_x16_rxn[2]} ]                    ;# Bank 227 - MGTYRXN1_227
# set_property PACKAGE_PIN AM3              [get_ports {pci_express_x16_rxn[1]} ]                    ;# Bank 227 - MGTYRXN2_227
# set_property PACKAGE_PIN AL1              [get_ports {pci_express_x16_rxn[0]} ]                    ;# Bank 227 - MGTYRXN3_227
# set_property PACKAGE_PIN AN2              [get_ports {pci_express_x16_rxp[3]} ]                    ;# Bank 227 - MGTYRXP0_227
# set_property PACKAGE_PIN AN6              [get_ports {pci_express_x16_rxp[2]} ]                    ;# Bank 227 - MGTYRXP1_227
# set_property PACKAGE_PIN AM4              [get_ports {pci_express_x16_rxp[1]} ]                    ;# Bank 227 - MGTYRXP2_227
# set_property PACKAGE_PIN AL2              [get_ports {pci_express_x16_rxp[0]} ]                    ;# Bank 227 - MGTYRXP3_227
# set_property PACKAGE_PIN AP8              [get_ports {pci_express_x16_txn[3]} ]                    ;# Bank 227 - MGTYTXN0_227
# set_property PACKAGE_PIN AN10             [get_ports {pci_express_x16_txn[2]} ]                    ;# Bank 227 - MGTYTXN1_227
# set_property PACKAGE_PIN AM8              [get_ports {pci_express_x16_txn[1]} ]                    ;# Bank 227 - MGTYTXN2_227
# set_property PACKAGE_PIN AL10             [get_ports {pci_express_x16_txn[0]} ]                    ;# Bank 227 - MGTYTXN3_227
# set_property PACKAGE_PIN AP9              [get_ports {pci_express_x16_txp[3]} ]                    ;# Bank 227 - MGTYTXP0_227
# set_property PACKAGE_PIN AN11             [get_ports {pci_express_x16_txp[2]} ]                    ;# Bank 227 - MGTYTXP1_227
# set_property PACKAGE_PIN AM9              [get_ports {pci_express_x16_txp[1]} ]                    ;# Bank 227 - MGTYTXP2_227
# set_property PACKAGE_PIN AL11             [get_ports {pci_express_x16_txp[0]} ]                    ;# Bank 227 - MGTYTXP3_227


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

set_false_path -from [get_pins {chipset/chipset_impl/mc_top/meep_shell/axi_gpio_0/U0/gpio_core_1/Not_Dual.gpio_Data_Out_reg[*]/C}]

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
