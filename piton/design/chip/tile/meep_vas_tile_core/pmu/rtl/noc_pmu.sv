

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
  localparam SwapEndianess = 1;

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


logic[63:0] counter_read_data, counter_write_data;
logic[7:0] counter_read_address, counter_write_address; //TODO use parameters
logic counter_read_enable, counter_read_valid, counter_write_enable, counter_write_valid;
logic counter_read_enable_syn, counter_write_enable_syn;    // Synchronized signals
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
    
    // Data read from AXI bridge to registers
    .counter_read_enable(counter_read_enable),
    .counter_read_valid(counter_read_valid),
    .counter_read_address(counter_read_address),
    .counter_read_data(counter_read_data),

    // Data write from AXI bridge to registers
    .counter_write_enable(counter_write_enable),
    .counter_write_valid(counter_write_valid),
    .counter_write_address(counter_write_address),
    .counter_write_data(counter_write_data)
);

logic[TILE_COUNT-1:0][23:0][COUNTER_LENGTH-1:0] counters;  //23 counters + 1 config register

// Read logic
synchronyzer_2_stage read_syn(
  .in(counter_read_enable),
  .out(counter_read_enable_syn),
  .clk(counter_clk)
  );
always_ff @( counter_clk ) begin
    if(counter_read_enable_syn && ~counter_read_valid) begin
      counter_read_data <= counters[0][counter_read_address];
      counter_read_valid <= 1'b1;
    end else if(~counter_read_enable_syn) begin
      counter_read_data <= 0;
      counter_read_valid <= 1'b0;
    end
end

// Write logic
synchronyzer_2_stage write_syn(
  .in(counter_write_enable),
  .out(counter_write_enable_syn),
  .clk(counter_clk)
  );
logic[7:0] write_address;
logic[63:0] write_data;
logic write_enable;
always_ff @( counter_clk ) begin 
    if(counter_write_enable_syn) begin
      write_enable <= 1'b1;
      write_data <= counter_write_data;
      write_address <= counter_write_address;
      // Inform successfull write
      counter_write_valid <= 1'b1;
    end else begin
      write_enable <= 1'b0;
      counter_write_valid <= 1'b0;
    end
end

always_ff @( posedge counter_clk ) begin
    for(int tile = 0; tile < TILE_COUNT; tile++) begin
        logic counter_enable, counter_reset;
        counter_enable = counters[tile][23][0];
        counter_reset = counters[tile][23][1];

          // Logic for counters
          for(int signal = 0; signal < 23; signal++) begin
            if(rst == 1'b0 || counter_reset == 1'b1)
              counters[tile][signal] <= 0; // Reset logic
            else if(write_enable && write_address == signal) begin
              counters[tile][signal] <= write_data; // Write incoming data to register
            end
            else if(counter_enable == 1'b1 && pmu_sig_i[tile][signal] == 1'b1)
              counters[tile][signal] <= counters[tile][signal]+1; // Increment counters when required
          end

          // Logic for config register
          if(rst == 1'b0)
            counters[tile][23] <= 2'b01; // Reset config
          else if(write_enable && write_address == 23) begin
            counters[tile][23] <= write_data; // Write incoming data to register
          end
        
    end
        
end
    
endmodule