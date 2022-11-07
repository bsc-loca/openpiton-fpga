
module ncmem_top (
	input mc_clk                  							,
	input mc_rstn                 							,
	input core_ref_clk             							,
	input core_ref_rstn	          							,
	input phy_init_done            							,
								   
	input  ncmem_in_val             					 	,		
	input  [`NOC_DATA_WIDTH-1:0] ncmem_in_data           	,
	output ncmem_in_rdy             					 	,
								   
	output ncmem_out_val							        ,	
	output [`NOC_DATA_WIDTH-1:0] ncmem_out_data	            ,
	input  ncmem_out_rdy								    ,
	
    output wire [`AXI4_ID_WIDTH     -1:0]    m_axi_awid  	,
    output wire [`AXI4_ADDR_WIDTH   -1:0]    m_axi_awaddr 	,
    output wire [`AXI4_LEN_WIDTH    -1:0]    m_axi_awlen  	,
    output wire [`AXI4_SIZE_WIDTH   -1:0]    m_axi_awsize 	,
    output wire [`AXI4_BURST_WIDTH  -1:0]    m_axi_awburst	,
    output wire                              m_axi_awlock 	,
    output wire [`AXI4_CACHE_WIDTH  -1:0]    m_axi_awcache	,
    output wire [`AXI4_PROT_WIDTH   -1:0]    m_axi_awprot 	,
    output wire [`AXI4_QOS_WIDTH    -1:0]    m_axi_awqos  	,
    output wire [`AXI4_REGION_WIDTH -1:0]    m_axi_awregion	,
    output wire [`AXI4_USER_WIDTH   -1:0]    m_axi_awuser	,
    output wire                              m_axi_awvalid	,
    input  wire                              m_axi_awready	,

    output wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_wid		,
    output wire  [`AXI4_DATA_WIDTH   -1:0]    m_axi_wdata	,
    output wire  [`AXI4_STRB_WIDTH   -1:0]    m_axi_wstrb	,
    output wire                               m_axi_wlast	,
    output wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_wuser	,
    output wire                               m_axi_wvalid	,
    input  wire                               m_axi_wready	,

    output wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_arid	,
    output wire  [`AXI4_ADDR_WIDTH   -1:0]    m_axi_araddr	,
    output wire  [`AXI4_LEN_WIDTH    -1:0]    m_axi_arlen	,
    output wire  [`AXI4_SIZE_WIDTH   -1:0]    m_axi_arsize	,
    output wire  [`AXI4_BURST_WIDTH  -1:0]    m_axi_arburst	,
    output wire                               m_axi_arlock	,
    output wire  [`AXI4_CACHE_WIDTH  -1:0]    m_axi_arcache	,
    output wire  [`AXI4_PROT_WIDTH   -1:0]    m_axi_arprot	,
    output wire  [`AXI4_QOS_WIDTH    -1:0]    m_axi_arqos	,
    output wire  [`AXI4_REGION_WIDTH -1:0]    m_axi_arregion,
    output wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_aruser	,
    output wire                               m_axi_arvalid	,
    input  wire                               m_axi_arready	,

    input  wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_rid		,
    input  wire  [`AXI4_DATA_WIDTH   -1:0]    m_axi_rdata	,
    input  wire  [`AXI4_RESP_WIDTH   -1:0]    m_axi_rresp	,
    input  wire                               m_axi_rlast	,
    input  wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_ruser	,
    input  wire                               m_axi_rvalid	,
    output wire                               m_axi_rready	,

    input  wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_bid		,
    input  wire  [`AXI4_RESP_WIDTH   -1:0]    m_axi_bresp	,
    input  wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_buser	,
    input  wire                               m_axi_bvalid	,
    output wire                               m_axi_bready
);


wire                                trans_fifo_val;
wire    [`NOC_DATA_WIDTH-1:0]       trans_fifo_data;
wire                                trans_fifo_rdy;

wire                                fifo_trans_val;
wire    [`NOC_DATA_WIDTH-1:0]       fifo_trans_data;
wire                                fifo_trans_rdy;


noc_bidir_afifo  mig_afifo  (
    .clk_1           (core_ref_clk      ),
    .rst_1           (core_ref_rstn     ),

    .clk_2           (mc_clk            ),
    .rst_2           (mc_rstn           ),

    // CPU --> MIG
    .flit_in_val_1   (ncmem_in_val      ),
    .flit_in_data_1  (ncmem_in_data     ),
    .flit_in_rdy_1   (ncmem_in_rdy      ),

    .flit_out_val_2  (fifo_trans_val    ),
    .flit_out_data_2 (fifo_trans_data   ),
    .flit_out_rdy_2  (fifo_trans_rdy    ),

    // MIG --> CPU
    .flit_in_val_2   (trans_fifo_val    ),
    .flit_in_data_2  (trans_fifo_data   ),
    .flit_in_rdy_2   (trans_fifo_rdy    ),

    .flit_out_val_1  (mc_flit_out_val   ),
    .flit_out_data_1 (mc_flit_out_data  ),
    .flit_out_rdy_1  (mc_flit_out_rdy   )
);
	
	localparam HBM_WIDTH = 256;

	noc_axi4_bridge #(
		`ifdef PITON_ARIANE
		.SWAP_ENDIANESS (1),
		`elsif PITON_LAGARTO
		.SWAP_ENDIANESS (1),
		`endif
		.AXI4_DAT_WIDTH_USED (HBM_WIDTH),
		.OUTSTAND_QUEUE_BRAM (0)
	)
		noc_axi4_bridge_ncmem  (
		.clk                (mc_clk  ),  
		.rst_n              (mc_rstn ), 
		.uart_boot_en       (1'b0),
		.phy_init_done      (phy_init_done),

		.src_bridge_vr_noc2_val(fifo_trans_val),
		.src_bridge_vr_noc2_dat(fifo_trans_data),
		.src_bridge_vr_noc2_rdy(fifo_trans_rdy),

		.bridge_dst_vr_noc3_val(trans_fifo_val),
		.bridge_dst_vr_noc3_dat(trans_fifo_data),
		.bridge_dst_vr_noc3_rdy(trans_fifo_rdy),

		.m_axi_awid(m_axi_awid),
		.m_axi_awaddr(m_axi_awaddr),
		.m_axi_awlen(m_axi_awlen),
		.m_axi_awsize(m_axi_awsize),
		.m_axi_awburst(m_axi_awburst),
		.m_axi_awlock(m_axi_awlock),
		.m_axi_awcache(m_axi_awcache),
		.m_axi_awprot(m_axi_awprot),
		.m_axi_awqos(m_axi_awqos),
		.m_axi_awregion(m_axi_awregion),
		.m_axi_awuser(m_axi_awuser),
		.m_axi_awvalid(m_axi_awvalid),
		.m_axi_awready(m_axi_awread),

		.m_axi_wid(m_axi_wid),
		.m_axi_wdata(m_axi_wdata),
		.m_axi_wstrb(m_axi_wstrb),
		.m_axi_wlast(m_axi_wlast),
		.m_axi_wuser(m_axi_wuser),
		.m_axi_wvalid(m_axi_wvalid),
		.m_axi_wready(m_axi_wready),

		.m_axi_bid(m_axi_bid),
		.m_axi_bresp(m_axi_bresp),
		.m_axi_buser(m_axi_buser),
		.m_axi_bvalid(m_axi_bvalid),
		.m_axi_bready(m_axi_bready),

		.m_axi_arid(m_axi_arid),
		.m_axi_araddr(m_axi_araddr),
		.m_axi_arlen(m_axi_arlen),
		.m_axi_arsize(m_axi_arsize),
		.m_axi_arburst(m_axi_arburst),
		.m_axi_arlock(m_axi_arlock),
		.m_axi_arcache(m_axi_arcache),
		.m_axi_arprot(m_axi_arprot),
		.m_axi_arqos(m_axi_arqos),
		.m_axi_arregion(m_axi_arregion),
		.m_axi_aruser(m_axi_aruser),
		.m_axi_arvalid(m_axi_arvalid),
		.m_axi_arready(m_axi_arready),

		.m_axi_rid(m_axi_rid),
		.m_axi_rdata(m_axi_rdata),
		.m_axi_rresp(m_axi_rresp),
		.m_axi_rlast(m_axi_rlast),
		.m_axi_ruser(m_axi_ruser),
		.m_axi_rvalid(m_axi_rvalid),
		.m_axi_rready(m_axi_rreadyy)
		);
		
endmodule		