
module ncmem_top #(


	parameter	AXI4_DAT_WIDTH_USED = 256
		
) (
	input clk                      ,
	input core_ref_clk             ,
	input sys_rst_n		           ,
	input mc_rst_n                 ,
	input phy_init_done            ,
								   ,
	input ncmem_in_val             ,
	input ncmem_in_data            ,
	input ncmem_in_rdy             ,
								   ,
	input ncmem_out_val            ,
	input ncmem_out_dat            ,
	input ncmem_out_rdy	           ,
	
	input m_axi_awid				,
	input m_axi_awaddr				,
	input m_axi_awlen				,
	input m_axi_awsize				,
	input m_axi_awburst				,
	input m_axi_awlock				,
	input m_axi_awcache				,
	input m_axi_awprot				,
	input m_axi_awqos				,
	input m_axi_awregion				,
	input m_axi_awuser				,
	input m_axi_awvalid				,
	input m_axi_awready				,
	
	input m_axi_wid				,
	input m_axi_wdata				,
	input m_axi_wstrb				,
	input m_axi_wlast				,
	input m_axi_wuser				,
	input m_axi_wvalid				,
	input m_axi_wready				,
	
	input m_axi_bid				,
	input m_axi_bresp				,
	input m_axi_buser				,
	input m_axi_bvalid				,
	input m_axi_bready				,
	
	input m_axi_arid				,
	input m_axi_araddr				,
	input m_axi_arlen				,
	input m_axi_arsize				,
	input m_axi_arburst				,
	input m_axi_arlock				,
	input m_axi_arcache				,
	input m_axi_arprot				,
	input m_axi_arqos				,
	input m_axi_arregion				,
	input m_axi_aruser				,
	input m_axi_arvalid				,
	input m_axi_arready				,
	
	input m_axi_rid				,
	input m_axi_rdata				,
	input m_axi_rresp				,
	input m_axi_rlast				,
	input m_axi_ruser				,
	input m_axi_rvalid				,
	input m_axi_rready				,
);
	
	
	
	localparam HBM_WIDTH = 256;
	noc_axi4_bridge #(
					  `ifdef PITON_ARIANE
						.SWAP_ENDIANESS (1),
					  `elsif PITON_LAGARTO
						.SWAP_ENDIANESS (1),
					  `endif
						.NOC2AXI_DESER_ORDER (1),
						.AXI4_DAT_WIDTH_USED (HBM_WIDTH)
					)
					 noc_axi4_bridge_ncmem  (
						.clk                (chipset_clk  ),  
						.rst_n              (chipset_rst_n), 
						.uart_boot_en       (1'b0),
						.phy_init_done      (1'b1),

						.src_bridge_vr_noc2_val(buf_ncmem_noc2_valid),
						.src_bridge_vr_noc2_dat(buf_ncmem_noc2_data),
						.src_bridge_vr_noc2_rdy(ncmem_buf_noc2_ready),

						.bridge_dst_vr_noc3_val(ncmem_buf_noc3_valid),
						.bridge_dst_vr_noc3_dat(ncmem_buf_noc3_data),
						.bridge_dst_vr_noc3_rdy(buf_ncmem_noc3_ready),

						.m_axi_awid(ncmem_axi_awid),
						.m_axi_awaddr(ncmem_axi_awaddr),
						.m_axi_awlen(ncmem_axi_awlen),
						.m_axi_awsize(ncmem_axi_awsize),
						.m_axi_awburst(ncmem_axi_awburst),
						.m_axi_awlock(ncmem_axi_awlock),
						.m_axi_awcache(ncmem_axi_awcache),
						.m_axi_awprot(ncmem_axi_awprot),
						.m_axi_awqos(ncmem_axi_awqos),
						.m_axi_awregion(ncmem_axi_awregion),
						.m_axi_awuser(ncmem_axi_awuser),
						.m_axi_awvalid(ncmem_axi_awvalid),
						.m_axi_awready(ncmem_axi_awready),

						.m_axi_wid(ncmem_axi_wid),
						.m_axi_wdata(ncmem_axi_wdata),
						.m_axi_wstrb(ncmem_axi_wstrb),
						.m_axi_wlast(ncmem_axi_wlast),
						.m_axi_wuser(ncmem_axi_wuser),
						.m_axi_wvalid(ncmem_axi_wvalid),
						.m_axi_wready(ncmem_axi_wready),

						.m_axi_bid(ncmem_axi_bid),
						.m_axi_bresp(ncmem_axi_bresp),
						.m_axi_buser(ncmem_axi_buser),
						.m_axi_bvalid(ncmem_axi_bvalid),
						.m_axi_bready(ncmem_axi_bready),

						.m_axi_arid(ncmem_axi_arid),
						.m_axi_araddr(ncmem_axi_araddr),
						.m_axi_arlen(ncmem_axi_arlen),
						.m_axi_arsize(ncmem_axi_arsize),
						.m_axi_arburst(ncmem_axi_arburst),
						.m_axi_arlock(ncmem_axi_arlock),
						.m_axi_arcache(ncmem_axi_arcache),
						.m_axi_arprot(ncmem_axi_arprot),
						.m_axi_arqos(ncmem_axi_arqos),
						.m_axi_arregion(ncmem_axi_arregion),
						.m_axi_aruser(ncmem_axi_aruser),
						.m_axi_arvalid(ncmem_axi_arvalid),
						.m_axi_arready(ncmem_axi_arready),

						.m_axi_rid(ncmem_axi_rid),
						.m_axi_rdata(ncmem_axi_rdata),
						.m_axi_rresp(ncmem_axi_rresp),
						.m_axi_rlast(ncmem_axi_rlast),
						.m_axi_ruser(ncmem_axi_ruser),
						.m_axi_rvalid(ncmem_axi_rvalid),
						.m_axi_rready(ncmem_axi_rready)
					 );