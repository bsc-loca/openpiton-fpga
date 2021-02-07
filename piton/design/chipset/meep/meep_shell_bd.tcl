
################################################################
# This is a generated script based on design: meep_shell
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source meep_shell_script.tcl

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:ddr4:2.2\
xilinx.com:ip:qdma:4.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:util_ds_buf:2.1\
xilinx.com:ip:xlconstant:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set C0_DDR4_S_AXI_CTRL_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 C0_DDR4_S_AXI_CTRL_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {0} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {1} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $C0_DDR4_S_AXI_CTRL_0

  set axi4_mm [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 axi4_mm ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {34} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.FREQ_HZ {300000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {7} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $axi4_mm

  set ddr4_sdram_c0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_sdram_c0 ]

  set ddr_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $ddr_clk

  set pci_express_x16 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pci_express_x16 ]

  set pcie_refclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_refclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $pcie_refclk


  # Create ports
  set c0_init_calib_complete_0 [ create_bd_port -dir O c0_init_calib_complete_0 ]
  set pcie_perstn [ create_bd_port -dir I -type rst pcie_perstn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $pcie_perstn
  set sys_rst [ create_bd_port -dir I -type rst sys_rst ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $sys_rst
  set ui_clk [ create_bd_port -dir O -type clk ui_clk ]
  set ui_clk_sync_rst [ create_bd_port -dir O -type rst ui_clk_sync_rst ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {1} \
   CONFIG.ENABLE_PROTOCOL_CHECKERS {1} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
   CONFIG.SYNCHRONIZATION_STAGES {4} \
   CONFIG.XBAR_DATA_WIDTH {512} \
 ] $axi_interconnect_0

  # Create instance: ddr4_0, and set properties
  set ddr4_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_0 ]
  set_property -dict [ list \
   CONFIG.C0_CLOCK_BOARD_INTERFACE {sysclk0} \
   CONFIG.C0_DDR4_BOARD_INTERFACE {ddr4_sdram_c0} \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
 ] $ddr4_0

  # Create instance: qdma_0, and set properties
  set qdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:qdma:4.0 qdma_0 ]
  set_property -dict [ list \
   CONFIG.MAILBOX_ENABLE {true} \
   CONFIG.PCIE_BOARD_INTERFACE {pci_express_x16} \
   CONFIG.PF0_SRIOV_FIRST_VF_OFFSET {4} \
   CONFIG.PF1_SRIOV_CAP_INITIAL_VF {4} \
   CONFIG.PF1_SRIOV_FIRST_VF_OFFSET {7} \
   CONFIG.PF2_SRIOV_CAP_INITIAL_VF {4} \
   CONFIG.PF2_SRIOV_FIRST_VF_OFFSET {10} \
   CONFIG.PF3_SRIOV_CAP_INITIAL_VF {4} \
   CONFIG.PF3_SRIOV_FIRST_VF_OFFSET {13} \
   CONFIG.SRIOV_CAP_ENABLE {true} \
   CONFIG.SRIOV_FIRST_VF_OFFSET {4} \
   CONFIG.SYS_RST_N_BOARD_INTERFACE {pcie_perstn} \
   CONFIG.axilite_master_en {false} \
   CONFIG.barlite_mb_pf0 {1} \
   CONFIG.barlite_mb_pf1 {1} \
   CONFIG.barlite_mb_pf2 {1} \
   CONFIG.barlite_mb_pf3 {1} \
   CONFIG.dma_intf_sel_qdma {AXI_MM} \
   CONFIG.flr_enable {true} \
   CONFIG.pf0_ari_enabled {true} \
   CONFIG.pf0_bar0_prefetchable_qdma {true} \
   CONFIG.pf0_bar2_prefetchable_qdma {true} \
   CONFIG.pf1_bar0_prefetchable_qdma {true} \
   CONFIG.pf1_bar2_prefetchable_qdma {true} \
   CONFIG.pf2_bar0_prefetchable_qdma {true} \
   CONFIG.pf2_bar2_prefetchable_qdma {true} \
   CONFIG.pf3_bar0_prefetchable_qdma {true} \
   CONFIG.pf3_bar2_prefetchable_qdma {true} \
   CONFIG.tl_pf_enable_reg {4} \
 ] $qdma_0

  # Create instance: rst_ddr4_0_300M, and set properties
  set rst_ddr4_0_300M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ddr4_0_300M ]

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_MON_TYPE {MIX} \
   CONFIG.C_NUM_MONITOR_SLOTS {2} \
   CONFIG.C_NUM_OF_PROBES {2} \
   CONFIG.C_PROBE0_TYPE {0} \
   CONFIG.C_PROBE1_TYPE {0} \
   CONFIG.C_SLOT_0_APC_EN {1} \
   CONFIG.C_SLOT_0_AXI_AR_SEL_DATA {1} \
   CONFIG.C_SLOT_0_AXI_AR_SEL_TRIG {1} \
   CONFIG.C_SLOT_0_AXI_AW_SEL_DATA {1} \
   CONFIG.C_SLOT_0_AXI_AW_SEL_TRIG {1} \
   CONFIG.C_SLOT_0_AXI_B_SEL_DATA {1} \
   CONFIG.C_SLOT_0_AXI_B_SEL_TRIG {1} \
   CONFIG.C_SLOT_0_AXI_R_SEL_DATA {1} \
   CONFIG.C_SLOT_0_AXI_R_SEL_TRIG {1} \
   CONFIG.C_SLOT_0_AXI_W_SEL_DATA {1} \
   CONFIG.C_SLOT_0_AXI_W_SEL_TRIG {1} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
   CONFIG.C_SLOT_1_APC_EN {0} \
   CONFIG.C_SLOT_1_AXI_AR_SEL_DATA {1} \
   CONFIG.C_SLOT_1_AXI_AR_SEL_TRIG {1} \
   CONFIG.C_SLOT_1_AXI_AW_SEL_DATA {1} \
   CONFIG.C_SLOT_1_AXI_AW_SEL_TRIG {1} \
   CONFIG.C_SLOT_1_AXI_B_SEL_DATA {1} \
   CONFIG.C_SLOT_1_AXI_B_SEL_TRIG {1} \
   CONFIG.C_SLOT_1_AXI_R_SEL_DATA {1} \
   CONFIG.C_SLOT_1_AXI_R_SEL_TRIG {1} \
   CONFIG.C_SLOT_1_AXI_W_SEL_DATA {1} \
   CONFIG.C_SLOT_1_AXI_W_SEL_TRIG {1} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
 ] $system_ila_0

  # Create instance: util_ds_buf, and set properties
  set util_ds_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
   CONFIG.DIFF_CLK_IN_BOARD_INTERFACE {pcie_refclk} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $util_ds_buf

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net C0_DDR4_S_AXI_CTRL_0_1 [get_bd_intf_ports C0_DDR4_S_AXI_CTRL_0] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI_CTRL]
  connect_bd_intf_net -intf_net axi4_mm_1 [get_bd_intf_ports axi4_mm] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi4_mm_1] [get_bd_intf_ports axi4_mm] [get_bd_intf_pins system_ila_0/SLOT_0_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axi4_mm_1]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_interconnect_0_M00_AXI] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI] [get_bd_intf_pins system_ila_0/SLOT_1_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axi_interconnect_0_M00_AXI]
  connect_bd_intf_net -intf_net ddr4_0_C0_DDR4 [get_bd_intf_ports ddr4_sdram_c0] [get_bd_intf_pins ddr4_0/C0_DDR4]
  connect_bd_intf_net -intf_net pcie_refclk_1 [get_bd_intf_ports pcie_refclk] [get_bd_intf_pins util_ds_buf/CLK_IN_D]
  connect_bd_intf_net -intf_net qdma_0_M_AXI [get_bd_intf_pins axi_interconnect_0/S01_AXI] [get_bd_intf_pins qdma_0/M_AXI]
  connect_bd_intf_net -intf_net qdma_0_pcie_mgt [get_bd_intf_ports pci_express_x16] [get_bd_intf_pins qdma_0/pcie_mgt]
  connect_bd_intf_net -intf_net sysclk0_1 [get_bd_intf_ports ddr_clk] [get_bd_intf_pins ddr4_0/C0_SYS_CLK]

  # Create port connections
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk [get_bd_ports ui_clk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins ddr4_0/c0_ddr4_ui_clk] [get_bd_pins rst_ddr4_0_300M/slowest_sync_clk] [get_bd_pins system_ila_0/clk]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk_sync_rst [get_bd_ports ui_clk_sync_rst] [get_bd_pins ddr4_0/c0_ddr4_ui_clk_sync_rst]
  connect_bd_net -net ddr4_0_c0_init_calib_complete [get_bd_ports c0_init_calib_complete_0] [get_bd_pins ddr4_0/c0_init_calib_complete]
  connect_bd_net -net pcie_perstn_1 [get_bd_ports pcie_perstn] [get_bd_pins qdma_0/soft_reset_n] [get_bd_pins qdma_0/sys_rst_n]
  connect_bd_net -net qdma_0_axi_aclk [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins qdma_0/axi_aclk]
  connect_bd_net -net qdma_0_axi_aresetn [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins qdma_0/axi_aresetn]
  connect_bd_net -net rst_ddr4_0_300M_interconnect_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins rst_ddr4_0_300M/interconnect_aresetn] [get_bd_pins system_ila_0/probe0]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets rst_ddr4_0_300M_interconnect_aresetn]
  connect_bd_net -net rst_ddr4_0_300M_peripheral_aresetn [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins ddr4_0/c0_ddr4_aresetn] [get_bd_pins rst_ddr4_0_300M/peripheral_aresetn] [get_bd_pins system_ila_0/probe1] [get_bd_pins system_ila_0/resetn]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets rst_ddr4_0_300M_peripheral_aresetn]
  connect_bd_net -net rst_ddr4_0_300M_peripheral_reset [get_bd_pins ddr4_0/sys_rst] [get_bd_pins rst_ddr4_0_300M/peripheral_reset]
  connect_bd_net -net sys_rst_0_1 [get_bd_ports sys_rst] [get_bd_pins rst_ddr4_0_300M/ext_reset_in]
  connect_bd_net -net util_ds_buf_IBUF_DS_ODIV2 [get_bd_pins qdma_0/sys_clk] [get_bd_pins util_ds_buf/IBUF_DS_ODIV2]
  connect_bd_net -net util_ds_buf_IBUF_OUT [get_bd_pins qdma_0/sys_clk_gt] [get_bd_pins util_ds_buf/IBUF_OUT]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins qdma_0/qsts_out_rdy] [get_bd_pins qdma_0/tm_dsc_sts_rdy] [get_bd_pins xlconstant_0/dout]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x000400000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x00000000 -range 0x000400000000 -target_address_space [get_bd_addr_spaces axi4_mm] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0x80000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces C0_DDR4_S_AXI_CTRL_0] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP_CTRL/C0_REG]


  # Restore current instance
  current_bd_instance $oldCurInst

}
# End of create_root_design()




proc available_tcl_procs { } {
   puts "##################################################################"
   puts "# Available Tcl procedures to recreate hierarchical blocks:"
   puts "#"
   puts "#    create_root_design"
   puts "#"
   puts "#"
   puts "# The following procedures will create hiearchical blocks with addressing "
   puts "# for IPs within those blocks and their sub-hierarchical blocks. Addressing "
   puts "# will not be handled outside those blocks:"
   puts "#"
   puts "#    create_root_design"
   puts "#"
   puts "##################################################################"
}

available_tcl_procs
