

module mt_fake_axi_ram (
    input wire                          clk,
    input wire                          rst_n,

    input wire                          noc_valid_in,
    input wire  [`NOC_DATA_WIDTH-1:0]   noc_data_in,
    output reg                          noc_ready_in,


    output                              noc_valid_out,
    output      [`NOC_DATA_WIDTH-1:0]   noc_data_out,
    input wire                          noc_ready_out
);


  logic      [C_M_AXI_ID_WIDTH - 1:0] axi_ar_id,
  logic    [C_M_AXI_ADDR_WIDTH - 1:0] axi_ar_addr,
  logic     [C_M_AXI_LEN_WIDTH - 1:0] axi_ar_len,
  logic    [C_M_AXI_SIZE_WIDTH - 1:0] axi_ar_size,
  logic  [C_M_AXI4_BURST_WIDTH - 1:0] axi_ar_burst,
  logic                               axi_ar_lock,
  logic  [C_M_AXI4_CACHE_WIDTH - 1:0] axi_ar_cache,
  logic   [C_M_AXI4_PROT_WIDTH - 1:0] axi_ar_prot,
  logic    [C_M_AXI4_QOS_WIDTH - 1:0] axi_ar_qos,
  logic [C_M_AXI4_REGION_WIDTH - 1:0] axi_ar_region,
  logic  [C_M_AXI4_USER_WIDTH  - 1:0] axi_ar_user,
  logic                               axi_ar_valid,
  logic                               axi_ar_ready,

  logic      [C_M_AXI_ID_WIDTH - 1:0] axi_aw_id,
  logic    [C_M_AXI_ADDR_WIDTH - 1:0] axi_aw_addr,
  logic     [C_M_AXI_LEN_WIDTH - 1:0] axi_aw_len,
  logic    [C_M_AXI_SIZE_WIDTH - 1:0] axi_aw_size,
  logic  [C_M_AXI4_BURST_WIDTH - 1:0] axi_aw_burst,
  logic                               axi_aw_lock,
  logic  [C_M_AXI4_CACHE_WIDTH - 1:0] axi_aw_cache,
  logic   [C_M_AXI4_PROT_WIDTH - 1:0] axi_aw_prot,
  logic    [C_M_AXI4_QOS_WIDTH - 1:0] axi_aw_qos,
  logic [C_M_AXI4_REGION_WIDTH - 1:0] axi_aw_region,
  logic  [C_M_AXI4_USER_WIDTH  - 1:0] axi_aw_user,
  logic                               axi_aw_valid,
  logic                               axi_aw_ready,

  logic      [C_M_AXI_ID_WIDTH - 1:0] axi_w_id,
  logic    [C_M_AXI_DATA_WIDTH - 1:0] axi_w_data,
  logic   [C_M_AXI4_STRB_WIDTH - 1:0] axi_w_strb,
  logic                               axi_w_last,
  logic  [C_M_AXI4_USER_WIDTH  - 1:0] axi_w_user,
  logic                               axi_w_valid,
  logic                               axi_w_ready,

  logic      [C_M_AXI_ID_WIDTH - 1:0] axi_r_id,
  logic    [C_M_AXI_DATA_WIDTH - 1:0] axi_r_data,
  logic   [C_M_AXI4_RESP_WIDTH - 1:0] axi_r_resp,
  logic                               axi_r_last,
  logic  [C_M_AXI4_USER_WIDTH  - 1:0] axi_r_user,
  logic                               axi_r_valid,
  logic                               axi_r_ready,

  logic      [C_M_AXI_ID_WIDTH - 1:0] axi_b_id,
  logic   [C_M_AXI4_RESP_WIDTH - 1:0] axi_b_resp,
  logic  [C_M_AXI4_USER_WIDTH  - 1:0] axi_b_user,
  logic                               axi_b_valid,
  logic                               axi_b_ready,


