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

# Clock signals
set_property -dict {PACKAGE_PIN BL10 IOSTANDARD LVDS} [get_ports chipset_clk_osc_n]
set_property -dict {PACKAGE_PIN BK10 IOSTANDARD LVDS} [get_ports chipset_clk_osc_p]

# set_property -dict {PACKAGE_PIN BJ44 IOSTANDARD LVDS} [get_ports mc_clk_n]
# set_property -dict {PACKAGE_PIN BJ43 IOSTANDARD LVDS} [get_ports mc_clk_p]

# ref clock for MIG

set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets chipset/clk_mmcm/inst/clkin1_ibufds/O]

# Reset, note that this is active high on this board!! MAKE LOW for ALVEO!
#set_property -dict {PACKAGE_PIN BH26  IOSTANDARD LVCMOS12} [get_ports "sys_rst_n"] ;# CPU_RESET_FPGA

set_property PACKAGE_PIN BF41         [get_ports pcie_perstn]                           
set_property IOSTANDARD  LVCMOS18         [get_ports pcie_perstn]                          
# set_property PACKAGE_PIN BK44             [get_ports pcie_refclk_n]                        
# set_property PACKAGE_PIN BK43             [get_ports pcie_refclk_p]                        
# create_clock -period 10.000 -name PCIE_CLK [get_ports pcie_refclk_p]

##
## PCIe MGTY Interface
##
# set_property PACKAGE_PIN BF41             [get_ports pcie_perstn]                          ;# Bank  67 VCCO - VCC1V8   - IO_L13P_T2L_N0_GC_QBC_67
# set_property IOSTANDARD  LVCMOS18         [get_ports pcie_perstn]                          ;# Bank  67 VCCO - VCC1V8   - IO_L13P_T2L_N0_GC_QBC_67

# set_property PACKAGE_PIN BC1              [get_ports {pci_express_x16_rxn[15]} ]                   ;# Bank 224 - MGTYRXN0_224
# set_property PACKAGE_PIN BB3              [get_ports {pci_express_x16_rxn[14]} ]                   ;# Bank 224 - MGTYRXN1_224
# set_property PACKAGE_PIN BA1              [get_ports {pci_express_x16_rxn[13]} ]                   ;# Bank 224 - MGTYRXN2_224
# set_property PACKAGE_PIN BA5              [get_ports {pci_express_x16_rxn[12]} ]                   ;# Bank 224 - MGTYRXN3_224
# set_property PACKAGE_PIN BC2              [get_ports {pci_express_x16_rxp[15]} ]                   ;# Bank 224 - MGTYRXP0_224
# set_property PACKAGE_PIN BB4              [get_ports {pci_express_x16_rxp[14]} ]                   ;# Bank 224 - MGTYRXP1_224
# set_property PACKAGE_PIN BA2              [get_ports {pci_express_x16_rxp[13]} ]                   ;# Bank 224 - MGTYRXP2_224
#set_property PACKAGE_PIN BA6              [get_ports {pci_express_x16_rxp[12]} ]                   ;# Bank 224 - MGTYRXP3_224
#set_property PACKAGE_PIN BC6              [get_ports {pci_express_x16_txn[15]} ]                   ;# Bank 224 - MGTYTXN0_224
#set_property PACKAGE_PIN BC10             [get_ports {pci_express_x16_txn[14]} ]                   ;# Bank 224 - MGTYTXN1_224
#set_property PACKAGE_PIN BB8              [get_ports {pci_express_x16_txn[13]} ]                   ;# Bank 224 - MGTYTXN2_224
#set_property PACKAGE_PIN BA10             [get_ports {pci_express_x16_txn[12]} ]                   ;# Bank 224 - MGTYTXN3_224
#set_property PACKAGE_PIN BC7              [get_ports {pci_express_x16_txp[15]} ]                   ;# Bank 224 - MGTYTXP0_224
#set_property PACKAGE_PIN BC11             [get_ports {pci_express_x16_txp[14]} ]                   ;# Bank 224 - MGTYTXP1_224
#set_property PACKAGE_PIN BB9              [get_ports {pci_express_x16_txp[13]} ]                   ;# Bank 224 - MGTYTXP2_224
#set_property PACKAGE_PIN BA11             [get_ports {pci_express_x16_txp[12]} ]                   ;# Bank 224 - MGTYTXP3_224
# set_property PACKAGE_PIN AR14             [get_ports pcie_refclk_clk_n ]                       ;# Bank 225 - MGTREFCLK0N_225
# set_property PACKAGE_PIN AR15             [get_ports pcie_refclk_clk_p ]                       ;# Bank 225 - MGTREFCLK0P_225

set_property PACKAGE_PIN AR14             [get_ports pcie_refclk_n ]                       ;# Bank 225 - MGTREFCLK0N_225
set_property PACKAGE_PIN AR15             [get_ports pcie_refclk_p ]                       ;# Bank 225 - MGTREFCLK0P_225
# Set the reference clock
 create_clock -period 10.000 -name  pcie_refclk [get_ports pcie_refclk_p]
