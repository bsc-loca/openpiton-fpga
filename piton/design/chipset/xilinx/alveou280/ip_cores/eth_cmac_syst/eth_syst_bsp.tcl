
# Script to generate BSP containing address definitions for Ethernet core

set tcl_orig   [open ./bd/Eth_CMAC_syst/eth_cmac_syst.tcl         r]
file mkdir           ./bd/Eth_syst_w_uBlaze/
set tcl_uBlaze [open ./bd/Eth_syst_w_uBlaze/eth_syst_w_uBlaze.tcl w]
file delete $tcl_uBlaze

while {[gets $tcl_orig line] >= 0} {
  # renaming the Block Design
  set line [string map {"Eth_CMAC_syst" "Eth_syst_w_uBlaze"} $line]

  # adding MicroBlaze core
  if {[string first "set list_check_ips" $line] >= 0} {
    puts $tcl_uBlaze $line
    puts -nonewline $tcl_uBlaze "  xilinx.com:ip:microblaze:11.0"
    continue
  }

  # replacing external AXI port with MicroBlaze instance
  if      {[string first "set s_axi " $line] >= 0} {
    while {[string first {] $s_axi}   $line] <  0} {
      gets $tcl_orig line
    }
    puts $tcl_uBlaze {  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]}
    puts -nonewline $tcl_uBlaze {  set_property -dict [ list}
    puts -nonewline $tcl_uBlaze " CONFIG.C_ADDR_TAG_BITS {0}"
    puts -nonewline $tcl_uBlaze " CONFIG.C_AREA_OPTIMIZED {1}"
    puts -nonewline $tcl_uBlaze " CONFIG.C_DATA_SIZE {32}"
    puts -nonewline $tcl_uBlaze " CONFIG.C_DCACHE_ADDR_TAG {0}"
    puts -nonewline $tcl_uBlaze " CONFIG.C_DEBUG_ENABLED {0}"
    puts -nonewline $tcl_uBlaze " CONFIG.C_D_AXI {1}"
    puts -nonewline $tcl_uBlaze " CONFIG.C_D_LMB {0}"
    puts -nonewline $tcl_uBlaze " CONFIG.C_I_LMB {0}"
    puts -nonewline $tcl_uBlaze " CONFIG.C_USE_REORDER_INSTR {0}"
    puts -nonewline $tcl_uBlaze { ] $microblaze_0}
    continue
  }

  # removing external AXI port association
  if {[string first "CONFIG.ASSOCIATED_BUSIF {s_axi}" $line] >= 0} {
    continue
  }

  # reconnecting AXI Interconnect to MicroBlaze
  set line [string map {"get_bd_intf_ports s_axi" "get_bd_intf_pins microblaze_0/M_AXI_DP"} $line]
  # connecting clock to MicroBlaze
  set line [string map {"[get_bd_ports s_axi_clk]" "[get_bd_ports s_axi_clk] [get_bd_pins microblaze_0/Clk]"} $line]
  # connecting reset to MicroBlaze
  set line [string map {"[get_bd_pins ext_rstn_inv/Res]" "[get_bd_pins ext_rstn_inv/Res] [get_bd_pins microblaze_0/Reset]"} $line]
  # renaming address segments
  set line [string map {"get_bd_addr_spaces s_axi" "get_bd_addr_spaces microblaze_0/Data"} $line]

  puts $tcl_uBlaze $line
}
close $tcl_orig
close $tcl_uBlaze

# creation of BD with MicroBlaze inside
source ./bd/Eth_syst_w_uBlaze/eth_syst_w_uBlaze.tcl
cr_bd_Eth_syst_w_uBlaze ""
generate_target all [get_files ./bd/Eth_syst_w_uBlaze/Eth_syst_w_uBlaze.bd]

# generating BSP on base of above BD using HSI tool
# HSI reference: https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_2/ug1138-generating-basic-software-platforms.pdf
#                https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841693/HSI+debugging+and+optimization+techniques

hsi::open_hw_design ./bd/Eth_syst_w_uBlaze/hw_handoff/Eth_syst_w_uBlaze.hwh
hsi::create_sw_design -proc microblaze_0 baremet_bsp
hsi::generate_bsp -dir ./bd/Eth_syst_w_uBlaze/baremet_bsp
hsi::close_sw_design [hsi::current_sw_design]
hsi::close_hw_design [hsi::current_hw_design]
