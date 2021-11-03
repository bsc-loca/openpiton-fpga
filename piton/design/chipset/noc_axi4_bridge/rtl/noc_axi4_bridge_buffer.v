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


module noc_axi4_bridge_buffer #(
    parameter SWAP_ENDIANESS = 0, // swap endianess, needed when used in conjunction with a little endian core like Ariane
    parameter NUM_REQ_OUTSTANDING_LOG2 = 6,
    parameter NUM_REQ_YTHREADS_LOG2 = 2,
    parameter NUM_REQ_XTHREADS_LOG2 = 2, 
    localparam NUM_REQ_THREADS_LOG2 = NUM_REQ_YTHREADS_LOG2 +
                                      NUM_REQ_XTHREADS_LOG2
) (
  input clk,
  input rst_n,

  // from deserializer
  input [`MSG_HEADER_WIDTH-1:0] deser_header,
  input [`AXI4_DATA_WIDTH-1:0] deser_data,
  input  deser_val,
  output deser_rdy,

  // read request out
  output [`MSG_HEADER_WIDTH-1:0] read_req_header,
  output [NUM_REQ_THREADS_LOG2-1:0] read_req_id,
  output read_req_val,
  input  read_req_rdy,

  // read response in
  input [`AXI4_DATA_WIDTH-1:0] read_resp_data,
  input [NUM_REQ_THREADS_LOG2-1:0] read_resp_id,
  input  read_resp_val,
  output read_resp_rdy,

  // read request out
  output [`MSG_HEADER_WIDTH-1:0] write_req_header,
  output [NUM_REQ_THREADS_LOG2-1:0] write_req_id,
  output [`AXI4_DATA_WIDTH-1:0] write_req_data,
  output write_req_val,
  input  write_req_rdy,

  // read response in
  input [NUM_REQ_THREADS_LOG2-1:0] write_resp_id,
  input  write_resp_val,
  output write_resp_rdy,

  // in serializer
  output [`MSG_HEADER_WIDTH-1:0] ser_header,
  output [`AXI4_DATA_WIDTH-1:0] ser_data,
  output ser_val,
  input  ser_rdy
);

localparam INVALID = 1'd0;
localparam WAITING = 1'd1;

localparam READ  = 1'd0;
localparam WRITE = 1'd1;


reg [`NOC_AXI4_BRIDGE_IN_FLIGHT_LIMIT-1:0]                          pkt_state_buf ;
reg [`MSG_HEADER_WIDTH-1:0]   pkt_header[`NOC_AXI4_BRIDGE_IN_FLIGHT_LIMIT-1:0];
reg [`NOC_AXI4_BRIDGE_IN_FLIGHT_LIMIT-1:0]                          pkt_command;

reg [`NOC_AXI4_BRIDGE_BUFFER_ADDR_SIZE-1:0]    fifo_in;
reg [`NOC_AXI4_BRIDGE_BUFFER_ADDR_SIZE-1:0]    fifo_out;

wire deser_go = (deser_rdy & deser_val);
wire read_req_go = (read_req_val & read_req_rdy);
// wire read_resp_go = (read_resp_val & read_resp_rdy);
wire write_req_go = (write_req_val & write_req_rdy);
// wire write_resp_go = (write_resp_val & write_resp_rdy);
wire req_go = read_req_go || write_req_go;
wire ser_go = ser_val & ser_rdy;

//
//  SEND REQUESTS 
//

