set_property -dict {PACKAGE_PIN BJ44 IOSTANDARD LVDS} [get_ports hbm_ref_clk_n]
set_property -dict {PACKAGE_PIN BJ43 IOSTANDARD LVDS} [get_ports hbm_ref_clk_p]

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
#
set_property PACKAGE_PIN D32      [get_ports hbm_cattrip]  ;# Bank  75 VCCO - VCC1V8   - IO_L17P_T2U_N8_AD10P_75
set_property IOSTANDARD  LVCMOS18 [get_ports hbm_cattrip]  ;# Bank  75 VCCO - VCC1V8   - IO_L17P_T2U_N8_AD10P_75
set_property PULLTYPE    PULLDOWN [get_ports hbm_cattrip]  ;# Setting HBM_CATTRIP to low by default to avoid the SC shutting down the card
# ------------------------------------------------------------------------


set_false_path -from [get_pins {chipset/chipset_impl/mc_top/meep_shell_i/axi_gpio_0/U0/gpio_core_1/Not_Dual.gpio_Data_Out_reg[*]/C}]
set_false_path -from [get_pins {chipset/chipset_impl/mc_top/meep_shell_i/proc_sys_reset_1/U0/PR_OUT_DFF[0].FDRE_PER_replica/C}] -to [get_pins chipset/chipset_impl/mc_top/ui_clk_sync_rst_r_reg/D] 


