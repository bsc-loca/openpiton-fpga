// Modified by Barcelona Supercomputing Center on March 3rd, 2022
// ========== Copyright Header Begin ============================================
// Copyright (c) 2015 Princeton University
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of Princeton University nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ========== Copyright Header End ============================================

`include "define.tmp.h"
`include "mc_define.h"
`include "noc_axi4_bridge_define.vh"

module mc_top (
    input                           core_ref_clk,
`ifdef PITON_FPGA_MC_DDR3
    output                          mc_ui_clk_sync_rst,

    input   [`NOC_DATA_WIDTH-1:0]   mc_flit_in_data,
    input                           mc_flit_in_val,
    output                          mc_flit_in_rdy,

    output  [`NOC_DATA_WIDTH-1:0]   mc_flit_out_data,
    output                          mc_flit_out_val,
    input                           mc_flit_out_rdy,

  `ifdef PITON_EXTRA_MEMS
    input   [`PITON_EXTRA_MEMS * `NOC_DATA_WIDTH -1:0] mcx_flit_in_data,
    input   [`PITON_EXTRA_MEMS-1:0]                    mcx_flit_in_val,
    output  [`PITON_EXTRA_MEMS-1:0]                    mcx_flit_in_rdy,

    output  [`PITON_EXTRA_MEMS * `NOC_DATA_WIDTH -1:0] mcx_flit_out_data,
    output  [`PITON_EXTRA_MEMS-1:0]                    mcx_flit_out_val,
    input   [`PITON_EXTRA_MEMS-1:0]                    mcx_flit_out_rdy,
  `endif

    input                           uart_boot_en,
`ifdef PITONSYS_DDR4
    // directly feed in 250MHz ref clock
    `ifndef PITONSYS_MEEP
    input                           sys_clk_p,
    input                           sys_clk_n,
    `else
    input mc_clk,    
    `endif
    output                          ddr_act_n,
    output [`DDR3_BG_WIDTH-1:0]     ddr_bg,
`else // PITONSYS_DDR4
    input                           sys_clk,

    output                          ddr_cas_n,
    output                          ddr_ras_n,
    output                          ddr_we_n,
`endif // PITONSYS_DDR4

    output [`DDR3_ADDR_WIDTH-1:0]   ddr_addr,
    output [`DDR3_BA_WIDTH-1:0]     ddr_ba,
    output [`DDR3_CK_WIDTH-1:0]     ddr_ck_n,
    output [`DDR3_CK_WIDTH-1:0]     ddr_ck_p,
    output [`DDR3_CKE_WIDTH-1:0]    ddr_cke,
    output                          ddr_reset_n,
    inout  [`DDR3_DQ_WIDTH-1:0]     ddr_dq,
    inout  [`DDR3_DQS_WIDTH-1:0]    ddr_dqs_n,
    inout  [`DDR3_DQS_WIDTH-1:0]    ddr_dqs_p,
`ifndef NEXYSVIDEO_BOARD
    output [`DDR3_CS_WIDTH-1:0]     ddr_cs_n,
`endif // endif NEXYSVIDEO_BOARD
`ifdef PITONSYS_DDR4
`ifdef PITONSYS_PCIE
    input  [15:0] pci_express_x16_rxn,
    input  [15:0] pci_express_x16_rxp,
    output [15:0] pci_express_x16_txn,
    output [15:0] pci_express_x16_txp,  
    output [4:0] pcie_gpio,      
    input  pcie_perstn,
    input  pcie_refclk_n,
    input  pcie_refclk_p,
`endif // PITONSYS_PCIE
`ifdef XUPP3R_BOARD
    output                          ddr_parity,
`elsif ALVEOU280_BOARD

    `ifdef PITONSYS_MEEP
    input                           init_calib_complete,
    
    //
    	    // AXI interface
    output wire [`AXI4_ID_WIDTH     -1:0]    m_axi_awid,
    output wire [`AXI4_ADDR_WIDTH   -1:0]    m_axi_awaddr,
    output wire [`AXI4_LEN_WIDTH    -1:0]    m_axi_awlen,
    output wire [`AXI4_SIZE_WIDTH   -1:0]    m_axi_awsize,
    output wire [`AXI4_BURST_WIDTH  -1:0]    m_axi_awburst,
    output wire                              m_axi_awlock,
    output wire [`AXI4_CACHE_WIDTH  -1:0]    m_axi_awcache,
    output wire [`AXI4_PROT_WIDTH   -1:0]    m_axi_awprot,
    output wire [`AXI4_QOS_WIDTH    -1:0]    m_axi_awqos,
    output wire [`AXI4_REGION_WIDTH -1:0]    m_axi_awregion,
    output wire [`AXI4_USER_WIDTH   -1:0]    m_axi_awuser,
    output wire                              m_axi_awvalid,
    input  wire                              m_axi_awready,

    output wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_wid,
    output wire  [`AXI4_DATA_WIDTH   -1:0]    m_axi_wdata,
    output wire  [`AXI4_STRB_WIDTH   -1:0]    m_axi_wstrb,
    output wire                               m_axi_wlast,
    output wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_wuser,
    output wire                               m_axi_wvalid,
    input  wire                               m_axi_wready,

    output wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_arid,
    output wire  [`AXI4_ADDR_WIDTH   -1:0]    m_axi_araddr,
    output wire  [`AXI4_LEN_WIDTH    -1:0]    m_axi_arlen,
    output wire  [`AXI4_SIZE_WIDTH   -1:0]    m_axi_arsize,
    output wire  [`AXI4_BURST_WIDTH  -1:0]    m_axi_arburst,
    output wire                               m_axi_arlock,
    output wire  [`AXI4_CACHE_WIDTH  -1:0]    m_axi_arcache,
    output wire  [`AXI4_PROT_WIDTH   -1:0]    m_axi_arprot,
    output wire  [`AXI4_QOS_WIDTH    -1:0]    m_axi_arqos,
    output wire  [`AXI4_REGION_WIDTH -1:0]    m_axi_arregion,
    output wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_aruser,
    output wire                               m_axi_arvalid,
    input  wire                               m_axi_arready,

    input  wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_rid,
    input  wire  [`AXI4_DATA_WIDTH   -1:0]    m_axi_rdata,
    input  wire  [`AXI4_RESP_WIDTH   -1:0]    m_axi_rresp,
    input  wire                               m_axi_rlast,
    input  wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_ruser,
    input  wire                               m_axi_rvalid,
    output wire                               m_axi_rready,

    input  wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_bid,
    input  wire  [`AXI4_RESP_WIDTH   -1:0]    m_axi_bresp,
    input  wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_buser,
    input  wire                               m_axi_bvalid,
    output wire                               m_axi_bready,
    `else
    output                          ddr_parity,
    output                          hbm_cattrip,
    
    `endif
`else
    inout [`DDR3_DM_WIDTH-1:0]      ddr_dm,
`endif // XUPP3R_BOARD
`else // PITONSYS_DDR4
    output [`DDR3_DM_WIDTH-1:0]     ddr_dm,
`endif // PITONSYS_DDR4
    output [`DDR3_ODT_WIDTH-1:0]    ddr_odt,

    output                          init_calib_complete_out,
`endif // ifdef PITON_FPGA_MC_DDR3
    output                          mc_axi_deadlock,

`ifdef PITONSYS_MC_SRAM
    input   [`NOC_DATA_WIDTH-1:0]   sram_flit_in_data,
    input                           sram_flit_in_val,
    output                          sram_flit_in_rdy,

    output  [`NOC_DATA_WIDTH-1:0]   sram_flit_out_data,
    output                          sram_flit_out_val,
    input                           sram_flit_out_rdy,
`endif // PITONSYS_MC_SRAM

    input                           sys_rst_n
);

localparam HBM_WIDTH = 256;
localparam HBM_SIZE_LOG2 = 33; // 8GB
localparam HBM_MCS_LOG2  = 0;  //  0 to disable "interleaving", 5 for 32 MC channels to participate in "interleaving"
localparam HBM_MCS_ADDR  = 9;  // "interleaving" address position of MC channels in AXI address

`ifdef PITONSYS_MC_SRAM
 wire [`AXI4_ID_WIDTH     -1:0]     sram_axi_awid;
 wire [`AXI4_ADDR_WIDTH   -1:0]     sram_axi_awaddr;
 wire [`AXI4_LEN_WIDTH    -1:0]     sram_axi_awlen;
 wire [`AXI4_SIZE_WIDTH   -1:0]     sram_axi_awsize;
 wire [`AXI4_BURST_WIDTH  -1:0]     sram_axi_awburst;
 wire                               sram_axi_awlock;
 wire [`AXI4_CACHE_WIDTH  -1:0]     sram_axi_awcache;
 wire [`AXI4_PROT_WIDTH   -1:0]     sram_axi_awprot;
 wire [`AXI4_QOS_WIDTH    -1:0]     sram_axi_awqos;
 wire [`AXI4_REGION_WIDTH -1:0]     sram_axi_awregion;
 wire [`AXI4_USER_WIDTH   -1:0]     sram_axi_awuser;
 wire                               sram_axi_awvalid;
 wire                               sram_axi_awready;
 
 wire  [`AXI4_ID_WIDTH     -1:0]    sram_axi_wid;
 wire  [`AXI4_DATA_WIDTH   -1:0]    sram_axi_wdata;
 wire  [`AXI4_STRB_WIDTH   -1:0]    sram_axi_wstrb;
 wire                               sram_axi_wlast;
 wire  [`AXI4_USER_WIDTH   -1:0]    sram_axi_wuser;
 wire                               sram_axi_wvalid;
 wire                               sram_axi_wready;
 
 wire  [`AXI4_ID_WIDTH     -1:0]    sram_axi_arid;
 wire  [`AXI4_ADDR_WIDTH   -1:0]    sram_axi_araddr;
 wire  [`AXI4_LEN_WIDTH    -1:0]    sram_axi_arlen;
 wire  [`AXI4_SIZE_WIDTH   -1:0]    sram_axi_arsize;
 wire  [`AXI4_BURST_WIDTH  -1:0]    sram_axi_arburst;
 wire                               sram_axi_arlock;
 wire  [`AXI4_CACHE_WIDTH  -1:0]    sram_axi_arcache;
 wire  [`AXI4_PROT_WIDTH   -1:0]    sram_axi_arprot;
 wire  [`AXI4_QOS_WIDTH    -1:0]    sram_axi_arqos;
 wire  [`AXI4_REGION_WIDTH -1:0]    sram_axi_arregion;
 wire  [`AXI4_USER_WIDTH   -1:0]    sram_axi_aruser;
 wire                               sram_axi_arvalid;
 wire                               sram_axi_arready;
 
 wire  [`AXI4_ID_WIDTH     -1:0]    sram_axi_rid;
 wire  [`AXI4_DATA_WIDTH   -1:0]    sram_axi_rdata;
 wire  [`AXI4_RESP_WIDTH   -1:0]    sram_axi_rresp;
 wire                               sram_axi_rlast;
 wire  [`AXI4_USER_WIDTH   -1:0]    sram_axi_ruser;
 wire                               sram_axi_rvalid;
 wire                               sram_axi_rready;
 
 wire  [`AXI4_ID_WIDTH     -1:0]    sram_axi_bid;
 wire  [`AXI4_RESP_WIDTH   -1:0]    sram_axi_bresp;
 wire  [`AXI4_USER_WIDTH   -1:0]    sram_axi_buser;
 wire                               sram_axi_bvalid;
 wire                               sram_axi_bready;

 noc_axi4_bridge #(
    `ifdef PITON_ARIANE
      .SWAP_ENDIANESS (1),
    `elsif PITON_LAGARTO
      .SWAP_ENDIANESS (1),
    `endif
    `ifndef PITON_FPGA_MC_DDR3
      // applying the same parameters as for SDRAM in case it is absent
      `ifdef PITON_FPGA_MC_HBM
        .AXI4_DAT_WIDTH_USED (HBM_WIDTH),
      `else
        .OUTSTAND_QUEUE_BRAM (0),
      `endif
      .NUM_REQ_OUTSTANDING_LOG2 ($clog2(`PITON_NUM_TILES * 4)),
      // .NUM_REQ_MSHRID_LBIT (`L15_MSHR_ID_WIDTH),
      // .NUM_REQ_MSHRID_BITS (`L15_THREADID_WIDTH),
      .NUM_REQ_YTHREADS (`PITON_Y_TILES),
      .NUM_REQ_XTHREADS (`PITON_X_TILES),
    `endif
    .NOC2AXI_DESER_ORDER (1)
) noc_axi4_bridge_sram (
    .clk                (core_ref_clk),  
    .rst_n              (sys_rst_n), 
    .uart_boot_en       (1'b0),
    .phy_init_done      (1'b1),
    .axi_id_deadlock    (
`ifndef PITON_FPGA_MC_DDR3
                         mc_axi_deadlock // taking "alarm" signal from SRAM AXI in case SDRAM is absent
`endif
                        ),

    .src_bridge_vr_noc2_val(sram_flit_in_val),
    .src_bridge_vr_noc2_dat(sram_flit_in_data),
    .src_bridge_vr_noc2_rdy(sram_flit_in_rdy),

    .bridge_dst_vr_noc3_val(sram_flit_out_val),
    .bridge_dst_vr_noc3_dat(sram_flit_out_data),
    .bridge_dst_vr_noc3_rdy(sram_flit_out_rdy),

    .m_axi_awid(sram_axi_awid),
    .m_axi_awaddr(sram_axi_awaddr),
    .m_axi_awlen(sram_axi_awlen),
    .m_axi_awsize(sram_axi_awsize),
    .m_axi_awburst(sram_axi_awburst),
    .m_axi_awlock(sram_axi_awlock),
    .m_axi_awcache(sram_axi_awcache),
    .m_axi_awprot(sram_axi_awprot),
    .m_axi_awqos(sram_axi_awqos),
    .m_axi_awregion(sram_axi_awregion),
    .m_axi_awuser(sram_axi_awuser),
    .m_axi_awvalid(sram_axi_awvalid),
    .m_axi_awready(sram_axi_awready),

    .m_axi_wid(sram_axi_wid),
    .m_axi_wdata(sram_axi_wdata),
    .m_axi_wstrb(sram_axi_wstrb),
    .m_axi_wlast(sram_axi_wlast),
    .m_axi_wuser(sram_axi_wuser),
    .m_axi_wvalid(sram_axi_wvalid),
    .m_axi_wready(sram_axi_wready),

    .m_axi_bid(sram_axi_bid),
    .m_axi_bresp(sram_axi_bresp),
    .m_axi_buser(sram_axi_buser),
    .m_axi_bvalid(sram_axi_bvalid),
    .m_axi_bready(sram_axi_bready),

    .m_axi_arid(sram_axi_arid),
    .m_axi_araddr(sram_axi_araddr),
    .m_axi_arlen(sram_axi_arlen),
    .m_axi_arsize(sram_axi_arsize),
    .m_axi_arburst(sram_axi_arburst),
    .m_axi_arlock(sram_axi_arlock),
    .m_axi_arcache(sram_axi_arcache),
    .m_axi_arprot(sram_axi_arprot),
    .m_axi_arqos(sram_axi_arqos),
    .m_axi_arregion(sram_axi_arregion),
    .m_axi_aruser(sram_axi_aruser),
    .m_axi_arvalid(sram_axi_arvalid),
    .m_axi_arready(sram_axi_arready),

    .m_axi_rid(sram_axi_rid),
    .m_axi_rdata(sram_axi_rdata),
    .m_axi_rresp(sram_axi_rresp),
    .m_axi_rlast(sram_axi_rlast),
    .m_axi_ruser(sram_axi_ruser),
    .m_axi_rvalid(sram_axi_rvalid),
    .m_axi_rready(sram_axi_rready)
);

`ifndef PITON_FPGA_MC_DDR3
  // SRAM AXI stub for simulation
  assign sram_axi_awready = 1'b1;
  assign sram_axi_wready  = 1'b1;
  assign sram_axi_arready = 1'b1;

  localparam RVALID_DELAY_LOG = 0;
  reg [RVALID_DELAY_LOG:0] sram_axi_rvalid_cnt;
  reg sram_axi_rvalid_en;
  reg [`AXI4_ID_WIDTH-1:0] sram_axi_rid_reg;
  always @(posedge core_ref_clk)
    if (~sys_rst_n) begin
      sram_axi_rvalid_cnt <= {(RVALID_DELAY_LOG+1){1'b0}};
      sram_axi_rvalid_en <= 1'b0;
      sram_axi_rid_reg <= `AXI4_ID_WIDTH'h0;
    end
    else begin 
           if (sram_axi_rvalid) begin
             if (sram_axi_rready) begin
               sram_axi_rvalid_cnt <= {(RVALID_DELAY_LOG+1){1'b0}};
               sram_axi_rvalid_en <= 1'b0;
             end
           end
           else if (sram_axi_rvalid_en) sram_axi_rvalid_cnt <= sram_axi_rvalid_cnt+1;
           if (sram_axi_arvalid) begin
             sram_axi_rvalid_cnt <= {{RVALID_DELAY_LOG{1'b0}}, 1'b1};
             sram_axi_rvalid_en <= 1'b1;
             sram_axi_rid_reg <= sram_axi_arid;
           end
    end
  assign sram_axi_rvalid = sram_axi_rvalid_cnt[RVALID_DELAY_LOG];
  assign sram_axi_rid    = sram_axi_rid_reg;
  assign sram_axi_rdata  = {(`AXI4_DATA_WIDTH/64/2+1){64'hDEADBEEFFEEDC0DE}};
  assign sram_axi_rresp  = 2'h0;
  assign sram_axi_rlast  = sram_axi_rvalid;
  assign sram_axi_ruser  = `AXI4_USER_WIDTH'h0;

  localparam BVALID_DELAY_LOG = 0;
  reg [BVALID_DELAY_LOG:0] sram_axi_bvalid_cnt;
  reg sram_axi_bvalid_en;
  reg [`AXI4_ID_WIDTH-1:0] sram_axi_bid_reg;
  always @(posedge core_ref_clk)
    if (~sys_rst_n) begin
      sram_axi_bvalid_cnt <= {(BVALID_DELAY_LOG+1){1'b0}};
      sram_axi_bvalid_en <= 1'b0;
      sram_axi_bid_reg <= `AXI4_ID_WIDTH'h0;
    end
    else begin
           if (sram_axi_bvalid) begin
             if (sram_axi_bready) begin
               sram_axi_bvalid_cnt <= {(BVALID_DELAY_LOG+1){1'b0}};
               sram_axi_bvalid_en <= 1'b0;
             end
           end
           else if (sram_axi_bvalid_en) sram_axi_bvalid_cnt <= sram_axi_bvalid_cnt+1;
           if (sram_axi_wvalid & sram_axi_wlast) begin
             sram_axi_bvalid_cnt <= {{BVALID_DELAY_LOG{1'b0}}, 1'b1};
             sram_axi_bvalid_en <= 1'b1;
             sram_axi_bid_reg <= sram_axi_wid;
           end
    end
  assign sram_axi_bvalid  = sram_axi_bvalid_cnt[BVALID_DELAY_LOG];
  assign sram_axi_bid     = sram_axi_bid_reg;
  assign sram_axi_bresp   = 2'h0;
  assign sram_axi_buser   = `AXI4_USER_WIDTH'h0;

`endif // `ifndef PITON_FPGA_MC_DDR3
`endif // `ifdef  PITONSYS_MC_SRAM


`ifdef PITON_FPGA_MC_DDR3

reg     [31:0]                      delay_cnt;
reg                                 ui_clk_syn_rst_delayed;
`ifndef PITONSYS_MEEP
wire                                init_calib_complete;
`endif
wire                                afifo_rst_1;
wire                                afifo_rst_2;

`ifndef PITONSYS_AXI4_MEM
 wire                               app_en;
 wire    [`MIG_APP_CMD_WIDTH-1 :0]  app_cmd;
 wire    [`MIG_APP_ADDR_WIDTH-1:0]  app_addr;
 wire                               app_rdy;
 wire                               app_wdf_wren;
 wire    [`MIG_APP_DATA_WIDTH-1:0]  app_wdf_data;
 wire    [`MIG_APP_MASK_WIDTH-1:0]  app_wdf_mask;
 wire                               app_wdf_rdy;
 wire                               app_wdf_end;
 wire    [`MIG_APP_DATA_WIDTH-1:0]  app_rd_data;
 wire                               app_rd_data_end;
 wire                               app_rd_data_valid;

 wire                               core_app_en;
 wire    [`MIG_APP_CMD_WIDTH-1 :0]  core_app_cmd;
 wire    [`MIG_APP_ADDR_WIDTH-1:0]  core_app_addr;
 wire                               core_app_rdy;
 wire                               core_app_wdf_wren;
 wire    [`MIG_APP_DATA_WIDTH-1:0]  core_app_wdf_data;
 wire    [`MIG_APP_MASK_WIDTH-1:0]  core_app_wdf_mask;
 wire                               core_app_wdf_rdy;
 wire                               core_app_wdf_end;
 wire    [`MIG_APP_DATA_WIDTH-1:0]  core_app_rd_data;
 wire                               core_app_rd_data_end;
 wire                               core_app_rd_data_valid;

`ifdef PITONSYS_MEM_ZEROER
wire                                zero_app_en;
wire    [`MIG_APP_CMD_WIDTH-1 :0]   zero_app_cmd;
wire    [`MIG_APP_ADDR_WIDTH-1:0]   zero_app_addr;
wire                                zero_app_wdf_wren;
wire    [`MIG_APP_DATA_WIDTH-1:0]   zero_app_wdf_data;
wire    [`MIG_APP_MASK_WIDTH-1:0]   zero_app_wdf_mask;
wire                                zero_app_wdf_end;
wire                                init_calib_complete_zero;
`endif

 wire                                noc_mig_bridge_rst;
 wire                                noc_mig_bridge_init_done;

`else // PITONSYS_AXI4_MEM

// AXI4 interface
`ifndef PITONSYS_MEEP
 wire [`AXI4_ID_WIDTH     -1:0]     m_axi_awid;
 wire [`AXI4_ADDR_WIDTH   -1:0]     m_axi_awaddr;
 wire [`AXI4_LEN_WIDTH    -1:0]     m_axi_awlen;
 wire [`AXI4_SIZE_WIDTH   -1:0]     m_axi_awsize;
 wire [`AXI4_BURST_WIDTH  -1:0]     m_axi_awburst;
 wire                               m_axi_awlock;
 wire [`AXI4_CACHE_WIDTH  -1:0]     m_axi_awcache;
 wire [`AXI4_PROT_WIDTH   -1:0]     m_axi_awprot;
 wire [`AXI4_QOS_WIDTH    -1:0]     m_axi_awqos;
 wire [`AXI4_REGION_WIDTH -1:0]     m_axi_awregion;
 wire [`AXI4_USER_WIDTH   -1:0]     m_axi_awuser;
 wire                               m_axi_awvalid;
 wire                               m_axi_awready;
 
 wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_wid;
 wire  [`AXI4_DATA_WIDTH   -1:0]    m_axi_wdata;
 wire  [`AXI4_STRB_WIDTH   -1:0]    m_axi_wstrb;
 wire                               m_axi_wlast;
 wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_wuser;
 wire                               m_axi_wvalid;
 wire                               m_axi_wready;
 
 wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_arid;
 wire  [`AXI4_ADDR_WIDTH   -1:0]    m_axi_araddr;
 wire  [`AXI4_LEN_WIDTH    -1:0]    m_axi_arlen;
 wire  [`AXI4_SIZE_WIDTH   -1:0]    m_axi_arsize;
 wire  [`AXI4_BURST_WIDTH  -1:0]    m_axi_arburst;
 wire                               m_axi_arlock;
 wire  [`AXI4_CACHE_WIDTH  -1:0]    m_axi_arcache;
 wire  [`AXI4_PROT_WIDTH   -1:0]    m_axi_arprot;
 wire  [`AXI4_QOS_WIDTH    -1:0]    m_axi_arqos;
 wire  [`AXI4_REGION_WIDTH -1:0]    m_axi_arregion;
 wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_aruser;
 wire                               m_axi_arvalid;
 wire                               m_axi_arready;
 
 wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_rid;
 wire  [`AXI4_DATA_WIDTH   -1:0]    m_axi_rdata;
 wire  [`AXI4_RESP_WIDTH   -1:0]    m_axi_rresp;
 wire                               m_axi_rlast;
 wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_ruser;
 wire                               m_axi_rvalid;
 wire                               m_axi_rready;
 
 wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_bid;
 wire  [`AXI4_RESP_WIDTH   -1:0]    m_axi_bresp;
 wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_buser;
 wire                               m_axi_bvalid;
 wire                               m_axi_bready;
`endif
wire [`AXI4_ID_WIDTH     -1:0]     core_axi_awid;
wire [`AXI4_ADDR_WIDTH   -1:0]     core_axi_awaddr;
wire [`AXI4_LEN_WIDTH    -1:0]     core_axi_awlen;
wire [`AXI4_SIZE_WIDTH   -1:0]     core_axi_awsize;
wire [`AXI4_BURST_WIDTH  -1:0]     core_axi_awburst;
wire                               core_axi_awlock;
wire [`AXI4_CACHE_WIDTH  -1:0]     core_axi_awcache;
wire [`AXI4_PROT_WIDTH   -1:0]     core_axi_awprot;
wire [`AXI4_QOS_WIDTH    -1:0]     core_axi_awqos;
wire [`AXI4_REGION_WIDTH -1:0]     core_axi_awregion;
wire [`AXI4_USER_WIDTH   -1:0]     core_axi_awuser;
wire                               core_axi_awvalid;
wire                               core_axi_awready;

wire  [`AXI4_ID_WIDTH     -1:0]    core_axi_wid;
wire  [`AXI4_DATA_WIDTH   -1:0]    core_axi_wdata;
wire  [`AXI4_STRB_WIDTH   -1:0]    core_axi_wstrb;
wire                               core_axi_wlast;
wire  [`AXI4_USER_WIDTH   -1:0]    core_axi_wuser;
wire                               core_axi_wvalid;
wire                               core_axi_wready;

wire  [`AXI4_ID_WIDTH     -1:0]    core_axi_arid;
wire  [`AXI4_ADDR_WIDTH   -1:0]    core_axi_araddr;
wire  [`AXI4_LEN_WIDTH    -1:0]    core_axi_arlen;
wire  [`AXI4_SIZE_WIDTH   -1:0]    core_axi_arsize;
wire  [`AXI4_BURST_WIDTH  -1:0]    core_axi_arburst;
wire                               core_axi_arlock;
wire  [`AXI4_CACHE_WIDTH  -1:0]    core_axi_arcache;
wire  [`AXI4_PROT_WIDTH   -1:0]    core_axi_arprot;
wire  [`AXI4_QOS_WIDTH    -1:0]    core_axi_arqos;
wire  [`AXI4_REGION_WIDTH -1:0]    core_axi_arregion;
wire  [`AXI4_USER_WIDTH   -1:0]    core_axi_aruser;
wire                               core_axi_arvalid;
wire                               core_axi_arready;

wire  [`AXI4_ID_WIDTH     -1:0]    core_axi_rid;
wire  [`AXI4_DATA_WIDTH   -1:0]    core_axi_rdata;
wire  [`AXI4_RESP_WIDTH   -1:0]    core_axi_rresp;
wire                               core_axi_rlast;
wire  [`AXI4_USER_WIDTH   -1:0]    core_axi_ruser;
wire                               core_axi_rvalid;
wire                               core_axi_rready;

wire  [`AXI4_ID_WIDTH     -1:0]    core_axi_bid;
wire  [`AXI4_RESP_WIDTH   -1:0]    core_axi_bresp;
wire  [`AXI4_USER_WIDTH   -1:0]    core_axi_buser;
wire                               core_axi_bvalid;
wire                               core_axi_bready;

`ifdef PITONSYS_MEM_ZEROER
 wire [`AXI4_ID_WIDTH     -1:0]     zeroer_axi_awid;
 wire [`AXI4_ADDR_WIDTH   -1:0]     zeroer_axi_awaddr;
 wire [`AXI4_LEN_WIDTH    -1:0]     zeroer_axi_awlen;
 wire [`AXI4_SIZE_WIDTH   -1:0]     zeroer_axi_awsize;
 wire [`AXI4_BURST_WIDTH  -1:0]     zeroer_axi_awburst;
 wire                               zeroer_axi_awlock;
 wire [`AXI4_CACHE_WIDTH  -1:0]     zeroer_axi_awcache;
 wire [`AXI4_PROT_WIDTH   -1:0]     zeroer_axi_awprot;
 wire [`AXI4_QOS_WIDTH    -1:0]     zeroer_axi_awqos;
 wire [`AXI4_REGION_WIDTH -1:0]     zeroer_axi_awregion;
 wire [`AXI4_USER_WIDTH   -1:0]     zeroer_axi_awuser;
 wire                               zeroer_axi_awvalid;
 wire                               zeroer_axi_awready;
 
 wire  [`AXI4_ID_WIDTH     -1:0]    zeroer_axi_wid;
 wire  [`AXI4_DATA_WIDTH   -1:0]    zeroer_axi_wdata;
 wire  [`AXI4_STRB_WIDTH   -1:0]    zeroer_axi_wstrb;
 wire                               zeroer_axi_wlast;
 wire  [`AXI4_USER_WIDTH   -1:0]    zeroer_axi_wuser;
 wire                               zeroer_axi_wvalid;
 wire                               zeroer_axi_wready;
 
 wire  [`AXI4_ID_WIDTH     -1:0]    zeroer_axi_arid;
 wire  [`AXI4_ADDR_WIDTH   -1:0]    zeroer_axi_araddr;
 wire  [`AXI4_LEN_WIDTH    -1:0]    zeroer_axi_arlen;
 wire  [`AXI4_SIZE_WIDTH   -1:0]    zeroer_axi_arsize;
 wire  [`AXI4_BURST_WIDTH  -1:0]    zeroer_axi_arburst;
 wire                               zeroer_axi_arlock;
 wire  [`AXI4_CACHE_WIDTH  -1:0]    zeroer_axi_arcache;
 wire  [`AXI4_PROT_WIDTH   -1:0]    zeroer_axi_arprot;
 wire  [`AXI4_QOS_WIDTH    -1:0]    zeroer_axi_arqos;
 wire  [`AXI4_REGION_WIDTH -1:0]    zeroer_axi_arregion;
 wire  [`AXI4_USER_WIDTH   -1:0]    zeroer_axi_aruser;
 wire                               zeroer_axi_arvalid;
 wire                               zeroer_axi_arready;
 
 wire  [`AXI4_ID_WIDTH     -1:0]    zeroer_axi_rid;
 wire  [`AXI4_DATA_WIDTH   -1:0]    zeroer_axi_rdata;
 wire  [`AXI4_RESP_WIDTH   -1:0]    zeroer_axi_rresp;
 wire                               zeroer_axi_rlast;
 wire  [`AXI4_USER_WIDTH   -1:0]    zeroer_axi_ruser;
 wire                               zeroer_axi_rvalid;
 wire                               zeroer_axi_rready;
 
 wire  [`AXI4_ID_WIDTH     -1:0]    zeroer_axi_bid;
 wire  [`AXI4_RESP_WIDTH   -1:0]    zeroer_axi_bresp;
 wire  [`AXI4_USER_WIDTH   -1:0]    zeroer_axi_buser;
 wire                               zeroer_axi_bvalid;
 wire                               zeroer_axi_bready;
 
 wire                               init_calib_complete_zero;
`endif

wire                               noc_axi4_bridge_rst;
wire                               noc_axi4_bridge_init_done;

`endif // PITONSYS_AXI4_MEM

wire                                app_sr_req;
wire                                app_ref_req;
wire                                app_zq_req;
wire                                app_sr_active;
wire                                app_ref_ack;
wire                                app_zq_ack;
wire                                ui_clk;
wire                                ui_clk_sync_rst;


wire                                trans_fifo_val;
wire    [`NOC_DATA_WIDTH-1:0]       trans_fifo_data;
wire                                trans_fifo_rdy;

wire                                fifo_trans_val;
wire    [`NOC_DATA_WIDTH-1:0]       fifo_trans_data;
wire                                fifo_trans_rdy;

reg                                 afifo_ui_rst_r;
reg                                 afifo_ui_rst_r_r;

reg                                 ui_clk_sync_rst_r;
reg                                 ui_clk_sync_rst_r_r;

// needed for correct rst of async fifo
always @(posedge core_ref_clk) begin
    if (~sys_rst_n)
        delay_cnt <= 32'h1ff;
    else begin
        delay_cnt <= (delay_cnt != 0) & ~ui_clk_sync_rst_r_r ? delay_cnt - 1 : delay_cnt;
    end
end

always @(posedge core_ref_clk) begin
    if (ui_clk_sync_rst)
        ui_clk_syn_rst_delayed <= 1'b1;
    else begin
        ui_clk_syn_rst_delayed <= delay_cnt != 0;
    end
end

assign mc_ui_clk_sync_rst   = ui_clk_syn_rst_delayed;

assign afifo_rst_1 = ui_clk_syn_rst_delayed;


always @(posedge ui_clk) begin
    afifo_ui_rst_r <= afifo_rst_1;
    afifo_ui_rst_r_r <= afifo_ui_rst_r;
end


always @(posedge core_ref_clk) begin
    ui_clk_sync_rst_r   <= ui_clk_sync_rst;
    ui_clk_sync_rst_r_r <= ui_clk_sync_rst_r;
end

assign afifo_rst_2 = afifo_ui_rst_r_r | ui_clk_sync_rst;

// TODO: zeroed based on example simulation of MIG7
// not used for DDR4 MIG
assign app_ref_req = 1'b0;
assign app_sr_req = 1'b0;
assign app_zq_req = 1'b0;

`ifndef PITONSYS_AXI4_MEM
`ifdef PITONSYS_MEM_ZEROER
 assign app_en                   = zero_app_en;
 assign app_cmd                  = zero_app_cmd;
 assign app_addr                 = zero_app_addr;
 assign app_wdf_wren             = zero_app_wdf_wren;
 assign app_wdf_data             = zero_app_wdf_data;
 assign app_wdf_mask             = zero_app_wdf_mask;
 assign app_wdf_end              = zero_app_wdf_end;
 assign noc_mig_bridge_rst       = ui_clk_sync_rst & ~init_calib_complete_zero;
 assign noc_mig_bridge_init_done = init_calib_complete_zero;
 assign init_calib_complete_out  = init_calib_complete_zero & ~ui_clk_syn_rst_delayed;
 `else
 assign app_en                   = core_app_en;
 assign app_cmd                  = core_app_cmd;
 assign app_addr                 = core_app_addr;
 assign app_wdf_wren             = core_app_wdf_wren;
 assign app_wdf_data             = core_app_wdf_data;
 assign app_wdf_mask             = core_app_wdf_mask;
 assign app_wdf_end              = core_app_wdf_end;
 assign noc_mig_bridge_rst       = ui_clk_sync_rst;
 assign noc_mig_bridge_init_done = init_calib_complete;
 assign init_calib_complete_out  = init_calib_complete & ~ui_clk_syn_rst_delayed;
 `endif
 assign core_app_rdy             = app_rdy;
 assign core_app_wdf_rdy         = app_wdf_rdy;
 assign core_app_rd_data_valid   = app_rd_data_valid;
 assign core_app_rd_data_end     = app_rd_data_end;
 assign core_app_rd_data         = app_rd_data;

`else //ifndef PITONSYS_AXI4_MEM
assign noc_mig_bridge_rst       = ui_clk_sync_rst;
assign noc_mig_bridge_init_done = init_calib_complete;
assign init_calib_complete_out  = init_calib_complete & ~ui_clk_syn_rst_delayed;
`endif

noc_bidir_afifo  mig_afifo  (
    .clk_1           (core_ref_clk      ),
    .rst_1           (afifo_rst_1       ),

    .clk_2           (ui_clk            ),
    .rst_2           (afifo_rst_2       ),

    // CPU --> MIG
    .flit_in_val_1   (mc_flit_in_val    ),
    .flit_in_data_1  (mc_flit_in_data   ),
    .flit_in_rdy_1   (mc_flit_in_rdy    ),

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


`ifndef PITONSYS_AXI4_MEM

`ifdef PITONSYS_MEM_ZEROER
 assign app_en                   = zero_app_en;
 assign app_cmd                  = zero_app_cmd;
 assign app_addr                 = zero_app_addr;
 assign app_wdf_wren             = zero_app_wdf_wren;
 assign app_wdf_data             = zero_app_wdf_data;
 assign app_wdf_mask             = zero_app_wdf_mask;
 assign app_wdf_end              = zero_app_wdf_end;
 assign noc_mig_bridge_rst       = ui_clk_sync_rst & ~init_calib_complete_zero;
 assign noc_mig_bridge_init_done = init_calib_complete_zero;
 assign init_calib_complete_out  = init_calib_complete_zero & ~ui_clk_syn_rst_delayed;
`else
 assign app_en                   = core_app_en;
 assign app_cmd                  = core_app_cmd;
 assign app_addr                 = core_app_addr;
 assign app_wdf_wren             = core_app_wdf_wren;
 assign app_wdf_data             = core_app_wdf_data;
 assign app_wdf_mask             = core_app_wdf_mask;
 assign app_wdf_end              = core_app_wdf_end;
 assign noc_mig_bridge_rst       = ui_clk_sync_rst;
 assign noc_mig_bridge_init_done = init_calib_complete;
 assign init_calib_complete_out  = init_calib_complete & ~ui_clk_syn_rst_delayed;
`endif
 assign core_app_rdy             = app_rdy;
 assign core_app_wdf_rdy         = app_wdf_rdy;
 assign core_app_rd_data_valid   = app_rd_data_valid;
 assign core_app_rd_data_end     = app_rd_data_end;
 assign core_app_rd_data         = app_rd_data;

 noc_mig_bridge    #  (
    .MIG_APP_ADDR_WIDTH (`MIG_APP_ADDR_WIDTH        ),
    .MIG_APP_DATA_WIDTH (`MIG_APP_DATA_WIDTH        )
)   noc_mig_bridge   (
    .clk                (ui_clk                     ),  // from MC
    .rst                (noc_mig_bridge_rst         ),  // from MC

    .uart_boot_en       (uart_boot_en               ),

    .flit_in            (fifo_trans_data            ),
    .flit_in_val        (fifo_trans_val             ),
    .flit_in_rdy        (fifo_trans_rdy             ),
    .flit_out           (trans_fifo_data            ),
    .flit_out_val       (trans_fifo_val             ),
    .flit_out_rdy       (trans_fifo_rdy             ),

    .app_rdy            (core_app_rdy               ),
    .app_wdf_rdy        (core_app_wdf_rdy           ),
    .app_rd_data        (core_app_rd_data           ),
    .app_rd_data_end    (core_app_rd_data_end       ),
    .app_rd_data_valid  (core_app_rd_data_valid     ),
    .phy_init_done      (noc_mig_bridge_init_done   ),

    .app_wdf_wren_reg   (core_app_wdf_wren          ),
    .app_wdf_data_out   (core_app_wdf_data          ),
    .app_wdf_mask_out   (core_app_wdf_mask          ),
    .app_wdf_end_out    (core_app_wdf_end           ),
    .app_addr_out       (core_app_addr              ),
    .app_en_reg         (core_app_en                ),
    .app_cmd_reg        (core_app_cmd               )
);

`ifdef PITONSYS_MEM_ZEROER
 memory_zeroer #(
    .MIG_APP_ADDR_WIDTH (`MIG_APP_ADDR_WIDTH        ),
    .MIG_APP_DATA_WIDTH (`MIG_APP_DATA_WIDTH        )
)    memory_zeroer (
    .clk                        (ui_clk                     ),
    .rst_n                      (~ui_clk_sync_rst           ),

    .init_calib_complete_in     (init_calib_complete        ),
    .init_calib_complete_out    (init_calib_complete_zero   ),

    .app_rdy_in                 (core_app_rdy               ),
    .app_wdf_rdy_in             (core_app_wdf_rdy           ),
    
    .app_wdf_wren_in            (core_app_wdf_wren          ),
    .app_wdf_data_in            (core_app_wdf_data          ),
    .app_wdf_mask_in            (core_app_wdf_mask          ),
    .app_wdf_end_in             (core_app_wdf_end           ),
    .app_addr_in                (core_app_addr              ),
    .app_en_in                  (core_app_en                ),
    .app_cmd_in                 (core_app_cmd               ),

    .app_wdf_wren_out           (zero_app_wdf_wren          ),
    .app_wdf_data_out           (zero_app_wdf_data          ),
    .app_wdf_mask_out           (zero_app_wdf_mask          ),
    .app_wdf_end_out            (zero_app_wdf_end           ),
    .app_addr_out               (zero_app_addr              ),
    .app_en_out                 (zero_app_en                ),
    .app_cmd_out                (zero_app_cmd               )
);
`endif

`ifdef PITONSYS_DDR4

// reserved, tie to 0
 wire app_hi_pri;
 assign app_hi_pri = 1'b0;
  
ddr4_0 i_ddr4_0 (
  .sys_rst                   ( ~sys_rst_n                ),
  .c0_sys_clk_p              ( sys_clk_p                 ),
  .c0_sys_clk_n              ( sys_clk_n                 ),
  .dbg_clk                   (                           ), // not used 
  .dbg_bus                   (                           ), // not used
  .c0_ddr4_ui_clk            ( ui_clk                    ),
  .c0_ddr4_ui_clk_sync_rst   ( ui_clk_sync_rst           ),
  
  .c0_ddr4_act_n             ( ddr_act_n                 ), // cas_n, ras_n and we_n are multiplexed in ddr4
  .c0_ddr4_adr               ( ddr_addr                  ),
  .c0_ddr4_ba                ( ddr_ba                    ),
  .c0_ddr4_bg                ( ddr_bg                    ), // bank group address
  .c0_ddr4_cke               ( ddr_cke                   ),
  .c0_ddr4_odt               ( ddr_odt                   ),
  .c0_ddr4_cs_n              ( ddr_cs_n                  ),
  .c0_ddr4_ck_t              ( ddr_ck_p                  ),
  .c0_ddr4_ck_c              ( ddr_ck_n                  ),
  .c0_ddr4_reset_n           ( ddr_reset_n               ),
`ifndef XUPP3R_BOARD
  .c0_ddr4_dm_dbi_n          ( ddr_dm                    ), // dbi_n is a data bus inversion feature that cannot be used simultaneously with dm
`endif
  .c0_ddr4_dq                ( ddr_dq                    ), 
  .c0_ddr4_dqs_c             ( ddr_dqs_n                 ), 
  .c0_ddr4_dqs_t             ( ddr_dqs_p                 ), 
  .c0_init_calib_complete    ( init_calib_complete       ),
  
  // Application interface ports
  .c0_ddr4_app_addr          ( app_addr                  ),
  .c0_ddr4_app_cmd           ( app_cmd                   ),
  .c0_ddr4_app_en            ( app_en                    ),

  .c0_ddr4_app_hi_pri        ( app_hi_pri                ), // reserved, tie to 0
  .c0_ddr4_app_wdf_data      ( app_wdf_data              ), 
  .c0_ddr4_app_wdf_end       ( app_wdf_end               ),
  .c0_ddr4_app_wdf_mask      ( app_wdf_mask              ), 
  .c0_ddr4_app_wdf_wren      ( app_wdf_wren              ),
  .c0_ddr4_app_rd_data       ( app_rd_data               ), 
  .c0_ddr4_app_rd_data_end   ( app_rd_data_end           ),
  .c0_ddr4_app_rd_data_valid ( app_rd_data_valid         ),
  .c0_ddr4_app_rdy           ( app_rdy                   ),
  .c0_ddr4_app_wdf_rdy       ( app_wdf_rdy               )
`ifdef XUPP3R_BOARD
,
  .c0_ddr4_ecc_err_addr      (                           ),            // output wire [51 : 0] c0_ddr4_ecc_err_addr
  .c0_ddr4_ecc_single        (                           ),                // output wire [7 : 0] c0_ddr4_ecc_single
  .c0_ddr4_ecc_multiple      (                           ),            // output wire [7 : 0] c0_ddr4_ecc_multiple
  .c0_ddr4_app_correct_en_i  ( 1'b1                      ),     // input wire c0_ddr4_app_correct_en_i
  .c0_ddr4_parity            ( ddr_parity                )                        // output wire c0_ddr4_parity
`endif
);

`else // PITONSYS_DDR4
mig_7series_0   mig_7series_0 (
    // Memory interface ports
`ifndef NEXYS4DDR_BOARD
    .ddr3_addr                      (ddr_addr),
    .ddr3_ba                        (ddr_ba),
    .ddr3_cas_n                     (ddr_cas_n),
    .ddr3_ck_n                      (ddr_ck_n),
    .ddr3_ck_p                      (ddr_ck_p),
    .ddr3_cke                       (ddr_cke),
    .ddr3_ras_n                     (ddr_ras_n),
    .ddr3_reset_n                   (ddr_reset_n),
    .ddr3_we_n                      (ddr_we_n),
    .ddr3_dq                        (ddr_dq),
    .ddr3_dqs_n                     (ddr_dqs_n),
    .ddr3_dqs_p                     (ddr_dqs_p),
`ifndef NEXYSVIDEO_BOARD
    .ddr3_cs_n                      (ddr_cs_n),
`endif // endif NEXYSVIDEO_BOARD
    .ddr3_dm                        (ddr_dm),
    .ddr3_odt                       (ddr_odt),
`else // ifdef NEXYS4DDR_BOARD
    .ddr2_addr                      (ddr_addr),
    .ddr2_ba                        (ddr_ba),
    .ddr2_cas_n                     (ddr_cas_n),
    .ddr2_ck_n                      (ddr_ck_n),
    .ddr2_ck_p                      (ddr_ck_p),
    .ddr2_cke                       (ddr_cke),
    .ddr2_ras_n                     (ddr_ras_n),
    .ddr2_we_n                      (ddr_we_n),
    .ddr2_dq                        (ddr_dq),
    .ddr2_dqs_n                     (ddr_dqs_n),
    .ddr2_dqs_p                     (ddr_dqs_p),
    .ddr2_cs_n                      (ddr_cs_n),
    .ddr2_dm                        (ddr_dm),
    .ddr2_odt                       (ddr_odt),
`endif // endif NEXYS4DDR_BOARD

    .init_calib_complete            (init_calib_complete),

    // Application interface ports
    .app_addr                       (app_addr),
    .app_cmd                        (app_cmd),
    .app_en                         (app_en),
    .app_wdf_data                   (app_wdf_data),
    .app_wdf_end                    (app_wdf_end),
    .app_wdf_wren                   (app_wdf_wren),
    .app_rd_data                    (app_rd_data),
    .app_rd_data_end                (app_rd_data_end),
    .app_rd_data_valid              (app_rd_data_valid),
    .app_rdy                        (app_rdy),
    .app_wdf_rdy                    (app_wdf_rdy),
    .app_sr_req                     (app_sr_req),
    .app_ref_req                    (app_ref_req),
    .app_zq_req                     (app_zq_req),
    .app_sr_active                  (app_sr_active),
    .app_ref_ack                    (app_ref_ack),
    .app_zq_ack                     (app_zq_ack),
    .ui_clk                         (ui_clk),
    .ui_clk_sync_rst                (ui_clk_sync_rst),
    .app_wdf_mask                   (app_wdf_mask),

    // System Clock Ports
    .sys_clk_i                      (sys_clk),
    .sys_rst                        (sys_rst_n)
);
`endif // PITONSYS_DDR4

`else // PITONSYS_AXI4_MEM

`ifdef PITONSYS_MEM_ZEROER
 assign m_axi_awid = zeroer_axi_awid;
 assign m_axi_awaddr = zeroer_axi_awaddr;
 assign m_axi_awlen = zeroer_axi_awlen;
 assign m_axi_awsize = zeroer_axi_awsize;
 assign m_axi_awburst = zeroer_axi_awburst;
 assign m_axi_awlock = zeroer_axi_awlock;
 assign m_axi_awcache = zeroer_axi_awcache;
 assign m_axi_awprot = zeroer_axi_awprot;
 assign m_axi_awqos = zeroer_axi_awqos;
 assign m_axi_awregion = zeroer_axi_awregion;
 assign m_axi_awuser = zeroer_axi_awuser;
 assign m_axi_awvalid = zeroer_axi_awvalid;
 assign zeroer_axi_awready = m_axi_awready;
 
 assign m_axi_wid = zeroer_axi_wid;
 assign m_axi_wdata = zeroer_axi_wdata;
 assign m_axi_wstrb = zeroer_axi_wstrb;
 assign m_axi_wlast = zeroer_axi_wlast;
 assign m_axi_wuser = zeroer_axi_wuser;
 assign m_axi_wvalid = zeroer_axi_wvalid;
 assign zeroer_axi_wready = m_axi_wready;
 
 assign m_axi_arid = zeroer_axi_arid;
 assign m_axi_araddr = zeroer_axi_araddr;
 assign m_axi_arlen = zeroer_axi_arlen;
 assign m_axi_arsize = zeroer_axi_arsize;
 assign m_axi_arburst = zeroer_axi_arburst;
 assign m_axi_arlock = zeroer_axi_arlock;
 assign m_axi_arcache = zeroer_axi_arcache;
 assign m_axi_arprot = zeroer_axi_arprot;
 assign m_axi_arqos = zeroer_axi_arqos;
 assign m_axi_arregion = zeroer_axi_arregion;
 assign m_axi_aruser = zeroer_axi_aruser;
 assign m_axi_arvalid = zeroer_axi_arvalid;
 assign zeroer_axi_arready = m_axi_arready;
 
 assign zeroer_axi_rid = m_axi_rid;
 assign zeroer_axi_rdata = m_axi_rdata;
 assign zeroer_axi_rresp = m_axi_rresp;
 assign zeroer_axi_rlast = m_axi_rlast;
 assign zeroer_axi_ruser = m_axi_ruser;
 assign zeroer_axi_rvalid = m_axi_rvalid;
 assign m_axi_rready = zeroer_axi_rready;
 
 assign zeroer_axi_bid = m_axi_bid;
 assign zeroer_axi_bresp = m_axi_bresp;
 assign zeroer_axi_buser = m_axi_buser;
 assign zeroer_axi_bvalid = m_axi_bvalid;
 assign m_axi_bready = zeroer_axi_bready;
 
 assign noc_axi4_bridge_rst       = ui_clk_sync_rst & ~init_calib_complete_zero;
 assign noc_axi4_bridge_init_done = init_calib_complete_zero;
 assign init_calib_complete_out  = init_calib_complete_zero & ~ui_clk_syn_rst_delayed;
`else // PITONSYS_MEM_ZEROER

assign m_axi_awid = core_axi_awid;
assign m_axi_awaddr = core_axi_awaddr;
assign m_axi_awlen = core_axi_awlen;
assign m_axi_awsize = core_axi_awsize;
assign m_axi_awburst = core_axi_awburst;
assign m_axi_awlock = core_axi_awlock;
assign m_axi_awcache = core_axi_awcache;
assign m_axi_awprot = core_axi_awprot;
assign m_axi_awqos = core_axi_awqos;
assign m_axi_awregion = core_axi_awregion;
assign m_axi_awuser = core_axi_awuser;
assign m_axi_awvalid = core_axi_awvalid;
assign core_axi_awready = m_axi_awready;

assign m_axi_wid = core_axi_wid;
assign m_axi_wdata = core_axi_wdata;
assign m_axi_wstrb = core_axi_wstrb;
assign m_axi_wlast = core_axi_wlast;
assign m_axi_wuser = core_axi_wuser;
assign m_axi_wvalid = core_axi_wvalid;
assign core_axi_wready = m_axi_wready;

assign m_axi_arid = core_axi_arid;
assign m_axi_araddr = core_axi_araddr;
assign m_axi_arlen = core_axi_arlen;
assign m_axi_arsize = core_axi_arsize;
assign m_axi_arburst = core_axi_arburst;
assign m_axi_arlock = core_axi_arlock;
assign m_axi_arcache = core_axi_arcache;
assign m_axi_arprot = core_axi_arprot;
assign m_axi_arqos = core_axi_arqos;
assign m_axi_arregion = core_axi_arregion;
assign m_axi_aruser = core_axi_aruser;
assign m_axi_arvalid = core_axi_arvalid;
assign core_axi_arready = m_axi_arready;

assign core_axi_rid = m_axi_rid;
assign core_axi_rdata = m_axi_rdata;
assign core_axi_rresp = m_axi_rresp;
assign core_axi_rlast = m_axi_rlast;
assign core_axi_ruser = m_axi_ruser;
assign core_axi_rvalid = m_axi_rvalid;
assign m_axi_rready = core_axi_rready;

assign core_axi_bid = m_axi_bid;
assign core_axi_bresp = m_axi_bresp;
assign core_axi_buser = m_axi_buser;
assign core_axi_bvalid = m_axi_bvalid;
assign m_axi_bready = core_axi_bready;

assign noc_axi4_bridge_rst       = ui_clk_sync_rst;
assign noc_axi4_bridge_init_done = init_calib_complete;
assign init_calib_complete_out  = init_calib_complete & ~ui_clk_syn_rst_delayed;
`endif // PITONSYS_MEM_ZEROER

// system memory base address from devices.xml, unaligned with memory size and thus is subtracted from access memory address
//localparam MEM_BASE_UNALIGN = `AXI4_ADDR_WIDTH'h80000000;
localparam MEM_BASE_UNALIGN = '0;

noc_axi4_bridge #(
  `ifdef PITON_FPGA_MC_HBM
    .AXI4_DAT_WIDTH_USED (HBM_WIDTH),
    .ADDR_SWAP_LBITS(HBM_MCS_LOG2),
    .ADDR_SWAP_MSB  (HBM_SIZE_LOG2),
    .ADDR_SWAP_LSB  (HBM_MCS_ADDR),
  `else
    .OUTSTAND_QUEUE_BRAM (0), // speed-up of the bridge if working at DDR clock
  `endif
    .ADDR_OFFSET(MEM_BASE_UNALIGN),
    .NUM_REQ_OUTSTANDING_LOG2 ($clog2(`PITON_NUM_TILES * 4))
    // .NUM_REQ_MSHRID_LBIT (`L15_MSHR_ID_WIDTH),
    // .NUM_REQ_MSHRID_BITS (`L15_THREADID_WIDTH),
    // .NUM_REQ_YTHREADS (`PITON_Y_TILES),
    // .NUM_REQ_XTHREADS (`PITON_X_TILES)
)
 noc_axi4_bridge  (
    .clk                (ui_clk                    ),  
    .rst_n              (~noc_axi4_bridge_rst      ), 
    .uart_boot_en       (uart_boot_en              ),
    .phy_init_done      (noc_axi4_bridge_init_done ),
    .axi_id_deadlock    (mc_axi_deadlock           ),

    .src_bridge_vr_noc2_val(fifo_trans_val),
    .src_bridge_vr_noc2_dat(fifo_trans_data),
    .src_bridge_vr_noc2_rdy(fifo_trans_rdy),

    .bridge_dst_vr_noc3_val(trans_fifo_val),
    .bridge_dst_vr_noc3_dat(trans_fifo_data),
    .bridge_dst_vr_noc3_rdy(trans_fifo_rdy),

    .m_axi_awid(core_axi_awid),
    .m_axi_awaddr(core_axi_awaddr),
    .m_axi_awlen(core_axi_awlen),
    .m_axi_awsize(core_axi_awsize),
    .m_axi_awburst(core_axi_awburst),
    .m_axi_awlock(core_axi_awlock),
    .m_axi_awcache(core_axi_awcache),
    .m_axi_awprot(core_axi_awprot),
    .m_axi_awqos(core_axi_awqos),
    .m_axi_awregion(core_axi_awregion),
    .m_axi_awuser(core_axi_awuser),
    .m_axi_awvalid(core_axi_awvalid),
    .m_axi_awready(core_axi_awready),

    .m_axi_wid(core_axi_wid),
    .m_axi_wdata(core_axi_wdata),
    .m_axi_wstrb(core_axi_wstrb),
    .m_axi_wlast(core_axi_wlast),
    .m_axi_wuser(core_axi_wuser),
    .m_axi_wvalid(core_axi_wvalid),
    .m_axi_wready(core_axi_wready),

    .m_axi_bid(core_axi_bid),
    .m_axi_bresp(core_axi_bresp),
    .m_axi_buser(core_axi_buser),
    .m_axi_bvalid(core_axi_bvalid),
    .m_axi_bready(core_axi_bready),

    .m_axi_arid(core_axi_arid),
    .m_axi_araddr(core_axi_araddr),
    .m_axi_arlen(core_axi_arlen),
    .m_axi_arsize(core_axi_arsize),
    .m_axi_arburst(core_axi_arburst),
    .m_axi_arlock(core_axi_arlock),
    .m_axi_arcache(core_axi_arcache),
    .m_axi_arprot(core_axi_arprot),
    .m_axi_arqos(core_axi_arqos),
    .m_axi_arregion(core_axi_arregion),
    .m_axi_aruser(core_axi_aruser),
    .m_axi_arvalid(core_axi_arvalid),
    .m_axi_arready(core_axi_arready),

    .m_axi_rid(core_axi_rid),
    .m_axi_rdata(core_axi_rdata),
    .m_axi_rresp(core_axi_rresp),
    .m_axi_rlast(core_axi_rlast),
    .m_axi_ruser(core_axi_ruser),
    .m_axi_rvalid(core_axi_rvalid),
    .m_axi_rready(core_axi_rready)

);

//Verilog macro metaprogramming: https://veripool.org/papers/Preproc_Good_Evil_SNUGBos10_paper.pdf
`define MC_BRIDGE(idx) \
\
wire [`AXI4_ID_WIDTH     -1:0]     m_axi``idx``_awid; \
wire [`AXI4_ADDR_WIDTH   -1:0]     m_axi``idx``_awaddr; \
wire [`AXI4_LEN_WIDTH    -1:0]     m_axi``idx``_awlen; \
wire [`AXI4_SIZE_WIDTH   -1:0]     m_axi``idx``_awsize; \
wire [`AXI4_BURST_WIDTH  -1:0]     m_axi``idx``_awburst; \
wire                               m_axi``idx``_awlock; \
wire [`AXI4_CACHE_WIDTH  -1:0]     m_axi``idx``_awcache; \
wire [`AXI4_PROT_WIDTH   -1:0]     m_axi``idx``_awprot; \
wire [`AXI4_QOS_WIDTH    -1:0]     m_axi``idx``_awqos; \
wire [`AXI4_REGION_WIDTH -1:0]     m_axi``idx``_awregion; \
wire [`AXI4_USER_WIDTH   -1:0]     m_axi``idx``_awuser; \
wire                               m_axi``idx``_awvalid; \
wire                               m_axi``idx``_awready; \
\
wire  [`AXI4_ID_WIDTH     -1:0]    m_axi``idx``_wid; \
wire  [`AXI4_DATA_WIDTH   -1:0]    m_axi``idx``_wdata; \
wire  [`AXI4_STRB_WIDTH   -1:0]    m_axi``idx``_wstrb; \
wire                               m_axi``idx``_wlast; \
wire  [`AXI4_USER_WIDTH   -1:0]    m_axi``idx``_wuser; \
wire                               m_axi``idx``_wvalid; \
wire                               m_axi``idx``_wready; \
\
wire  [`AXI4_ID_WIDTH     -1:0]    m_axi``idx``_arid; \
wire  [`AXI4_ADDR_WIDTH   -1:0]    m_axi``idx``_araddr; \
wire  [`AXI4_LEN_WIDTH    -1:0]    m_axi``idx``_arlen; \
wire  [`AXI4_SIZE_WIDTH   -1:0]    m_axi``idx``_arsize; \
wire  [`AXI4_BURST_WIDTH  -1:0]    m_axi``idx``_arburst; \
wire                               m_axi``idx``_arlock; \
wire  [`AXI4_CACHE_WIDTH  -1:0]    m_axi``idx``_arcache; \
wire  [`AXI4_PROT_WIDTH   -1:0]    m_axi``idx``_arprot; \
wire  [`AXI4_QOS_WIDTH    -1:0]    m_axi``idx``_arqos; \
wire  [`AXI4_REGION_WIDTH -1:0]    m_axi``idx``_arregion; \
wire  [`AXI4_USER_WIDTH   -1:0]    m_axi``idx``_aruser; \
wire                               m_axi``idx``_arvalid; \
wire                               m_axi``idx``_arready; \
\
wire  [`AXI4_ID_WIDTH     -1:0]    m_axi``idx``_rid; \
wire  [`AXI4_DATA_WIDTH   -1:0]    m_axi``idx``_rdata; \
wire  [`AXI4_RESP_WIDTH   -1:0]    m_axi``idx``_rresp; \
wire                               m_axi``idx``_rlast; \
wire  [`AXI4_USER_WIDTH   -1:0]    m_axi``idx``_ruser; \
wire                               m_axi``idx``_rvalid; \
wire                               m_axi``idx``_rready; \
\
wire  [`AXI4_ID_WIDTH     -1:0]    m_axi``idx``_bid; \
wire  [`AXI4_RESP_WIDTH   -1:0]    m_axi``idx``_bresp; \
wire  [`AXI4_USER_WIDTH   -1:0]    m_axi``idx``_buser; \
wire                               m_axi``idx``_bvalid; \
wire                               m_axi``idx``_bready; \
\
noc_axi4_bridge #( \
    .AXI4_DAT_WIDTH_USED(HBM_WIDTH), \
    .ADDR_OFFSET(MEM_BASE_UNALIGN), \
    .ADDR_SWAP_LBITS(HBM_MCS_LOG2), \
    .ADDR_SWAP_MSB  (HBM_SIZE_LOG2), \
    .ADDR_SWAP_LSB  (HBM_MCS_ADDR), \
    .NUM_REQ_OUTSTANDING_LOG2 (4), \
    /* for 2d-mesh having pure internal tiles (like 3x3) usage of either SRC_X/Y or INI_X/Y NOC fields as AXI ID results in Fedora kernel panic */ \
    .NUM_REQ_YTHREADS (`PITON_EXTRA_MEMS == `PITON_NUM_TILES ? `PITON_Y_TILES : 1), \
    .NUM_REQ_XTHREADS (`PITON_EXTRA_MEMS == `PITON_NUM_TILES ? `PITON_X_TILES : 1), \
    .SRCXY_AS_AXIID   (1) \
) noc_axi4_bridge_mc``idx ( \
    .clk                (core_ref_clk), \
    .rst_n              (sys_rst_n), \
    .uart_boot_en       (1'b0), \
    .phy_init_done      (noc_axi4_bridge_init_done ), \
    .axi_id_deadlock    (), \
\
    .src_bridge_vr_noc2_rdy(mcx_flit_in_rdy [``idx]), \
    .src_bridge_vr_noc2_val(mcx_flit_in_val [``idx]), \
    .src_bridge_vr_noc2_dat(mcx_flit_in_data[``idx * `NOC_DATA_WIDTH +: `NOC_DATA_WIDTH]), \
\
    .bridge_dst_vr_noc3_rdy(mcx_flit_out_rdy [``idx]), \
    .bridge_dst_vr_noc3_val(mcx_flit_out_val [``idx]), \
    .bridge_dst_vr_noc3_dat(mcx_flit_out_data[``idx * `NOC_DATA_WIDTH +: `NOC_DATA_WIDTH]), \
\
    .m_axi_awid      (m_axi``idx``_awid), \
    .m_axi_awaddr    (m_axi``idx``_awaddr), \
    .m_axi_awlen     (m_axi``idx``_awlen), \
    .m_axi_awsize    (m_axi``idx``_awsize), \
    .m_axi_awburst   (m_axi``idx``_awburst), \
    .m_axi_awlock    (m_axi``idx``_awlock), \
    .m_axi_awcache   (m_axi``idx``_awcache), \
    .m_axi_awprot    (m_axi``idx``_awprot), \
    .m_axi_awqos     (m_axi``idx``_awqos), \
    .m_axi_awregion  (m_axi``idx``_awregion), \
    .m_axi_awuser    (m_axi``idx``_awuser), \
    .m_axi_awvalid   (m_axi``idx``_awvalid), \
    .m_axi_awready   (m_axi``idx``_awready), \
\
    .m_axi_wid       (m_axi``idx``_wid), \
    .m_axi_wdata     (m_axi``idx``_wdata), \
    .m_axi_wstrb     (m_axi``idx``_wstrb), \
    .m_axi_wlast     (m_axi``idx``_wlast), \
    .m_axi_wuser     (m_axi``idx``_wuser), \
    .m_axi_wvalid    (m_axi``idx``_wvalid), \
    .m_axi_wready    (m_axi``idx``_wready), \
\
    .m_axi_bid       (m_axi``idx``_bid), \
    .m_axi_bresp     (m_axi``idx``_bresp), \
    .m_axi_buser     (m_axi``idx``_buser), \
    .m_axi_bvalid    (m_axi``idx``_bvalid), \
    .m_axi_bready    (m_axi``idx``_bready), \
\
    .m_axi_arid      (m_axi``idx``_arid), \
    .m_axi_araddr    (m_axi``idx``_araddr), \
    .m_axi_arlen     (m_axi``idx``_arlen), \
    .m_axi_arsize    (m_axi``idx``_arsize), \
    .m_axi_arburst   (m_axi``idx``_arburst), \
    .m_axi_arlock    (m_axi``idx``_arlock), \
    .m_axi_arcache   (m_axi``idx``_arcache), \
    .m_axi_arprot    (m_axi``idx``_arprot), \
    .m_axi_arqos     (m_axi``idx``_arqos), \
    .m_axi_arregion  (m_axi``idx``_arregion), \
    .m_axi_aruser    (m_axi``idx``_aruser), \
    .m_axi_arvalid   (m_axi``idx``_arvalid), \
    .m_axi_arready   (m_axi``idx``_arready), \
\
    .m_axi_rid       (m_axi``idx``_rid), \
    .m_axi_rdata     (m_axi``idx``_rdata), \
    .m_axi_rresp     (m_axi``idx``_rresp), \
    .m_axi_rlast     (m_axi``idx``_rlast), \
    .m_axi_ruser     (m_axi``idx``_ruser), \
    .m_axi_rvalid    (m_axi``idx``_rvalid), \
    .m_axi_rready    (m_axi``idx``_rready) \
);

`define MC_BRIDGES(n) `MC_BRIDGES_``n
`define MC_BRIDGES_0
`define MC_BRIDGES_1  `MC_BRIDGES_0  `MC_BRIDGE(0)
`define MC_BRIDGES_2  `MC_BRIDGES_1  `MC_BRIDGE(1)
`define MC_BRIDGES_3  `MC_BRIDGES_2  `MC_BRIDGE(2)
`define MC_BRIDGES_4  `MC_BRIDGES_3  `MC_BRIDGE(3)
`define MC_BRIDGES_5  `MC_BRIDGES_4  `MC_BRIDGE(4)
`define MC_BRIDGES_6  `MC_BRIDGES_5  `MC_BRIDGE(5)
`define MC_BRIDGES_7  `MC_BRIDGES_6  `MC_BRIDGE(6)
`define MC_BRIDGES_8  `MC_BRIDGES_7  `MC_BRIDGE(7)
`define MC_BRIDGES_9  `MC_BRIDGES_8  `MC_BRIDGE(8)
`define MC_BRIDGES_10 `MC_BRIDGES_9  `MC_BRIDGE(9)
`define MC_BRIDGES_11 `MC_BRIDGES_10 `MC_BRIDGE(10)
`define MC_BRIDGES_12 `MC_BRIDGES_11 `MC_BRIDGE(11)
`define MC_BRIDGES_13 `MC_BRIDGES_12 `MC_BRIDGE(12)
`define MC_BRIDGES_14 `MC_BRIDGES_13 `MC_BRIDGE(13)
`define MC_BRIDGES_15 `MC_BRIDGES_14 `MC_BRIDGE(14)
`define MC_BRIDGES_16 `MC_BRIDGES_15 `MC_BRIDGE(15)
`define MC_BRIDGES_17 `MC_BRIDGES_16 `MC_BRIDGE(16)
`define MC_BRIDGES_18 `MC_BRIDGES_17 `MC_BRIDGE(17)
`define MC_BRIDGES_19 `MC_BRIDGES_18 `MC_BRIDGE(18)
`define MC_BRIDGES_20 `MC_BRIDGES_19 `MC_BRIDGE(19)
`define MC_BRIDGES_21 `MC_BRIDGES_20 `MC_BRIDGE(20)
`define MC_BRIDGES_22 `MC_BRIDGES_21 `MC_BRIDGE(21)
`define MC_BRIDGES_23 `MC_BRIDGES_22 `MC_BRIDGE(22)
`define MC_BRIDGES_24 `MC_BRIDGES_23 `MC_BRIDGE(23)
`define MC_BRIDGES_25 `MC_BRIDGES_24 `MC_BRIDGE(24)
`define MC_BRIDGES_26 `MC_BRIDGES_25 `MC_BRIDGE(25)
`define MC_BRIDGES_27 `MC_BRIDGES_26 `MC_BRIDGE(26)
`define MC_BRIDGES_28 `MC_BRIDGES_27 `MC_BRIDGE(27)
`define MC_BRIDGES_29 `MC_BRIDGES_28 `MC_BRIDGE(28)
`define MC_BRIDGES_30 `MC_BRIDGES_29 `MC_BRIDGE(29)

`ifdef PITON_EXTRA_MEMS
  `MC_BRIDGES(`PITON_EXTRA_MEMS)
`endif

`ifdef PITONSYS_MEM_ZEROER
axi4_zeroer axi4_zeroer(
  .clk                    (ui_clk),
  .rst_n                  (~ui_clk_sync_rst),
  .init_calib_complete_in (init_calib_complete),
  .init_calib_complete_out(init_calib_complete_zero),

  .s_axi_awid             (core_axi_awid),
  .s_axi_awaddr           (core_axi_awaddr),
  .s_axi_awlen            (core_axi_awlen),
  .s_axi_awsize           (core_axi_awsize),
  .s_axi_awburst          (core_axi_awburst),
  .s_axi_awlock           (core_axi_awlock),
  .s_axi_awcache          (core_axi_awcache),
  .s_axi_awprot           (core_axi_awprot),
  .s_axi_awqos            (core_axi_awqos),
  .s_axi_awregion         (core_axi_awregion),
  .s_axi_awuser           (core_axi_awuser),
  .s_axi_awvalid          (core_axi_awvalid),
  .s_axi_awready          (core_axi_awready),

  .s_axi_wid              (core_axi_wid),
  .s_axi_wdata            (core_axi_wdata),
  .s_axi_wstrb            (core_axi_wstrb),
  .s_axi_wlast            (core_axi_wlast),
  .s_axi_wuser            (core_axi_wuser),
  .s_axi_wvalid           (core_axi_wvalid),
  .s_axi_wready           (core_axi_wready),

  .s_axi_arid             (core_axi_arid),
  .s_axi_araddr           (core_axi_araddr),
  .s_axi_arlen            (core_axi_arlen),
  .s_axi_arsize           (core_axi_arsize),
  .s_axi_arburst          (core_axi_arburst),
  .s_axi_arlock           (core_axi_arlock),
  .s_axi_arcache          (core_axi_arcache),
  .s_axi_arprot           (core_axi_arprot),
  .s_axi_arqos            (core_axi_arqos),
  .s_axi_arregion         (core_axi_arregion),
  .s_axi_aruser           (core_axi_aruser),
  .s_axi_arvalid          (core_axi_arvalid),
  .s_axi_arready          (core_axi_arready),

  .s_axi_rid              (core_axi_rid),
  .s_axi_rdata            (core_axi_rdata),
  .s_axi_rresp            (core_axi_rresp),
  .s_axi_rlast            (core_axi_rlast),
  .s_axi_ruser            (core_axi_ruser),
  .s_axi_rvalid           (core_axi_rvalid),
  .s_axi_rready           (core_axi_rready),

  .s_axi_bid              (core_axi_bid),
  .s_axi_bresp            (core_axi_bresp),
  .s_axi_buser            (core_axi_buser),
  .s_axi_bvalid           (core_axi_bvalid),
  .s_axi_bready           (core_axi_bready),


  .m_axi_awid             (zeroer_axi_awid),
  .m_axi_awaddr           (zeroer_axi_awaddr),
  .m_axi_awlen            (zeroer_axi_awlen),
  .m_axi_awsize           (zeroer_axi_awsize),
  .m_axi_awburst          (zeroer_axi_awburst),
  .m_axi_awlock           (zeroer_axi_awlock),
  .m_axi_awcache          (zeroer_axi_awcache),
  .m_axi_awprot           (zeroer_axi_awprot),
  .m_axi_awqos            (zeroer_axi_awqos),
  .m_axi_awregion         (zeroer_axi_awregion),
  .m_axi_awuser           (zeroer_axi_awuser),
  .m_axi_awvalid          (zeroer_axi_awvalid),
  .m_axi_awready          (zeroer_axi_awready),

  .m_axi_wid              (zeroer_axi_wid),
  .m_axi_wdata            (zeroer_axi_wdata),
  .m_axi_wstrb            (zeroer_axi_wstrb),
  .m_axi_wlast            (zeroer_axi_wlast),
  .m_axi_wuser            (zeroer_axi_wuser),
  .m_axi_wvalid           (zeroer_axi_wvalid),
  .m_axi_wready           (zeroer_axi_wready),

  .m_axi_arid             (zeroer_axi_arid),
  .m_axi_araddr           (zeroer_axi_araddr),
  .m_axi_arlen            (zeroer_axi_arlen),
  .m_axi_arsize           (zeroer_axi_arsize),
  .m_axi_arburst          (zeroer_axi_arburst),
  .m_axi_arlock           (zeroer_axi_arlock),
  .m_axi_arcache          (zeroer_axi_arcache),
  .m_axi_arprot           (zeroer_axi_arprot),
  .m_axi_arqos            (zeroer_axi_arqos),
  .m_axi_arregion         (zeroer_axi_arregion),
  .m_axi_aruser           (zeroer_axi_aruser),
  .m_axi_arvalid          (zeroer_axi_arvalid),
  .m_axi_arready          (zeroer_axi_arready),

  .m_axi_rid              (zeroer_axi_rid),
  .m_axi_rdata            (zeroer_axi_rdata),
  .m_axi_rresp            (zeroer_axi_rresp),
  .m_axi_rlast            (zeroer_axi_rlast),
  .m_axi_ruser            (zeroer_axi_ruser),
  .m_axi_rvalid           (zeroer_axi_rvalid),
  .m_axi_rready           (zeroer_axi_rready),

  .m_axi_bid              (zeroer_axi_bid),
  .m_axi_bresp            (zeroer_axi_bresp),
  .m_axi_buser            (zeroer_axi_buser),
  .m_axi_bvalid           (zeroer_axi_bvalid),
  .m_axi_bready           (zeroer_axi_bready)
);
`endif // PITONSYS_MEM_ZEROER

`ifndef PITONSYS_MEEP
`ifdef PITONSYS_DDR4
`ifdef PITONSYS_PCIE


 wire [`AXI4_ADDR_WIDTH  -1:0]  pci2hbm_maxi_araddr;
 wire [`AXI4_BURST_WIDTH -1:0]  pci2hbm_maxi_arburst;
 wire [`AXI4_CACHE_WIDTH -1:0]  pci2hbm_maxi_arcache;
 wire [`AXI4_LEN_WIDTH   -1:0]  pci2hbm_maxi_arlen;
 wire                           pci2hbm_maxi_arlock;
 wire [`AXI4_PROT_WIDTH  -1:0]  pci2hbm_maxi_arprot;
 wire [`AXI4_QOS_WIDTH   -1:0]  pci2hbm_maxi_arqos;
 wire                           pci2hbm_maxi_arready;
 wire [`AXI4_SIZE_WIDTH  -1:0]  pci2hbm_maxi_arsize;
 wire [`AXI4_USER_WIDTH  -1:0]  pci2hbm_maxi_aruser;
 wire                           pci2hbm_maxi_arvalid;
 wire [`AXI4_ADDR_WIDTH  -1:0]  pci2hbm_maxi_awaddr;
 wire [`AXI4_BURST_WIDTH -1:0]  pci2hbm_maxi_awburst;
 wire [`AXI4_CACHE_WIDTH -1:0]  pci2hbm_maxi_awcache;
 wire [`AXI4_LEN_WIDTH   -1:0]  pci2hbm_maxi_awlen;
 wire                           pci2hbm_maxi_awlock;
 wire [`AXI4_PROT_WIDTH  -1:0]  pci2hbm_maxi_awprot;
 wire [`AXI4_QOS_WIDTH   -1:0]  pci2hbm_maxi_awqos;
 wire                           pci2hbm_maxi_awready;
 wire [`AXI4_SIZE_WIDTH  -1:0]  pci2hbm_maxi_awsize;
 wire [`AXI4_USER_WIDTH  -1:0]  pci2hbm_maxi_awuser;
 wire                           pci2hbm_maxi_awvalid;
 wire                           pci2hbm_maxi_bready;
 wire [`AXI4_RESP_WIDTH  -1:0]  pci2hbm_maxi_bresp;
 wire                           pci2hbm_maxi_bvalid;
 wire [`AXI4_DATA_WIDTH  -1:0]  pci2hbm_maxi_rdata;
 wire                           pci2hbm_maxi_rlast;
 wire                           pci2hbm_maxi_rready;
 wire [`AXI4_RESP_WIDTH  -1:0]  pci2hbm_maxi_rresp;
 wire                           pci2hbm_maxi_rvalid;
 wire [`AXI4_DATA_WIDTH  -1:0]  pci2hbm_maxi_wdata;
 wire                           pci2hbm_maxi_wlast;
 wire                           pci2hbm_maxi_wready;
 wire [`AXI4_STRB_WIDTH  -1:0]  pci2hbm_maxi_wstrb;
 wire                           pci2hbm_maxi_wvalid;

// making address swapping for interleaving of HBM MC channels
 wire [`AXI4_ADDR_WIDTH-1 : 0] pci2hbm_raddr;
 wire [`AXI4_ADDR_WIDTH-1 : 0] pci2hbm_waddr;
 generate
  if (HBM_MCS_LOG2) begin
    assign pci2hbm_raddr = {pci2hbm_maxi_araddr[`AXI4_ADDR_WIDTH-1 : HBM_SIZE_LOG2              ],
                            pci2hbm_maxi_araddr[HBM_MCS_ADDR      +: HBM_MCS_LOG2               ], // Low address part moved up
                            pci2hbm_maxi_araddr[HBM_SIZE_LOG2-1    : HBM_MCS_ADDR + HBM_MCS_LOG2], // High address part shifted down
                            pci2hbm_maxi_araddr[HBM_MCS_ADDR -1    : 0]};
    assign pci2hbm_waddr = {pci2hbm_maxi_awaddr[`AXI4_ADDR_WIDTH-1 : HBM_SIZE_LOG2              ],
                            pci2hbm_maxi_awaddr[HBM_MCS_ADDR      +: HBM_MCS_LOG2               ], // Low address part moved up
                            pci2hbm_maxi_awaddr[HBM_SIZE_LOG2-1    : HBM_MCS_ADDR + HBM_MCS_LOG2], // High address part shifted down
                            pci2hbm_maxi_awaddr[HBM_MCS_ADDR -1    : 0]};
  end
  else begin
    assign pci2hbm_raddr =  pci2hbm_maxi_araddr;
    assign pci2hbm_waddr =  pci2hbm_maxi_awaddr;
  end
 endgenerate

 meep_shell meep_shell
       (
         .*, // implicit connection of all AXI's at once

  `ifdef PITON_FPGA_MC_HBM
        .pci2hbm_saxi_araddr  (pci2hbm_raddr),
        .pci2hbm_saxi_awaddr  (pci2hbm_waddr),
  `else
        .pci2hbm_saxi_araddr  (pci2hbm_maxi_araddr),
        .pci2hbm_saxi_awaddr  (pci2hbm_maxi_awaddr),
  `endif
        .pci2hbm_saxi_arburst (pci2hbm_maxi_arburst),
        .pci2hbm_saxi_arid    ('0),
        .pci2hbm_saxi_arlen   (pci2hbm_maxi_arlen),
        .pci2hbm_saxi_arready (pci2hbm_maxi_arready),
        .pci2hbm_saxi_arsize  (pci2hbm_maxi_arsize),
        .pci2hbm_saxi_arvalid (pci2hbm_maxi_arvalid),
        .pci2hbm_saxi_awburst (pci2hbm_maxi_awburst),
        .pci2hbm_saxi_awid    ('0),
        .pci2hbm_saxi_awlen   (pci2hbm_maxi_awlen),
        .pci2hbm_saxi_awready (pci2hbm_maxi_awready),
        .pci2hbm_saxi_awsize  (pci2hbm_maxi_awsize),
        .pci2hbm_saxi_awvalid (pci2hbm_maxi_awvalid),
        .pci2hbm_saxi_bid     (),
        .pci2hbm_saxi_bready  (pci2hbm_maxi_bready),
        .pci2hbm_saxi_bresp   (pci2hbm_maxi_bresp),
        .pci2hbm_saxi_bvalid  (pci2hbm_maxi_bvalid),
        .pci2hbm_saxi_rdata   (pci2hbm_maxi_rdata),
        .pci2hbm_saxi_rid     (),
        .pci2hbm_saxi_rlast   (pci2hbm_maxi_rlast),
        .pci2hbm_saxi_rready  (pci2hbm_maxi_rready),
        .pci2hbm_saxi_rresp   (pci2hbm_maxi_rresp),
        .pci2hbm_saxi_rvalid  (pci2hbm_maxi_rvalid),
        .pci2hbm_saxi_wdata   (pci2hbm_maxi_wdata),
        .pci2hbm_saxi_wlast   (pci2hbm_maxi_wlast),
        .pci2hbm_saxi_wready  (pci2hbm_maxi_wready),
        .pci2hbm_saxi_wstrb   (pci2hbm_maxi_wstrb),
        .pci2hbm_saxi_wvalid  (pci2hbm_maxi_wvalid),

        .mem_clk(ui_clk),
        .mem_rst(ui_clk_sync_rst),
        .mem_calib_complete(init_calib_complete),

        .ddr4_sdram_c0_act_n(ddr_act_n),
        .ddr4_sdram_c0_adr(ddr_addr),
        .ddr4_sdram_c0_ba(ddr_ba),
        .ddr4_sdram_c0_bg(ddr_bg),
        .ddr4_sdram_c0_ck_c(ddr_ck_n),
        .ddr4_sdram_c0_ck_t(ddr_ck_p),
        .ddr4_sdram_c0_cke(ddr_cke),
        .ddr4_sdram_c0_cs_n(ddr_cs_n),
        .ddr4_sdram_c0_dq(ddr_dq),
        .ddr4_sdram_c0_dqs_c(ddr_dqs_n),
        .ddr4_sdram_c0_dqs_t(ddr_dqs_p),
        .ddr4_sdram_c0_odt(ddr_odt),
        .ddr4_sdram_c0_par(ddr_parity),
        .ddr4_sdram_c0_reset_n(ddr_reset_n),
        
        .hbm_cattrip(hbm_cattrip),

        .ddr_clk_clk_n(sys_clk_n),
        .ddr_clk_clk_p(sys_clk_p),
        .sys_rst(~sys_rst_n),
        .sys_clk(core_ref_clk),

        .pci_express_x16_rxn(pci_express_x16_rxn),
        .pci_express_x16_rxp(pci_express_x16_rxp),
        .pci_express_x16_txn(pci_express_x16_txn),
        .pci_express_x16_txp(pci_express_x16_txp),
        .pcie_gpio(pcie_gpio),
        .pcie_perstn(pcie_perstn),
        .pcie_refclk_clk_n( pcie_refclk_n),
        .pcie_refclk_clk_p( pcie_refclk_p)
        );
 assign m_axi_ruser    = `AXI4_USER_WIDTH'h0;
 assign m_axi_buser    = `AXI4_USER_WIDTH'h0;
 assign sram_axi_ruser = `AXI4_USER_WIDTH'h0;
 assign sram_axi_buser = `AXI4_USER_WIDTH'h0;
`else // PITONSYS_PCIE
 
ddr4_axi4 ddr_axi4 (
  .sys_rst                   ( ~sys_rst_n                ),
  .c0_sys_clk_p              ( sys_clk_p                 ),
  .c0_sys_clk_n              ( sys_clk_n                 ),
  .dbg_clk                   (                           ), // not used 
  .dbg_bus                   (                           ), // not used
  .c0_ddr4_ui_clk            ( ui_clk                    ),
  .c0_ddr4_ui_clk_sync_rst   ( ui_clk_sync_rst           ),
  
  .c0_ddr4_act_n             ( ddr_act_n                 ), // cas_n, ras_n and we_n are multiplexed in ddr4
  .c0_ddr4_adr               ( ddr_addr                  ),
  .c0_ddr4_ba                ( ddr_ba                    ),
  .c0_ddr4_bg                ( ddr_bg                    ), // bank group address
  .c0_ddr4_cke               ( ddr_cke                   ),
  .c0_ddr4_odt               ( ddr_odt                   ),
  .c0_ddr4_cs_n              ( ddr_cs_n                  ),
  .c0_ddr4_ck_t              ( ddr_ck_p                  ),
  .c0_ddr4_ck_c              ( ddr_ck_n                  ),
  .c0_ddr4_reset_n           ( ddr_reset_n               ),
`ifndef XUPP3R_BOARD
  .c0_ddr4_dm_dbi_n          ( ddr_dm                    ), // dbi_n is a data bus inversion feature that cannot be used simultaneously with dm
`endif
  .c0_ddr4_dq                ( ddr_dq                    ), 
  .c0_ddr4_dqs_c             ( ddr_dqs_n                 ), 
  .c0_ddr4_dqs_t             ( ddr_dqs_p                 ), 
  .c0_init_calib_complete    ( init_calib_complete       ),
`ifdef XUPP3R_BOARD
  .c0_ddr4_parity            ( ddr_parity                ),                        // output wire c0_ddr4_parity
`endif
  .c0_ddr4_interrupt         (                           ),                    // output wire c0_ddr4_interrupt
  .c0_ddr4_aresetn           ( sys_rst_n                 ),                        // input wire c0_ddr4_aresetn
  
  .c0_ddr4_s_axi_ctrl_awvalid(1'b0                  ),  // input wire c0_ddr4_s_axi_ctrl_awvalid
  .c0_ddr4_s_axi_ctrl_awready(                      ),  // output wire c0_ddr4_s_axi_ctrl_awready
  .c0_ddr4_s_axi_ctrl_awaddr (32'b0                 ),    // input wire [31 : 0] c0_ddr4_s_axi_ctrl_awaddr
  .c0_ddr4_s_axi_ctrl_wvalid (1'b0                  ),    // input wire c0_ddr4_s_axi_ctrl_wvalid
  .c0_ddr4_s_axi_ctrl_wready (                      ),    // output wire c0_ddr4_s_axi_ctrl_wready
  .c0_ddr4_s_axi_ctrl_wdata  (32'b0                 ),      // input wire [31 : 0] c0_ddr4_s_axi_ctrl_wdata
  .c0_ddr4_s_axi_ctrl_bvalid (                      ),    // output wire c0_ddr4_s_axi_ctrl_bvalid
  .c0_ddr4_s_axi_ctrl_bready (1'b0                  ),    // input wire c0_ddr4_s_axi_ctrl_bready
  .c0_ddr4_s_axi_ctrl_bresp  (                      ),      // output wire [1 : 0] c0_ddr4_s_axi_ctrl_bresp
  .c0_ddr4_s_axi_ctrl_arvalid(1'b0                  ),  // input wire c0_ddr4_s_axi_ctrl_arvalid
  .c0_ddr4_s_axi_ctrl_arready(                      ),  // output wire c0_ddr4_s_axi_ctrl_arready
  .c0_ddr4_s_axi_ctrl_araddr (32'b0                 ),    // input wire [31 : 0] c0_ddr4_s_axi_ctrl_araddr
  .c0_ddr4_s_axi_ctrl_rvalid (                      ),    // output wire c0_ddr4_s_axi_ctrl_rvalid
  .c0_ddr4_s_axi_ctrl_rready (1'b0                  ),    // input wire c0_ddr4_s_axi_ctrl_rready
  .c0_ddr4_s_axi_ctrl_rdata  (                      ),      // output wire [31 : 0] c0_ddr4_s_axi_ctrl_rdata
  .c0_ddr4_s_axi_ctrl_rresp  (                      ),      // output wire [1 : 0] c0_ddr4_s_axi_ctrl_rresp
  
  .c0_ddr4_s_axi_awid(m_axi_awid),                  // input wire [15 : 0] c0_ddr4_s_axi_awid
  .c0_ddr4_s_axi_awaddr(m_axi_awaddr),              // input wire [34 : 0] c0_ddr4_s_axi_awaddr
  .c0_ddr4_s_axi_awlen(m_axi_awlen),                // input wire [7 : 0] c0_ddr4_s_axi_awlen
  .c0_ddr4_s_axi_awsize(m_axi_awsize),              // input wire [2 : 0] c0_ddr4_s_axi_awsize
  .c0_ddr4_s_axi_awburst(m_axi_awburst),            // input wire [1 : 0] c0_ddr4_s_axi_awburst
  .c0_ddr4_s_axi_awlock(m_axi_awlock),              // input wire [0 : 0] c0_ddr4_s_axi_awlock
  .c0_ddr4_s_axi_awcache(m_axi_awcache),            // input wire [3 : 0] c0_ddr4_s_axi_awcache
  .c0_ddr4_s_axi_awprot(m_axi_awprot),              // input wire [2 : 0] c0_ddr4_s_axi_awprot
  .c0_ddr4_s_axi_awqos(m_axi_awqos),                // input wire [3 : 0] c0_ddr4_s_axi_awqos
  .c0_ddr4_s_axi_awvalid(m_axi_awvalid),            // input wire c0_ddr4_s_axi_awvalid
  .c0_ddr4_s_axi_awready(m_axi_awready),            // output wire c0_ddr4_s_axi_awready
  .c0_ddr4_s_axi_wdata(m_axi_wdata),                // input wire [511 : 0] c0_ddr4_s_axi_wdata
  .c0_ddr4_s_axi_wstrb(m_axi_wstrb),                // input wire [63 : 0] c0_ddr4_s_axi_wstrb
  .c0_ddr4_s_axi_wlast(m_axi_wlast),                // input wire c0_ddr4_s_axi_wlast
  .c0_ddr4_s_axi_wvalid(m_axi_wvalid),              // input wire c0_ddr4_s_axi_wvalid
  .c0_ddr4_s_axi_wready(m_axi_wready),              // output wire c0_ddr4_s_axi_wready
  .c0_ddr4_s_axi_bready(m_axi_bready),              // input wire c0_ddr4_s_axi_bready
  .c0_ddr4_s_axi_bid(m_axi_bid),                    // output wire [15 : 0] c0_ddr4_s_axi_bid
  .c0_ddr4_s_axi_bresp(m_axi_bresp),                // output wire [1 : 0] c0_ddr4_s_axi_bresp
  .c0_ddr4_s_axi_bvalid(m_axi_bvalid),              // output wire c0_ddr4_s_axi_bvalid
  .c0_ddr4_s_axi_arid(m_axi_arid),                  // input wire [15 : 0] c0_ddr4_s_axi_arid
  .c0_ddr4_s_axi_araddr(m_axi_araddr),              // input wire [34 : 0] c0_ddr4_s_axi_araddr
  .c0_ddr4_s_axi_arlen(m_axi_arlen),                // input wire [7 : 0] c0_ddr4_s_axi_arlen
  .c0_ddr4_s_axi_arsize(m_axi_arsize),              // input wire [2 : 0] c0_ddr4_s_axi_arsize
  .c0_ddr4_s_axi_arburst(m_axi_arburst),            // input wire [1 : 0] c0_ddr4_s_axi_arburst
  .c0_ddr4_s_axi_arlock(m_axi_arlock),              // input wire [0 : 0] c0_ddr4_s_axi_arlock
  .c0_ddr4_s_axi_arcache(m_axi_arcache),            // input wire [3 : 0] c0_ddr4_s_axi_arcache
  .c0_ddr4_s_axi_arprot(m_axi_arprot),              // input wire [2 : 0] c0_ddr4_s_axi_arprot
  .c0_ddr4_s_axi_arqos(m_axi_arqos),                // input wire [3 : 0] c0_ddr4_s_axi_arqos
  .c0_ddr4_s_axi_arvalid(m_axi_arvalid),            // input wire c0_ddr4_s_axi_arvalid
  .c0_ddr4_s_axi_arready(m_axi_arready),            // output wire c0_ddr4_s_axi_arready
  .c0_ddr4_s_axi_rready(m_axi_rready),              // input wire c0_ddr4_s_axi_rready
  .c0_ddr4_s_axi_rlast(m_axi_rlast),                // output wire c0_ddr4_s_axi_rlast
  .c0_ddr4_s_axi_rvalid(m_axi_rvalid),              // output wire c0_ddr4_s_axi_rvalid
  .c0_ddr4_s_axi_rresp(m_axi_rresp),                // output wire [1 : 0] c0_ddr4_s_axi_rresp
  .c0_ddr4_s_axi_rid(m_axi_rid),                    // output wire [15 : 0] c0_ddr4_s_axi_rid
  .c0_ddr4_s_axi_rdata(m_axi_rdata)                 // output wire [511 : 0] c0_ddr4_s_axi_rdata
);

`endif //PITONSYS_PCIE

`else // PITONSYS_DDR4


mig_7series_axi4 u_mig_7series_axi4 (

    // Memory interface ports
    .ddr3_addr                      (ddr_addr),  // output [13:0]      ddr3_addr
    .ddr3_ba                        (ddr_ba),  // output [2:0]     ddr3_ba
    .ddr3_cas_n                     (ddr_cas_n),  // output            ddr3_cas_n
    .ddr3_ck_n                      (ddr_ck_n),  // output [0:0]       ddr3_ck_n
    .ddr3_ck_p                      (ddr_ck_p),  // output [0:0]       ddr3_ck_p
    .ddr3_cke                       (ddr_cke),  // output [0:0]        ddr3_cke
    .ddr3_ras_n                     (ddr_ras_n),  // output            ddr3_ras_n
    .ddr3_reset_n                   (ddr_reset_n),  // output          ddr3_reset_n
    .ddr3_we_n                      (ddr_we_n),  // output         ddr3_we_n
    .ddr3_dq                        (ddr_dq),  // inout [63:0]     ddr3_dq
    .ddr3_dqs_n                     (ddr_dqs_n),  // inout [7:0]       ddr3_dqs_n
    .ddr3_dqs_p                     (ddr_dqs_p),  // inout [7:0]       ddr3_dqs_p
    .init_calib_complete            (init_calib_complete),  // output           init_calib_complete
      
    .ddr3_cs_n                      (ddr_cs_n),  // output [0:0]       ddr3_cs_n
    .ddr3_dm                        (ddr_dm),  // output [7:0]     ddr3_dm
    .ddr3_odt                       (ddr_odt),  // output [0:0]        ddr3_odt

    // Application interface ports
    .ui_clk                         (ui_clk),  // output            ui_clk
    .ui_clk_sync_rst                (ui_clk_sync_rst),  // output           ui_clk_sync_rst
    .mmcm_locked                    (),  // output           mmcm_locked
    .aresetn                        (sys_rst_n),  // input            aresetn
    .app_sr_req                     (app_sr_req),  // input         app_sr_req
    .app_ref_req                    (app_ref_req),  // input            app_ref_req
    .app_zq_req                     (app_zq_req),  // input         app_zq_req
    .app_sr_active                  (app_sr_active),  // output         app_sr_active
    .app_ref_ack                    (app_ref_ack),  // output           app_ref_ack
    .app_zq_ack                     (app_zq_ack),  // output            app_zq_ack

    // Slave Interface Write Address Ports
    .s_axi_awid                     (m_axi_awid),  // input [15:0]          s_axi_awid
    .s_axi_awaddr                   (m_axi_awaddr),  // input [29:0]            s_axi_awaddr
    .s_axi_awlen                    (m_axi_awlen),  // input [7:0]          s_axi_awlen
    .s_axi_awsize                   (m_axi_awsize),  // input [2:0]         s_axi_awsize
    .s_axi_awburst                  (m_axi_awburst),  // input [1:0]            s_axi_awburst
    .s_axi_awlock                   (m_axi_awlock),  // input [0:0]         s_axi_awlock
    .s_axi_awcache                  (m_axi_awcache),  // input [3:0]            s_axi_awcache
    .s_axi_awprot                   (m_axi_awprot),  // input [2:0]         s_axi_awprot
    .s_axi_awqos                    (m_axi_awqos),  // input [3:0]          s_axi_awqos
    .s_axi_awvalid                  (m_axi_awvalid),  // input          s_axi_awvalid
    .s_axi_awready                  (m_axi_awready),  // output         s_axi_awready
    // Slave Interface Write Data Ports
    .s_axi_wdata                    (m_axi_wdata),  // input [511:0]            s_axi_wdata
    .s_axi_wstrb                    (m_axi_wstrb),  // input [63:0]         s_axi_wstrb
    .s_axi_wlast                    (m_axi_wlast),  // input            s_axi_wlast
    .s_axi_wvalid                   (m_axi_wvalid),  // input           s_axi_wvalid
    .s_axi_wready                   (m_axi_wready),  // output          s_axi_wready
    // Slave Interface Write Response Ports
    .s_axi_bid                      (m_axi_bid),  // output [15:0]          s_axi_bid
    .s_axi_bresp                    (m_axi_bresp),  // output [1:0]         s_axi_bresp
    .s_axi_bvalid                   (m_axi_bvalid),  // output          s_axi_bvalid
    .s_axi_bready                   (m_axi_bready),  // input           s_axi_bready
    // Slave Interface Read Address Ports
    .s_axi_arid                     (m_axi_arid),  // input [15:0]          s_axi_arid
    .s_axi_araddr                   (m_axi_araddr),  // input [29:0]            s_axi_araddr
    .s_axi_arlen                    (m_axi_arlen),  // input [7:0]          s_axi_arlen
    .s_axi_arsize                   (m_axi_arsize),  // input [2:0]         s_axi_arsize
    .s_axi_arburst                  (m_axi_arburst),  // input [1:0]            s_axi_arburst
    .s_axi_arlock                   (m_axi_arlock),  // input [0:0]         s_axi_arlock
    .s_axi_arcache                  (m_axi_arcache),  // input [3:0]            s_axi_arcache
    .s_axi_arprot                   (m_axi_arprot),  // input [2:0]         s_axi_arprot
    .s_axi_arqos                    (m_axi_arqos),  // input [3:0]          s_axi_arqos
    .s_axi_arvalid                  (m_axi_arvalid),  // input          s_axi_arvalid
    .s_axi_arready                  (m_axi_arready),  // output         s_axi_arready
    // Slave Interface Read Data Ports
    .s_axi_rid                      (m_axi_rid),  // output [15:0]          s_axi_rid
    .s_axi_rdata                    (m_axi_rdata),  // output [511:0]           s_axi_rdata
    .s_axi_rresp                    (m_axi_rresp),  // output [1:0]         s_axi_rresp
    .s_axi_rlast                    (m_axi_rlast),  // output           s_axi_rlast
    .s_axi_rvalid                   (m_axi_rvalid),  // output          s_axi_rvalid
    .s_axi_rready                   (m_axi_rready),  // input           s_axi_rready

    // System Clock Ports
    .sys_clk_i                      (sys_clk),
    .sys_rst                        (sys_rst_n) // input sys_rst
);

`endif // PITONSYS_DDR4
`else

    assign ui_clk_sync_rst = ~sys_rst_n;
    assign ui_clk = mc_clk;

`endif

`endif // PITONSYS_AXI4_MEM



`ifdef PITON_PROTO
`ifndef PITON_PROTO_NO_MON
`ifndef PITONSYS_AXI4_MEM

    always @(posedge ui_clk) begin
        if (app_en) begin
            $display("MC_TOP: command to MIG. Addr: 0x%x, cmd: 0x%x at", app_addr, app_cmd, $time);
        end

        if (app_wdf_wren) begin
            $display("MC_TOP: writing data 0x%x to memory at", app_wdf_data, $time);
        end

        if (app_rd_data_valid) begin
            $display("MC_TOP: read data 0x%x from memory at", app_rd_data, $time);
        end
    end

`endif  // PITONSYS_AXI4_MEM
`endif  // PITON_PROTO_NO_MON
`endif  // PITON_PROTO
`endif  // PITON_FPGA_MC_DDR3

endmodule 