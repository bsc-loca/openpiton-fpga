set_property -dict {PACKAGE_PIN BJ44 IOSTANDARD LVDS} [get_ports hbm_ref_clk_n]
set_property -dict {PACKAGE_PIN BJ43 IOSTANDARD LVDS} [get_ports hbm_ref_clk_p]

set_false_path -from [get_pins {chipset/chipset_impl/mc_top/meep_shell_i/axi_gpio_0/U0/gpio_core_1/Not_Dual.gpio_Data_Out_reg[*]/C}]
set_false_path -from [get_pins {chipset/chipset_impl/mc_top/meep_shell_i/proc_sys_reset_1/U0/PR_OUT_DFF[0].FDRE_PER_replica/C}] -to [get_pins chipset/chipset_impl/mc_top/ui_clk_sync_rst_r_reg/D] 