noc_axi4_bridge #(
    .SWAP_ENDIANESS (1),
    .NOC2AXI_DESER_ORDER (1)
) inst_noc_axi4_bridge_fake_mem (
    .clk                (clk),  
    .rst_n              (rst_n), 
    .uart_boot_en       (1'b0),
    .phy_init_done      (1'b1),
    .axi_id_deadlock    (            ),

    .src_bridge_vr_noc2_val(noc_valid_in),
    .src_bridge_vr_noc2_dat(noc_data_in),
    .src_bridge_vr_noc2_rdy(noc_ready_in),

    .bridge_dst_vr_noc3_val(noc_valid_out),
    .bridge_dst_vr_noc3_dat(noc_data_out),
    .bridge_dst_vr_noc3_rdy(noc_ready_out),

    .m_axi_awid     (sram_axi_awid),
    .m_axi_awaddr   (sram_axi_awaddr),
    .m_axi_awlen    (sram_axi_awlen),
    .m_axi_awsize   (sram_axi_awsize),
    .m_axi_awburst  (sram_axi_awburst),
    .m_axi_awlock   (sram_axi_awlock),
    .m_axi_awcache  (sram_axi_awcache),
    .m_axi_awprot   (sram_axi_awprot),
    .m_axi_awqos    (sram_axi_awqos),
    .m_axi_awregion (sram_axi_awregion),
    .m_axi_awuser   (sram_axi_awuser),
    .m_axi_awvalid  (sram_axi_awvalid),
    .m_axi_awready  (sram_axi_awready),

    .m_axi_wid      (sram_axi_wid),
    .m_axi_wdata    (sram_axi_wdata),
    .m_axi_wstrb    (sram_axi_wstrb),
    .m_axi_wlast    (sram_axi_wlast),
    .m_axi_wuser    (sram_axi_wuser),
    .m_axi_wvalid   (sram_axi_wvalid),
    .m_axi_wready   (sram_axi_wready),

    .m_axi_bid      (sram_axi_bid),
    .m_axi_bresp    (sram_axi_bresp),
    .m_axi_buser    (sram_axi_buser),
    .m_axi_bvalid   (sram_axi_bvalid),
    .m_axi_bready   (sram_axi_bready),

    .m_axi_arid     (sram_axi_arid),
    .m_axi_araddr   (sram_axi_araddr),
    .m_axi_arlen    (sram_axi_arlen),
    .m_axi_arsize   (sram_axi_arsize),
    .m_axi_arburst  (sram_axi_arburst),
    .m_axi_arlock   (sram_axi_arlock),
    .m_axi_arcache  (sram_axi_arcache),
    .m_axi_arprot   (sram_axi_arprot),
    .m_axi_arqos    (sram_axi_arqos),
    .m_axi_arregion (sram_axi_arregion),
    .m_axi_aruser   (sram_axi_aruser),
    .m_axi_arvalid  (sram_axi_arvalid),
    .m_axi_arready  (sram_axi_arready),

    .m_axi_rid      (sram_axi_rid),
    .m_axi_rdata    (sram_axi_rdata),
    .m_axi_rresp    (sram_axi_rresp),
    .m_axi_rlast    (sram_axi_rlast),
    .m_axi_ruser    (sram_axi_ruser),
    .m_axi_rvalid   (sram_axi_rvalid),
    .m_axi_rready   (sram_axi_rready)
);


axi_slave_ram #(
    // Width of address bus in bits
    .C_AXI_ADDR_WIDTH   (12), // just for random test
    // Width of data bus in bits
    .C_AXI_DATA_WIDTH   (128), // related to AxSIZE
    // Width of wstrb (width of data bus in words)
    .STRB_WIDTH         (C_AXI_DATA_WIDTH/8),
    // Width of ID signal
    .ID_WIDTH           (1),
    // Extra pipeline register on output
    .PIPELINE_OUTPUT    (0)
) inst_axi_slave_ram (
    .clk    (clk),
    .rst    (rst_n),

    .s_axi_awid     (),
    .s_axi_awaddr   (),
    .s_axi_awlen    (),
    .s_axi_awsize   (),
    .s_axi_awburst  (),
    .s_axi_awlock   (),
    .s_axi_awcache  (),
    .s_axi_awprot   (),
    .s_axi_awvalid  (),
    .s_axi_awready  (),

    .s_axi_wdata    (),
    .s_axi_wstrb    (),
    .s_axi_wlast    (),
    .s_axi_wvalid   (),
    .s_axi_wready   (),

    .s_axi_bid      (),
    .s_axi_bresp    (),
    .s_axi_bvalid   (),
    .s_axi_bready   (),

    .s_axi_arid     (),
    .s_axi_araddr   (),
    .s_axi_arlen    (),
    .s_axi_arsize   (),
    .s_axi_arburst  (),
    .s_axi_arlock   (),
    .s_axi_arcache  (),
    .s_axi_arprot   (),
    .s_axi_arvalid  (),
    .s_axi_arready  (),

    .s_axi_rid      (),
    .s_axi_rdata    (),
    .s_axi_rresp    (),
    .s_axi_rlast    (),
    .s_axi_rvalid   (),
    .s_axi_rready   ()
);

endmodule 