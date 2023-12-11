## ================ Ethernet ================
## Commented pin locations are applied automatically due to configurations inside Ethernet CMAC core (made in BD)
#--------------------------------------------
## Input Clocks and Controls for QSFP28 Port 0
#
## MGT_SI570_CLOCK0   -> MGT Ref Clock 0 156.25MHz Default (Not User re-programmable)
# set_property PACKAGE_PIN T43      [get_ports "MGT_SI570_CLOCK0_N"]  ;# Bank 134 - MGTREFCLK0N_134, platform: io_clk_gtyquad_refclk0_00_clk_n
# set_property PACKAGE_PIN T42      [get_ports "MGT_SI570_CLOCK0_P"]  ;# Bank 134 - MGTREFCLK0P_134, platform: io_clk_gtyquad_refclk0_00_clk_p
set_property PACKAGE_PIN AD43     [get_ports "qsfp*_ref_clk_n"]  ;# Bank 134 - MGTREFCLK0N_134, platform: io_clk_gtyquad_refclk0_00_clk_n
set_property PACKAGE_PIN AB42      [get_ports "qsfp*_ref_clk_p"]  ;# Bank 134 - MGTREFCLK0P_134, platform: io_clk_gtyquad_refclk0_00_clk_p
#

#--------------------------------------------
# Input Clocks and Controls for QSFP28 Port 1
#
## MGT_SI570_CLOCK1_N   -> MGT Ref Clock 0 156.25MHz Default (Not User re-programmable)
# set_property PACKAGE_PIN P43       [get_ports "MGT_SI570_CLOCK1_N"] ;# Bank 135 - MGTREFCLK0N_135, platform: io_clk_gtyquad_refclk0_01_clk_n
# set_property PACKAGE_PIN P42       [get_ports "MGT_SI570_CLOCK1_P"] ;# Bank 135 - MGTREFCLK0P_135, platform: io_clk_gtyquad_refclk0_01_clk_p
#set_property PACKAGE_PIN P43       [get_ports "qsfp1_ref_clk_n"] ;# Bank 135 - MGTREFCLK0N_135, platform: io_clk_gtyquad_refclk0_01_clk_n
#set_property PACKAGE_PIN P42       [get_ports "qsfp1_ref_clk_p"] ;# Bank 135 - MGTREFCLK0P_135, platform: io_clk_gtyquad_refclk0_01_clk_p
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
set_property USER_SLR_ASSIGNMENT SLR1 [get_cells "$tx_clk_units $rx_clk_units $eth_txmem $eth_rxmem"]
#set_property USER_SLR_ASSIGNMENT SLR1 [get_cells "$tx_clk_units $rx_clk_units $eth_txmem $eth_rxmem"]

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
