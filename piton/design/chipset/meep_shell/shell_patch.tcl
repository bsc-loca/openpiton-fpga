create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.Enable_32bit_Address {false} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Byte_Size {9} CONFIG.Write_Depth_A {2048} CONFIG.Write_Width_B {64} CONFIG.Read_Width_B {64} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Register_PortA_Output_of_Memory_Primitives {true} CONFIG.Register_PortA_Output_of_Memory_Core {true} CONFIG.Register_PortB_Output_of_Memory_Primitives {false} CONFIG.Use_RSTA_Pin {false} CONFIG.Use_RSTB_Pin {false} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Write_Rate {50} CONFIG.Port_B_Enable_Rate {100} CONFIG.use_bram_block {Stand_Alone} CONFIG.EN_SAFETY_CKT {false}] [get_bd_cells blk_mem_gen_0]
make_bd_pins_external  [get_bd_pins blk_mem_gen_0/addrb]
make_bd_pins_external  [get_bd_pins blk_mem_gen_0/doutb]
connect_bd_net [get_bd_pins blk_mem_gen_0/clkb] [get_bd_pins clk_wiz_1/clk_out1]
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1}] [get_bd_cells axi_bram_ctrl_0]
connect_bd_intf_net [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
set_property -dict [list CONFIG.Write_Width_A {64} CONFIG.Read_Width_A {64}] [get_bd_cells blk_mem_gen_0]
set_property -dict [list CONFIG.DATA_WIDTH {64} CONFIG.PROTOCOL {AXI4}] [get_bd_cells axi_bram_ctrl_0]
connect_bd_net [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins qdma_0/axi_aclk]
connect_bd_net [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins qdma_0/axi_aresetn]
set_property -dict [list CONFIG.NUM_MI {2}] [get_bd_cells smartconnect_pcie_dma]
connect_bd_intf_net [get_bd_intf_pins smartconnect_pcie_dma/M01_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
assign_bd_address -target_address_space /qdma_0/M_AXI [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
set_property -dict [list CONFIG.Enable_32bit_Address {true} CONFIG.Use_Byte_Write_Enable {true} CONFIG.Byte_Size {8} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortA_Output_of_Memory_Core {false} CONFIG.Use_RSTA_Pin {true} CONFIG.Use_RSTB_Pin {true} CONFIG.use_bram_block {BRAM_Controller} CONFIG.EN_SAFETY_CKT {true}] [get_bd_cells blk_mem_gen_0]
connect_bd_net [get_bd_pins blk_mem_gen_0/rstb] [get_bd_pins rst_ea_CLK0/peripheral_reset]
make_bd_pins_external  [get_bd_pins blk_mem_gen_0/enb]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property -dict [list CONFIG.CONST_WIDTH {8} CONFIG.CONST_VAL {0}] [get_bd_cells xlconstant_0]
connect_bd_net [get_bd_pins blk_mem_gen_0/web] [get_bd_pins xlconstant_0/dout]
save_bd_design

set_property name debug_rom_addr [get_bd_ports addrb_0]
set_property name debug_rom_req [get_bd_ports enb_0]
set_property name debug_rom_rdata [get_bd_ports doutb_0]
set_property LEFT 31 [get_bd_ports /debug_rom_addr]


