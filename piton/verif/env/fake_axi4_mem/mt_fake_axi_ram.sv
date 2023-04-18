
`include "define.tmp.h"
`include "mc_define.h"
`include "noc_axi4_bridge_define.vh"


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


    logic      [`AXI4_ID_WIDTH - 1:0]  axi_ar_id;
    logic    [`AXI4_ADDR_WIDTH - 1:0]  axi_ar_addr;
    logic     [`AXI4_LEN_WIDTH - 1:0]  axi_ar_len;
    logic    [`AXI4_SIZE_WIDTH - 1:0]  axi_ar_size;
    logic   [`AXI4_BURST_WIDTH - 1:0]  axi_ar_burst;
    logic                              axi_ar_lock;
    logic   [`AXI4_CACHE_WIDTH - 1:0]  axi_ar_cache;
    logic    [`AXI4_PROT_WIDTH - 1:0]  axi_ar_prot;
    logic     [`AXI4_QOS_WIDTH - 1:0]  axi_ar_qos;    // none
    logic  [`AXI4_REGION_WIDTH - 1:0]  axi_ar_region; // none
    logic   [`AXI4_USER_WIDTH  - 1:0]  axi_ar_user;   // none
    logic                              axi_ar_valid;
    logic                              axi_ar_ready;

    logic      [`AXI4_ID_WIDTH - 1:0]  axi_aw_id;
    logic    [`AXI4_ADDR_WIDTH - 1:0]  axi_aw_addr;
    logic     [`AXI4_LEN_WIDTH - 1:0]  axi_aw_len;
    logic    [`AXI4_SIZE_WIDTH - 1:0]  axi_aw_size;
    logic   [`AXI4_BURST_WIDTH - 1:0]  axi_aw_burst;
    logic                              axi_aw_lock;
    logic   [`AXI4_CACHE_WIDTH - 1:0]  axi_aw_cache;
    logic    [`AXI4_PROT_WIDTH - 1:0]  axi_aw_prot;
    logic     [`AXI4_QOS_WIDTH - 1:0]  axi_aw_qos;    // none
    logic  [`AXI4_REGION_WIDTH - 1:0]  axi_aw_region; // none
    logic   [`AXI4_USER_WIDTH  - 1:0]  axi_aw_user;   // none
    logic                              axi_aw_valid;
    logic                              axi_aw_ready;

    logic      [`AXI4_ID_WIDTH - 1:0]  axi_w_id;      // none
    logic    [`AXI4_DATA_WIDTH - 1:0]  axi_w_data;
    logic    [`AXI4_STRB_WIDTH - 1:0]  axi_w_strb;
    logic                              axi_w_last;
    logic   [`AXI4_USER_WIDTH  - 1:0]  axi_w_user;    // none
    logic                              axi_w_valid;
    logic                              axi_w_ready;

    logic      [`AXI4_ID_WIDTH - 1:0]  axi_r_id;
    logic    [`AXI4_DATA_WIDTH - 1:0]  axi_r_data;
    logic    [`AXI4_RESP_WIDTH - 1:0]  axi_r_resp;
    logic                              axi_r_last;
    logic   [`AXI4_USER_WIDTH  - 1:0]  axi_r_user;    // none
    logic                              axi_r_valid;
    logic                              axi_r_ready;

    logic      [`AXI4_ID_WIDTH - 1:0]  axi_b_id;
    logic    [`AXI4_RESP_WIDTH - 1:0]  axi_b_resp;
    logic   [`AXI4_USER_WIDTH  - 1:0]  axi_b_user;    // none
    logic                              axi_b_valid;
    logic                              axi_b_ready;



    noc_axi4_bridge #(
        .SWAP_ENDIANESS     ( 1     )
    ) inst_noc_axi4_bridge_fake_mem     (
        .clk                ( clk   ),  
        .rst_n              ( rst_n ), 
        .uart_boot_en       ( 1'b0  ),
        .phy_init_done      ( 1'b1  ),
        .axi_id_deadlock    (       ),

        .src_bridge_vr_noc2_val ( noc_valid_in  ),
        .src_bridge_vr_noc2_dat ( noc_data_in   ),
        .src_bridge_vr_noc2_rdy ( noc_ready_in  ),

        .bridge_dst_vr_noc3_val ( noc_valid_out ),
        .bridge_dst_vr_noc3_dat ( noc_data_out  ),
        .bridge_dst_vr_noc3_rdy ( noc_ready_out ),

        .m_axi_awid     ( axi_aw_id     ),
        .m_axi_awaddr   ( axi_aw_addr   ),
        .m_axi_awlen    ( axi_aw_len    ),
        .m_axi_awsize   ( axi_aw_size   ),
        .m_axi_awburst  ( axi_aw_burst  ),
        .m_axi_awlock   ( axi_aw_lock   ),
        .m_axi_awcache  ( axi_aw_cache  ),
        .m_axi_awprot   ( axi_aw_prot   ),
        .m_axi_awqos    ( ),
        .m_axi_awregion ( ),
        .m_axi_awuser   ( ),
        .m_axi_awvalid  ( axi_aw_valid  ),
        .m_axi_awready  ( axi_aw_ready  ),

        .m_axi_wid      ( ),
        .m_axi_wdata    ( axi_w_data    ),
        .m_axi_wstrb    ( axi_w_strb    ),
        .m_axi_wlast    ( axi_w_last    ),
        .m_axi_wuser    ( ),
        .m_axi_wvalid   ( axi_w_valid   ),
        .m_axi_wready   ( axi_w_ready   ),

        .m_axi_bid      ( axi_b_id      ),
        .m_axi_bresp    ( axi_b_resp    ),
        .m_axi_buser    ( 'h0 ),            //zeros
        .m_axi_bvalid   ( axi_b_valid   ),
        .m_axi_bready   ( axi_b_ready   ),

        .m_axi_arid     ( axi_ar_id     ),
        .m_axi_araddr   ( axi_ar_addr   ),
        .m_axi_arlen    ( axi_ar_len    ),
        .m_axi_arsize   ( axi_ar_size   ),
        .m_axi_arburst  ( axi_ar_burst  ),
        .m_axi_arlock   ( axi_ar_lock   ),
        .m_axi_arcache  ( axi_ar_cache  ),
        .m_axi_arprot   ( axi_ar_prot   ),
        .m_axi_arqos    ( ),
        .m_axi_arregion ( ),
        .m_axi_aruser   ( ),
        .m_axi_arvalid  ( axi_ar_valid  ),
        .m_axi_arready  ( axi_ar_ready  ),

        .m_axi_rid      ( axi_r_id      ),
        .m_axi_rdata    ( axi_r_data    ),
        .m_axi_rresp    ( axi_r_resp    ),
        .m_axi_rlast    ( axi_r_last    ),
        .m_axi_ruser    ( 'h0 ),            //zeros
        .m_axi_rvalid   ( axi_r_valid   ),
        .m_axi_rready   ( axi_r_ready   )
    );


    axi_slave_ram #(
        // Width of address bus in bits
        .C_AXI_ADDR_WIDTH   (`AXI4_ADDR_WIDTH),
        // Width of data bus in bits
        .C_AXI_DATA_WIDTH   (`AXI4_DATA_WIDTH),
        // Width of wstrb (width of data bus in words)
        .STRB_WIDTH         (`AXI4_STRB_WIDTH),
        // Width of ID signal
        .ID_WIDTH           (`AXI4_ID_WIDTH),
        // Extra pipeline register on output
        .PIPELINE_OUTPUT    (0)
    ) inst_axi_slave_ram (
        .clk    (clk),
        .rst    (~rst_n),

        .s_axi_awid     ( axi_aw_id     ),
        .s_axi_awaddr   ( axi_aw_addr   ),
        .s_axi_awlen    ( axi_aw_len    ),
        .s_axi_awsize   ( axi_aw_size   ),
        .s_axi_awburst  ( axi_aw_burst  ),
        .s_axi_awlock   ( axi_aw_lock   ),
        .s_axi_awcache  ( axi_aw_cache  ),
        .s_axi_awprot   ( axi_aw_prot   ),
        .s_axi_awvalid  ( axi_aw_valid  ),
        .s_axi_awready  ( axi_aw_ready  ),

        .s_axi_wdata    ( axi_w_data    ),
        .s_axi_wstrb    ( axi_w_strb    ),
        .s_axi_wlast    ( axi_w_last    ),
        .s_axi_wvalid   ( axi_w_valid   ),
        .s_axi_wready   ( axi_w_ready   ),

        .s_axi_bid      ( axi_b_id      ),
        .s_axi_bresp    ( axi_b_resp    ),
        .s_axi_bvalid   ( axi_b_valid   ),
        .s_axi_bready   ( axi_b_ready   ),

        .s_axi_arid     ( axi_ar_id     ),
        .s_axi_araddr   ( axi_ar_addr   ),
        .s_axi_arlen    ( axi_ar_len    ),
        .s_axi_arsize   ( axi_ar_size   ),
        .s_axi_arburst  ( axi_ar_burst  ),
        .s_axi_arlock   ( axi_ar_lock   ),
        .s_axi_arcache  ( axi_ar_cache  ),
        .s_axi_arprot   ( axi_ar_prot   ),
        .s_axi_arvalid  ( axi_ar_valid  ),
        .s_axi_arready  ( axi_ar_ready  ),

        .s_axi_rid      ( axi_r_id      ),
        .s_axi_rdata    ( axi_r_data    ),
        .s_axi_rresp    ( axi_r_resp    ),
        .s_axi_rlast    ( axi_r_last    ),
        .s_axi_rvalid   ( axi_r_valid   ),
        .s_axi_rready   ( axi_r_ready   )
    );

endmodule 