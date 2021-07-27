

`include "define.tmp.h"

module noc_pmu #(
    parameter TILE_COUNT,
    parameter int unsigned DataWidth = 64,

    localparam COUNTER_LENGTH = 64     // Use 64bit counters
) (
    input rst,

    input noc_clk,
    input[DataWidth-1:0] buf_noc2_data_i,
    input buf_noc2_valid_i,
    output buf_noc2_ready_o,
    output[DataWidth-1:0] buf_noc3_data_o,
    output buf_noc3_valid_o,
    input buf_noc3_ready_i,

    input counter_clk,
    input[TILE_COUNT-1:0][22:0] pmu_sig_i
);


  localparam int unsigned AxiIdWidth    =  1;
  localparam int unsigned AxiAddrWidth  = 64;
  localparam int unsigned AxiDataWidth  = 64;
  localparam int unsigned AxiUserWidth  =  1;
  localparam SwapEndianess = 0;

  AXI_BUS #(
    .AXI_ID_WIDTH   ( AxiIdWidth   ),
    .AXI_ADDR_WIDTH ( AxiAddrWidth ),
    .AXI_DATA_WIDTH ( AxiDataWidth ),
    .AXI_USER_WIDTH ( AxiUserWidth )
  ) plic_master();

  noc_axilite_bridge #(
    // this enables variable width accesses
    // note that the accesses are still 64bit, but the
    // write-enables are generated according to the access size
    .SLAVE_RESP_BYTEWIDTH   ( 0             ),
    .SWAP_ENDIANESS         ( SwapEndianess ),
    // this disables shifting of unaligned read data
    .ALIGN_RDATA            ( 0             )
  ) i_plic_axilite_bridge (
    .clk                    ( noc_clk                        ),
    .rst                    ( ~rst                      ),       // Inverse??
    // to/from NOC
    .splitter_bridge_val    ( buf_noc2_valid_i ),
    .splitter_bridge_data   ( buf_noc2_data_i  ),
    .bridge_splitter_rdy    ( buf_noc2_ready_o ),
    .bridge_splitter_val    ( buf_noc3_valid_o ),
    .bridge_splitter_data   ( buf_noc3_data_o  ),
    .splitter_bridge_rdy    ( buf_noc3_ready_i ),
    //axi lite signals
    //write address channel
    .m_axi_awaddr           ( plic_master.aw_addr               ),
    .m_axi_awvalid          ( plic_master.aw_valid              ),
    .m_axi_awready          ( plic_master.aw_ready              ),
    //write data channel
    .m_axi_wdata            ( plic_master.w_data                ),
    .m_axi_wstrb            ( plic_master.w_strb                ),
    .m_axi_wvalid           ( plic_master.w_valid               ),
    .m_axi_wready           ( plic_master.w_ready               ),
    //read address channel
    .m_axi_araddr           ( plic_master.ar_addr               ),
    .m_axi_arvalid          ( plic_master.ar_valid              ),
    .m_axi_arready          ( plic_master.ar_ready              ),
    //read data channel
    .m_axi_rdata            ( plic_master.r_data                ),
    .m_axi_rresp            ( plic_master.r_resp                ),
    .m_axi_rvalid           ( plic_master.r_valid               ),
    .m_axi_rready           ( plic_master.r_ready               ),
    //write response channel
    .m_axi_bresp            ( plic_master.b_resp                ),
    .m_axi_bvalid           ( plic_master.b_valid               ),
    .m_axi_bready           ( plic_master.b_ready               ),
    // non-axi-lite signals
    .w_reqbuf_size          ( plic_master.aw_size               ),
    .r_reqbuf_size          ( plic_master.ar_size               )
  );


logic[63:0] req_counter_data;
logic[7:0] req_counter_addr; //TODO use parameters
axi_pmu axi_pmu(
    .S_AXI_ACLK(noc_clk),
    .S_AXI_ARESETN(rst),
    .S_AXI_AWADDR(plic_master.aw_addr),
    .S_AXI_AWPROT(),
    .S_AXI_AWVALID(plic_master.aw_valid),
    .S_AXI_AWREADY(plic_master.aw_ready),
    .S_AXI_WDATA(plic_master.w_data),
    .S_AXI_WSTRB(plic_master.w_strb),
    .S_AXI_WVALID(plic_master.w_valid),
    .S_AXI_WREADY(plic_master.w_ready),
    .S_AXI_BRESP(plic_master.b_resp),
    .S_AXI_BVALID(plic_master.b_valid),
    .S_AXI_BREADY(plic_master.b_ready),
    .S_AXI_ARADDR(plic_master.ar_addr),
    .S_AXI_ARPROT(plic_master.ar_prot),
    .S_AXI_ARVALID(plic_master.ar_valid),
    .S_AXI_ARREADY(plic_master.ar_ready),
    .S_AXI_RDATA(plic_master.r_data),
    .S_AXI_RRESP(plic_master.r_resp),
    .S_AXI_RVALID(plic_master.r_valid),
    .S_AXI_RREADY(plic_master.r_ready),

    .counter_data_in(req_counter_data),
    .counter_address_out(req_counter_addr)
);

logic[TILE_COUNT-1:0][22:0][COUNTER_LENGTH-1:0] counters;

always_comb begin
    if(0'b0)begin
        
    end   //TODO check if out of bounds
    else begin
        req_counter_data = counters[0][req_counter_addr];
    end
end

always_ff @( counter_clk ) begin

    for(int tile = 0; tile < TILE_COUNT; tile++)
        for(int signal = 0; signal < 23; signal++) begin
            if(rst == 1'b0)
                counters[tile][signal] = 0;
            else if(pmu_sig_i[tile][signal] == 1'b1)
                counters[tile][signal] = counters[tile][signal]+1;
        end
        
end
    
endmodule