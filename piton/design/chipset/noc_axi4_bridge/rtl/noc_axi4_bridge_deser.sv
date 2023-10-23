// Modified by Barcelona Supercomputing Center on March 3rd, 2022
// ========== Copyright Header Begin ============================================
// Copyright (c) 2019 Princeton University
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

`include "mc_define.h"
`include "define.tmp.h"
`include "noc_axi4_bridge_define.vh"


module noc_axi4_bridge_deser #(
  parameter SWAP_ENDIANESS = 0, // swap endianess, needed when used in conjunction with a little endian core like Ariane
  parameter NOC2AXI_DESER_ORDER = 0 // NOC words to AXI word deserialization order
) (
  input clk, 
  input rst_n, 

  input [`NOC_DATA_WIDTH-1:0] flit_in, 
  input  flit_in_val, 
  output flit_in_rdy, 
  input phy_init_done,

  output [`MSG_HEADER_WIDTH-1:0] header_out, 
  output reg [`AXI4_DATA_WIDTH-1:0] data_out, 
  output out_val, 
  input  out_rdy
);

localparam ACCEPT_W1   = 3'd0;
localparam ACCEPT_W2   = 3'd1;
localparam ACCEPT_W3   = 3'd2;
localparam ACCEPT_DATA = 3'd3;
localparam SEND        = 3'd4;

reg [`NOC_DATA_WIDTH-1:0]           pkt_w1;
reg [`NOC_DATA_WIDTH-1:0]           pkt_w2;
reg [`NOC_DATA_WIDTH-1:0]           pkt_w3; 
reg [`NOC_DATA_WIDTH-1:0]           in_data_buf[`PAYLOAD_LEN-1:0]; //buffer for incomming packets
reg [`MSG_LENGTH_WIDTH-1:0]         remaining_flits; //flits remaining in current packet
reg [2:0]                           state;

assign flit_in_rdy = (state != SEND) & phy_init_done;
wire flit_in_go = flit_in_val & flit_in_rdy;
assign out_val = (state == SEND);

reg [$clog2(`AXI4_DATA_WIDTH/8)-1:0] dat_offset;
reg [`MSG_DATA_SIZE_WIDTH      -1:0] dat_size_log;
always @(*) noc_extractSize(header_out, dat_size_log, dat_offset);
wire [`NOC_DATA_WIDTH -1:0] data_swapped = SWAP_ENDIANESS ? swapData(flit_in, dat_size_log) :
                                                                     flit_in;
always @(posedge clk)
  if(~rst_n) state <= ACCEPT_W1;
  else
    case (state)
      ACCEPT_W1: begin
        if (flit_in_go) begin
          state <= ACCEPT_W2;
          remaining_flits <= flit_in[`MSG_LENGTH]-1;
          pkt_w1 <= flit_in;  
        end
      end
      ACCEPT_W2: begin
        if (flit_in_go) begin
          state <= ACCEPT_W3;
          remaining_flits <= remaining_flits - 1;
          pkt_w2 <= flit_in;
        end
      end
      ACCEPT_W3: begin
        if (flit_in_go) begin
          if (remaining_flits == 0)
            state <= SEND;
          else begin
            state <= ACCEPT_DATA;
            remaining_flits <= remaining_flits - 1;
          end
          pkt_w3 <= flit_in;  
        end
      end
      ACCEPT_DATA: begin
        if (flit_in_go) begin
          if (remaining_flits == 0)
            state <= SEND;
          else begin
            state <= ACCEPT_DATA;
            remaining_flits <= remaining_flits - 1;
          end
        end
        if (flit_in_val)
          in_data_buf[remaining_flits] <= data_swapped;
      end
      SEND: begin
        if (out_rdy)
          state <= ACCEPT_W1;
      end
      default: begin
        // should never end up here
        state <= 3'bX;
        remaining_flits <= `MSG_LENGTH_WIDTH'bX;
        pkt_w1 <= `NOC_DATA_WIDTH'bX;
        pkt_w2 <= `NOC_DATA_WIDTH'bX;
        pkt_w3 <= `NOC_DATA_WIDTH'bX;
      end
    endcase // state

assign header_out = {pkt_w3, pkt_w2, pkt_w1};

reg [$clog2(`PAYLOAD_LEN) :0] itr_flt;
always @(*)
  for (itr_flt = 0; itr_flt <= (`PAYLOAD_LEN-1); itr_flt = itr_flt+1)
    data_out[itr_flt * `NOC_DATA_WIDTH +: `NOC_DATA_WIDTH] = NOC2AXI_DESER_ORDER ? in_data_buf[                  itr_flt] :
                                                                                   in_data_buf[`PAYLOAD_LEN -1 - itr_flt];

endmodule
