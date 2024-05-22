# ------------------------------------------------------------------------
# HBM Catastrophic Over temperature Output signal to Satellite Controller
#    HBM_CATTRIP Active high indicator to Satellite controller to indicate the HBM has exceeded its maximum allowable temperature.
#                This signal is not a dedicated Ultrascale+ Device output and is a derived signal in RTL. Making the signal Active will shut
#                the Ultrascale+ Device power rails off.
#
# From UG1314 (Alveo U280 Data Center Accelerator Card User Guide):
# WARNING! When creating a design for this card, it is necessary to drive the CATTRIP pin.
# This pin is monitored by the card's satellite controller (SC) and represents the HBM_CATRIP (HBM
# catastrophic temperature failure). When instantiating the HBM IP in your design, the two HBM IP signals,
# DRAM_0_STAT_CATTRIP and DRAM_1_STAT_CATTRIP, must be ORed together and connected to this pin for
# proper card operation. If the pin is undefined it will be pulled High by the card causing the SC to infer a CATRIP
# failure and shut power down to the card.
# If you do not use the HBM IP in your design, you must drive the pin Low to avoid the SC shutting down the card.
# If the pin is undefined and the QSPI is programmed with the MCS file, there is a potential chance that the card
# will continuously power down and reset after the bitstream is loaded. This can result in the card being unusable.
# ------------------------------------------------------------------------
set_property PACKAGE_PIN D32      [get_ports hbm_cattrip]  ;# Bank  75 VCCO - VCC1V8   - IO_L17P_T2U_N8_AD10P_75
set_property IOSTANDARD  LVCMOS18 [get_ports hbm_cattrip]  ;# Bank  75 VCCO - VCC1V8   - IO_L17P_T2U_N8_AD10P_75
set_property PULLTYPE    PULLDOWN [get_ports hbm_cattrip]  ;# Setting HBM_CATTRIP to low by default to avoid the SC shutting down the card

set_property -dict {PACKAGE_PIN BJ44 IOSTANDARD LVDS} [get_ports mc_clk_n] ;# Bank  65 VCCO - VCC1V2 Net "SYSCLK0_N" - IO_L12N_T1U_N11_GC_A09_D25_65
set_property -dict {PACKAGE_PIN BJ43 IOSTANDARD LVDS} [get_ports mc_clk_p] ;# Bank  65 VCCO - VCC1V2 Net "SYSCLK0_P" - IO_L12P_T1U_N10_GC_A08_D24_65
#create_clock is needed in case of passing MEM_CLK through diff buffer (for HBM)
create_clock -period 10.000 -name MEM_CLK [get_ports "mc_clk_p"]

#--------------------------------------------
# Timing constraints for CDC in SDRAM user interface, particularly in HBM APB which is disabled but clocked by fixed mem ref clock
set sys_ck [get_clocks -of_objects [get_pins -hierarchical meep_shell/sys_clk]]
set mem_ck [get_clocks -of_objects [get_pins -hierarchical meep_shell/mem_clk]]
set ref_ck [get_clocks -of_objects [get_pins -hierarchical meep_shell/mem_refclk_clk_p]]
# set_false_path -from $xxx_clk -to $yyy_clk
# controlling resync paths to be less than source clock period
# (-datapath_only to exclude clock paths)
set_max_delay -datapath_only -from $mem_ck -to $ref_ck [expr [get_property -min period $mem_ck] * 0.9]
set_max_delay -datapath_only -from $ref_ck -to $mem_ck [expr [get_property -min period $ref_ck] * 0.9]
set_max_delay -datapath_only -from $mem_ck -to $sys_ck [expr [get_property -min period $mem_ck] * 0.9]
set_max_delay -datapath_only -from $sys_ck -to $mem_ck [expr [get_property -min period $sys_ck] * 0.9]
#--------------------------------------------
