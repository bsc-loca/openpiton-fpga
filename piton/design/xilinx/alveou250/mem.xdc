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
# hbm_cattrip is not required for u250 since it doesn't support HBM.
# but for saving maximum compatibility in verilog sources connecting it to unsed port.
# ------------------------------------------------------------------------
set_property PACKAGE_PIN AR20     [get_ports hbm_cattrip]; # Bank 64 VCCO - VCC1V8 Net "GPIO_MSP0" - IO_T0U_N12_VRP_64
set_property IOSTANDARD  LVCMOS12 [get_ports hbm_cattrip]; # Bank 64 VCCO - VCC1V8 Net "GPIO_MSP0" - IO_T0U_N12_VRP_64

set_property -dict {PACKAGE_PIN AW19 IOSTANDARD LVDS} [get_ports mc_clk_n]; # Bank 64 VCCO - VCC1V2 Net "SYSCLK1_300_N" - IO_L11N_T1U_N9_GC_64
set_property -dict {PACKAGE_PIN AW20 IOSTANDARD LVDS} [get_ports mc_clk_p]; # Bank 64 VCCO - VCC1V2 Net "SYSCLK1_300_P" - IO_L11P_T1U_N8_GC_64
#create_clock is needed in case of passing MEM_CLK through diff buffer (for HBM)
# create_clock -period 3.3333 -name MEM_CLK [get_ports "mc_clk_p"]

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