#set_property PACKAGE_PIN AP12             [get_ports "SYSCLK5_N"]                          ;# Bank 225 - MGTREFCLK1N_225
#set_property PACKAGE_PIN AP13             [get_ports "SYSCLK5_P"]                          ;# Bank 225 - MGTREFCLK1P_225
# set_property PACKAGE_PIN AY3              [get_ports {pci_express_x16_rxn[11]} ]                   ;# Bank 225 - MGTYRXN0_225
# set_property PACKAGE_PIN AW1              [get_ports {pci_express_x16_rxn[10]} ]                   ;# Bank 225 - MGTYRXN1_225
# set_property PACKAGE_PIN AW5              [get_ports {pci_express_x16_rxn[9]} ]                    ;# Bank 225 - MGTYRXN2_225
# set_property PACKAGE_PIN AV3              [get_ports {pci_express_x16_rxn[8]} ]                    ;# Bank 225 - MGTYRXN3_225
# set_property PACKAGE_PIN AY4              [get_ports {pci_express_x16_rxp[11]} ]                   ;# Bank 225 - MGTYRXP0_225
# set_property PACKAGE_PIN AW2              [get_ports {pci_express_x16_rxp[10]} ]                   ;# Bank 225 - MGTYRXP1_225
# set_property PACKAGE_PIN AW6              [get_ports {pci_express_x16_rxp[9]} ]                    ;# Bank 225 - MGTYRXP2_225
# set_property PACKAGE_PIN AV4              [get_ports {pci_express_x16_rxp[8]} ]                    ;# Bank 225 - MGTYRXP3_225
# set_property PACKAGE_PIN AY8              [get_ports {pci_express_x16_txn[11]} ]                   ;# Bank 225 - MGTYTXN0_225
# set_property PACKAGE_PIN AW10             [get_ports {pci_express_x16_txn[10]} ]                   ;# Bank 225 - MGTYTXN1_225
# set_property PACKAGE_PIN AV8              [get_ports {pci_express_x16_txn[9]} ]                    ;# Bank 225 - MGTYTXN2_225
# set_property PACKAGE_PIN AU6              [get_ports {pci_express_x16_txn[8]} ]                    ;# Bank 225 - MGTYTXN3_225
# set_property PACKAGE_PIN AY9              [get_ports {pci_express_x16_txp[11]} ]                   ;# Bank 225 - MGTYTXP0_225
# set_property PACKAGE_PIN AW11             [get_ports {pci_express_x16_txp[10]} ]                   ;# Bank 225 - MGTYTXP1_225
# set_property PACKAGE_PIN AU7              [get_ports {pci_express_x16_txp[8]} ]                    ;# Bank 225 - MGTYTXP2_225
# set_property PACKAGE_PIN AV9              [get_ports {pci_express_x16_txp[9]} ]                    ;# Bank 225 - MGTYTXP3_225
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
# set_property PACKAGE_PIN AL11             [get_ports {pci_express_x16_txp[0]} ]  

#--------------------------------------------
# Specifying the placement of PCIe clock domain modules into single SLR to facilitate routing
# https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_1/ug912-vivado-properties.pdf#page=386
#Collecting all units from correspondingly PCIe domain,
#set pcie_clk_units [get_cells -of_objects [get_nets -of_objects [get_pins -hierarchical qdma_0/axi_aclk]]]
#Setting specific SLR to which PCIe pins are wired since placer may miss it if just "group_name" is applied
#set_property USER_SLR_ASSIGNMENT SLR0 [get_cells "$pcie_clk_units"]

## ================================


# False paths
# set_false_path -to [get_cells -hierarchical *afifo_ui_rst_r*]
# set_false_path -to [get_cells -hierarchical *ui_clk_sync_rst_r*]
# set_false_path -to [get_cells -hierarchical *ui_clk_syn_rst_delayed*]
# set_false_path -to [get_cells -hierarchical *init_calib_complete_f*]
# set_false_path -to [get_cells -hierarchical *chipset_rst_n*]
# net not instantiated yet

#### UART
#IO_L11N_T1_SRCC_35 Sch=uart_rxd_out
set_property -dict {PACKAGE_PIN BJ41 IOSTANDARD LVCMOS18} [get_ports uart_tx]
set_property -dict {PACKAGE_PIN BK41 IOSTANDARD LVCMOS18} [get_ports uart_rx]
set_property IOSTANDARD  LVCMOS18         [get_ports uart_*]


#################
# clock groups

#set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks sd_clk_out] -group [get_clocks -include_generated_clocks sd_clk_out_1]
#set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clocks {sd_fast_clk}] -group [get_clocks -include_generated_clocks {sd_slow_clk}]
#set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks chipset_clk_clk_mmcm] -group [get_clocks -filter { NAME =~  "*sd*" }]

#set_false_path -from [get_pins -hierarchical *Not_Dual.gpio_Data_Out_reg[*]/C]

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