always @(posedge clk) begin
    if(~rst_n) begin
        fifo_in <= {`NOC_AXI4_BRIDGE_BUFFER_ADDR_SIZE{1'b0}};
        fifo_out <= {`NOC_AXI4_BRIDGE_BUFFER_ADDR_SIZE{1'b0}};
    end 
    else begin
        fifo_in <= deser_go ? fifo_in + 1 : fifo_in;
        fifo_out <= req_go ? fifo_out + 1 : fifo_out;
    end
end


genvar i;
generate 
    for (i = 0; i < `NOC_AXI4_BRIDGE_IN_FLIGHT_LIMIT; i = i + 1) begin
        always @(posedge clk) begin
            if(~rst_n) begin
                pkt_state_buf[i] <= INVALID;
                pkt_header[i] <= `MSG_HEADER_WIDTH'b0;
                pkt_command[i] <= 1'b0;
            end 
            else begin
                if ((i == fifo_in) & deser_go) begin
                    pkt_state_buf[i] <= WAITING;
                    pkt_header[i] <= deser_header;
                    pkt_command[i] <= (deser_header[`MSG_TYPE] == `MSG_TYPE_STORE_MEM) 
                                   || (deser_header[`MSG_TYPE] == `MSG_TYPE_NC_STORE_REQ);
                end
                else if ((i == fifo_out) & req_go) begin
                      pkt_state_buf[i] <= INVALID;
                      pkt_header[i] <= `MSG_HEADER_WIDTH'b0;
                      pkt_command[i] <= 1'b0;
                end
                else begin
                    pkt_state_buf[i] <= pkt_state_buf[i];
                    pkt_header[i] <= pkt_header[i];
                    pkt_command[i] <= pkt_command[i];
                end
            end
        end
    end
endgenerate

assign deser_rdy = (pkt_state_buf[fifo_in] == INVALID);

// Xilinx-synthesizable Simple Dual Port Single Clock RAM
xilinx_simple_dual_port_1_clock_ram #(
    .RAM_WIDTH(`AXI4_DATA_WIDTH),                 // Specify RAM data width
    .RAM_DEPTH(`NOC_AXI4_BRIDGE_IN_FLIGHT_LIMIT), // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("LOW_LATENCY")               // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
) noc_axi4_bridge_sram_data (
    .addra(fifo_in),        // Write address bus, width determined from RAM_DEPTH
    .addrb(fifo_out),       // Read address bus, width determined from RAM_DEPTH
    .dina(deser_data),      // RAM input data, width determined from RAM_WIDTH
    .clka(clk),             // Clock
    .wea(deser_go),         // Write enable
    .enb(1'b1),             // Read Enable, for additional power savings, disable when not in use
    .rstb(~rst_n),          // Output reset (does not affect memory contents)
    .regceb(1'b1),          // Output register enable
    .doutb(write_req_data)  // RAM output data, width determined from RAM_WIDTH
);


//
// GET_RESPONSE
//

localparam NUM_REQ_THREADS = 1 << (NUM_REQ_THREADS_LOG2 + 1); // read/write request type go as an extension to thread ID
reg [NUM_REQ_OUTSTANDING_LOG2 : 0] outstnd_vrt_wrptrs[NUM_REQ_THREADS-1 : 0];
reg [NUM_REQ_OUTSTANDING_LOG2 : 0] outstnd_vrt_rdptrs[NUM_REQ_THREADS-1 : 0];

reg [NUM_REQ_THREADS-1      : 0] outstnd_vrt_empt;
reg [NUM_REQ_THREADS_LOG2+1 : 0] itr_empt;
always @(*)
  for (itr_empt = 0; itr_empt < NUM_REQ_THREADS; itr_empt = itr_empt+1)
    outstnd_vrt_empt[itr_empt] = (outstnd_vrt_rdptrs[itr_empt] == outstnd_vrt_wrptrs[itr_empt]);


reg  [NUM_REQ_THREADS_LOG2 : 0] full_resp_id;
reg  [NUM_REQ_OUTSTANDING_LOG2-1 : 0] outstnd_abs_rdptrs[NUM_REQ_THREADS-1 : 0];
wire [NUM_REQ_OUTSTANDING_LOG2-1 : 0] outstnd_abs_rdptr = outstnd_abs_rdptrs[full_resp_id];

reg init_outstnd_mem;
always @(posedge clk)
  if(~rst_n) init_outstnd_mem <= 1'b1;
  else if (outstnd_abs_rdptr == {NUM_REQ_OUTSTANDING_LOG2{1'b1}}) init_outstnd_mem <= 1'b0;


reg [NUM_REQ_THREADS-1 : 0] outstnd_abs_rdptrs_val;
always @(posedge clk)
  if(~rst_n || init_outstnd_mem) full_resp_id <= {(NUM_REQ_THREADS_LOG2+1){1'b0}};
  else if (outstnd_vrt_empt[full_resp_id] || outstnd_abs_rdptrs_val[full_resp_id]) begin
    // higher priority for Read response
    if (write_resp_val) full_resp_id <= {WRITE,write_resp_id};
    if (read_resp_val ) full_resp_id <= {READ ,read_resp_id };
  end


localparam OUTSTND_HDR_WIDTH = NUM_REQ_OUTSTANDING_LOG2 + 1 + `MSG_HEADER_WIDTH;
wire [OUTSTND_HDR_WIDTH-1 : 0] clean_header;
wire req_occup = clean_header[`MSG_HEADER_WIDTH];

reg  [NUM_REQ_OUTSTANDING_LOG2-1 : 0] outstnd_abs_wrptr;
wire [NUM_REQ_OUTSTANDING_LOG2-1 : 0] outstnd_abs_wrptr_mem = outstnd_abs_wrptr + {{(NUM_REQ_OUTSTANDING_LOG2-1){1'b0}},
                                                                                   (~init_outstnd_mem & req_occup)};
always @(posedge clk)
  if(~rst_n) outstnd_abs_wrptr <= {NUM_REQ_OUTSTANDING_LOG2{1'b0}};
  else outstnd_abs_wrptr <= outstnd_abs_wrptr_mem; // searching for first free request location


wire [`MSG_HEADER_WIDTH-1 :0] req_header  = pkt_header [fifo_out];
wire                          req_command = pkt_command[fifo_out];
wire [`MSG_SRC_X_WIDTH-1:0] req_src_x = req_header[`MSG_SRC_X];
wire [`MSG_SRC_Y_WIDTH-1:0] req_src_y = req_header[`MSG_SRC_Y];
wire [NUM_REQ_THREADS_LOG2-1:0] req_id = {req_src_y[NUM_REQ_YTHREADS_LOG2-1:0],
                                          req_src_x[NUM_REQ_XTHREADS_LOG2-1:0]};
wire [NUM_REQ_THREADS_LOG2 : 0] full_req_id = {req_command, req_id};
wire [NUM_REQ_OUTSTANDING_LOG2-1 : 0] outstnd_vrt_wrptr = outstnd_vrt_wrptrs[full_req_id];

wire [OUTSTND_HDR_WIDTH-1 : 0] stor_header;
wire stor_command = (stor_header[`MSG_TYPE] == `MSG_TYPE_STORE_MEM) ||
                    (stor_header[`MSG_TYPE] == `MSG_TYPE_NC_STORE_REQ);
wire [`MSG_SRC_X_WIDTH-1:0] stor_src_x = stor_header[`MSG_SRC_X];
wire [`MSG_SRC_Y_WIDTH-1:0] stor_src_y = stor_header[`MSG_SRC_Y];
wire [NUM_REQ_THREADS_LOG2-1:0] stor_id = {stor_src_y[NUM_REQ_YTHREADS_LOG2-1:0],
                                           stor_src_x[NUM_REQ_XTHREADS_LOG2-1:0]};
wire [NUM_REQ_THREADS_LOG2 : 0] full_stor_id = {stor_command, stor_id};

wire outstnd_vrt_rdptr_val = (outstnd_abs_rdptrs_val[full_resp_id] ||
                             (outstnd_vrt_rdptrs    [full_resp_id] == stor_header[OUTSTND_HDR_WIDTH-1 : `MSG_HEADER_WIDTH+1] &&
                              full_stor_id ==        full_resp_id  && stor_header[`MSG_HEADER_WIDTH]));
wire [NUM_REQ_OUTSTANDING_LOG2-1 : 0] outstnd_abs_rdptr_mem = outstnd_abs_rdptr + {{(NUM_REQ_OUTSTANDING_LOG2-1){1'b0}},
                                                                                   (~outstnd_vrt_empt[full_resp_id] &
                                                                                    ~outstnd_vrt_rdptr_val)};
reg [NUM_REQ_THREADS_LOG2+1 : 0] itr_ptr;
always @(posedge clk)
  if(~rst_n) begin
    for (itr_ptr = 0; itr_ptr < NUM_REQ_THREADS; itr_ptr = itr_ptr+1) begin
      outstnd_vrt_wrptrs[itr_ptr] <= {(NUM_REQ_OUTSTANDING_LOG2+1){1'b0}};
      outstnd_vrt_rdptrs[itr_ptr] <= {(NUM_REQ_OUTSTANDING_LOG2+1){1'b0}};
      outstnd_abs_rdptrs[itr_ptr] <= { NUM_REQ_OUTSTANDING_LOG2   {1'b0}};
      outstnd_abs_rdptrs_val[itr_ptr] <= 1'b0;
    end
  end
  else begin
    if (req_go) begin 
      outstnd_vrt_wrptrs[full_req_id] <= outstnd_vrt_wrptrs[full_req_id] + 1;
      if (outstnd_vrt_empt[full_req_id]) begin
        outstnd_abs_rdptrs[full_req_id] <= outstnd_abs_wrptr;
        outstnd_abs_rdptrs_val[full_req_id] <= 1'b1;
      end
    end
    if (!outstnd_vrt_empt[full_resp_id]) begin
      if (outstnd_vrt_rdptr_val) outstnd_abs_rdptrs_val[full_resp_id] <= 1'b1;
      // searching for the next valid request location for responded ID
      outstnd_abs_rdptrs[full_resp_id] <= outstnd_abs_rdptr_mem;
    end
    if (ser_go) begin 
      outstnd_vrt_rdptrs    [full_resp_id] <= outstnd_vrt_rdptrs[full_resp_id] + 1;
      outstnd_abs_rdptrs_val[full_resp_id] <= 1'b0;
    end
    // Initialization of Outstanding requests memory
    if (init_outstnd_mem) outstnd_abs_rdptrs[full_resp_id] <= outstnd_abs_rdptrs[full_resp_id] +1;
  end


assign read_req_val  = (pkt_state_buf[fifo_out] == WAITING) && !req_command && !req_occup && !init_outstnd_mem;
assign read_req_header = req_header;
assign read_req_id = req_id;

assign write_req_val = (pkt_state_buf[fifo_out] == WAITING) &&  req_command && !req_occup && !init_outstnd_mem;
assign write_req_header = req_header;
assign write_req_id = req_id;


// Xilinx-synthesizable True Dual Port RAM, No Change, Single Clock
xilinx_true_dual_port_write_first_1_clock_ram #(
    .RAM_WIDTH(OUTSTND_HDR_WIDTH),    // Specify RAM data width
    .RAM_DEPTH(1<<NUM_REQ_OUTSTANDING_LOG2), // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("LOW_LATENCY")   // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
) outstnd_req_mem (
    .addra(outstnd_abs_rdptr_mem),    // Port A address bus, width determined from RAM_DEPTH
    .addrb(outstnd_abs_wrptr_mem),    // Port B address bus, width determined from RAM_DEPTH
    .dina({OUTSTND_HDR_WIDTH{1'b0}}), // Port A RAM input data, width determined from RAM_WIDTH
    .dinb({outstnd_vrt_wrptr,1'b1,req_header}), // Port B RAM input data, width determined from RAM_WIDTH
    .clka(clk),                       // Clock
    .wea(ser_go | init_outstnd_mem),  // Port A write enable
    .web(req_go),                     // Port B write enable
    .ena(1'b1),                       // Port A RAM Enable, for additional power savings, disable port when not in use
    .enb(1'b1),                       // Port B RAM Enable, for additional power savings, disable port when not in use
    .rsta(~rst_n),                    // Port A output reset (does not affect memory contents)
    .rstb(~rst_n),                    // Port B output reset (does not affect memory contents)
    .regcea(1'b1),                    // Port A output register enable
    .regceb(1'b1),                    // Port B output register enable
    .douta(stor_header),              // Port A RAM output data, width determined from RAM_WIDTH
    .doutb(clean_header)              // Port B RAM output data, width determined from RAM_WIDTH
);

reg resp_val;
always @(posedge clk)
  if(~rst_n) resp_val <= 1'b0;
  else begin
    if (write_resp_val |
        read_resp_val) resp_val <= 1'b1;
    if (ser_go)        resp_val <= 1'b0;
  end
wire outstnd_abs_rdptr_val = outstnd_abs_rdptrs_val[full_resp_id] & resp_val;

reg stor_hdr_val;
always @(posedge clk)
  if(~rst_n) stor_hdr_val <= 1'b0;
  else       stor_hdr_val <= outstnd_abs_rdptr_val;
wire stor_hdr_en = stor_hdr_val & outstnd_abs_rdptr_val;

assign read_resp_rdy  = stor_hdr_en & ser_rdy & ~full_resp_id[NUM_REQ_THREADS_LOG2];
assign write_resp_rdy = stor_hdr_en & ser_rdy &  full_resp_id[NUM_REQ_THREADS_LOG2];

// correction of read responsed data according to stored outstanding request
wire [`PHY_ADDR_WIDTH-1:0] virt_addr = stor_header[`MSG_ADDR];
wire uncacheable = (virt_addr[`PHY_ADDR_WIDTH-1]) || (stor_header[`MSG_TYPE] == `MSG_TYPE_NC_LOAD_REQ);
wire [5:0] offset = uncacheable ? virt_addr[5:0] : 6'b0;
wire [`AXI4_DATA_WIDTH-1:0] rdata_offseted = read_resp_data >> (8*offset);

reg [6:0] size;
always @(*)
  if (uncacheable)
    case (stor_header[`MSG_DATA_SIZE])
      `MSG_DATA_SIZE_0B:  size = 7'd0;
      `MSG_DATA_SIZE_1B:  size = 7'd1;
      `MSG_DATA_SIZE_2B:  size = 7'd2;
      `MSG_DATA_SIZE_4B:  size = 7'd4;
      `MSG_DATA_SIZE_8B:  size = 7'd8;
      `MSG_DATA_SIZE_16B: size = 7'd16;
      `MSG_DATA_SIZE_32B: size = 7'd32;
      `MSG_DATA_SIZE_64B: size = 7'd64;
      default:            size = 7'b0; // should never end up here
    endcase
  else                    size = 7'd64;

reg [`AXI4_DATA_WIDTH-1:0] rdata_swapped;
// wire [5:0] swap_grnlty = size - 7'h1;
// following code produces less LUTs
wire [5:0] swap_grnlty = size[0] ? 6'd0  :
                         size[1] ? 6'd1  :
                         size[2] ? 6'd3  :
                         size[3] ? 6'd7  :
                         size[4] ? 6'd15 :
                         size[5] ? 6'd31 :
                                   6'd63;
reg [6:0] itr_swp;
always @(*) begin
  if (SWAP_ENDIANESS) begin
    rdata_swapped = {`AXI4_DATA_WIDTH{1'b0}};
    for (itr_swp = 0; itr_swp <= swap_grnlty; itr_swp = itr_swp+1)
      rdata_swapped[itr_swp*8 +: 8] = rdata_offseted[(swap_grnlty - itr_swp)*8 +: 8];
  end
  else rdata_swapped = rdata_offseted;
end

reg [`AXI4_DATA_WIDTH-1:0] resp_data;
always @(*)
  case (size)
    7'd0:    resp_data <= {`AXI4_DATA_WIDTH    {1'b0}};
    7'd1:    resp_data <= {`AXI4_DATA_WIDTH/8  {rdata_swapped[7  :0]}};
    7'd2:    resp_data <= {`AXI4_DATA_WIDTH/16 {rdata_swapped[15 :0]}};
    7'd4:    resp_data <= {`AXI4_DATA_WIDTH/32 {rdata_swapped[31 :0]}};
    7'd8:    resp_data <= {`AXI4_DATA_WIDTH/64 {rdata_swapped[63 :0]}};
    7'd16:   resp_data <= {`AXI4_DATA_WIDTH/128{rdata_swapped[127:0]}};
    7'd32:   resp_data <= {`AXI4_DATA_WIDTH/256{rdata_swapped[255:0]}};
    default: resp_data <= {`AXI4_DATA_WIDTH/512{rdata_swapped[511:0]}};
  endcase

assign ser_val = stor_hdr_en & (read_resp_val | write_resp_val);
assign ser_data = read_resp_val ? resp_data : 0; // higher priority for Read response
assign ser_header = stor_header;


/*
ila_buffer ila_buffer (
  .clk(clk), // input wire clk


  .probe0(deser_header), // input wire [191:0]  probe0  
  .probe1(deser_data), // input wire [511:0]  probe1 
  .probe2(deser_val), // input wire [0:0]  probe2 
  .probe3(deser_rdy), // input wire [0:0]  probe3 
  .probe4(ser_header), // input wire [191:0]  probe4 
  .probe5(ser_data), // input wire [511:0]  probe5 
  .probe6(ser_val), // input wire [0:0]  probe6 
  .probe7(ser_rdy), // input wire [0:0]  probe7 
  .probe8(read_req_header), // input wire [191:0]  probe8 
  .probe9(read_req_id), // input wire [1:0]  probe9 
  .probe10(read_req_val), // input wire [0:0]  probe10 
  .probe11(read_req_rdy), // input wire [0:0]  probe11 
  .probe12(read_resp_data), // input wire [511:0]  probe12 
  .probe13(read_resp_id), // input wire [1:0]  probe13 
  .probe14(read_resp_val), // input wire [0:0]  probe14 
  .probe15(read_resp_rdy), // input wire [0:0]  probe15 
  .probe16(write_req_header), // input wire [191:0]  probe16 
  .probe17(write_req_id), // input wire [1:0]  probe17 
  .probe18(write_req_data), // input wire [511:0]  probe18 
  .probe19(write_req_val), // input wire [0:0]  probe19 
  .probe20(write_req_rdy), // input wire [0:0]  probe20 
  .probe21(write_resp_id), // input wire [1:0]  probe21 
  .probe22(write_resp_val), // input wire [0:0]  probe22 
  .probe23(write_resp_rdy), // input wire [0:0]  probe23 
  .probe24(fifo_in), // input wire [1:0]  probe24 
  .probe25(fifo_out), // input wire [1:0]  probe25 
  .probe26(preser_arb), // input wire [0:0]  probe26 
  .probe27(bram_rdy), // input wire [3:0]  probe27 
  .probe28(ser_data_f), // input wire [511:0]  probe28 
  .probe29(ser_header_f), // input wire [191:0]  probe29 
  .probe30(ser_val_f), // input wire [0:0]  probe30 
  .probe31(ser_data_ff), // input wire [511:0]  probe31 
  .probe32(ser_header_ff), // input wire [191:0]  probe32 
  .probe33(ser_val_ff), // input wire [0:0]  probe33 
  .probe34(rst_n) // input wire [0:0]  probe34
);

reg [159:0] reqresp_count;
always @(posedge clk) begin
    if (~rst_n) begin
        reqresp_count <= 0;
    end
    else begin
        reqresp_count <= ser_go & deser_go ? reqresp_count     : 
                                   deser_go ? reqresp_count + 1 :
                                   ser_go ? reqresp_count - 1 : 
                                             reqresp_count;

    end
end

ila_axi_protocol_checker ila_axi_protocol_checker (
    .clk(clk), // input wire clk

    .probe0(rst_n), // input wire [0:0]  probe0  
    .probe1(reqresp_count) // input wire [159:0]  probe1
);
*/

endmodule
