`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2022 10:15:26 PM
// Design Name: 
// Module Name: simulations
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "define.tmp.h"
`include "noc_axi4_bridge_define.vh"

/*`define PHY_ADDR_WIDTH          40
`define MSG_ADDR                119:80

`define AXI4_DATA_WIDTH 512
`define AXI4_STRB_WIDTH  64*/


module simulations(

    );
    
   wire uncacheable_load;
   reg [31:0] dIn = 32'h76543210;
   reg [31:0] dOut;
   reg [`AXI4_DATA_WIDTH-1:0]   wdata = 0;
   reg [`MSG_HEADER_WIDTH-1 :0] stor_header = 0;
    
    localparam period = 20;
    localparam  integer FLIP_WIDTH = 64;
    
   wire [FLIP_WIDTH-1:0] data2Flip = 64'h12345678ABCDEF90;
   wire [FLIP_WIDTH-1:0] FlippedData;

    
     initial // initial block executes only once
        begin
            // values for a and b
            stor_header = 0;
            
            #period; // wait for period
            stor_header = 40'h0040000000;
            #period; 
            stor_header = 40'h0080000000;
            #period;
            stor_header = 40'h0040C00000;
            dOut = swapNibble(dIn);
          
        end
    
    
   assign uncacheable_load = ((stor_header[39:0] >= 40'h0040000000) & (stor_header[39:0] < 40'h0080000000));
   
function automatic [`AXI4_DATA_WIDTH-1:0] swapNibble;
   input reg [`AXI4_DATA_WIDTH-1:0] DataIn;
   reg [5:0] itLen;
   integer i;
   begin  
   
   itLen = 6'd32;
   
   for (i=0; i < 32; i = i + 1)
     swapNibble[8*i +: 8] = { DataIn[8*i +: 4], DataIn[8*i+4 +: 4]};      
   end 
      
   
  endfunction
  
  
  UUT_bridge UUT_bridge_inst (  
    .wdata (wdata),
    .stor_header (stor_header),
    .write_req_data (write_req_data),
    .write_req_strb (write_req_strb)  
  ); 
  
  wordFlip #(
   .DATA_WIDTH (64)
   ) wordFlip_i (
    .dataIn( data2Flip),
    .dataOut( FlippedData)
   );
  
  
  

 endmodule
  
 module UUT_bridge # (
 
 parameter integer ola = 1,
 parameter SWAP_ENDIANESS = 0
 
 ) ( 
 input  [`AXI4_DATA_WIDTH-1: 0] wdata,
 input  [`MSG_HEADER_WIDTH-1:0] stor_header,
 output [`AXI4_DATA_WIDTH-1: 0] write_req_data,
 output [`AXI4_STRB_WIDTH-1: 0] write_req_strb
 );
  
  reg wr_uncacheable;
  reg [6:0] wr_size;
  reg [$clog2(`AXI4_DATA_WIDTH/8)-1:0] wr_offset;
  
  wire [`MSG_HEADER_WIDTH-1 :0] req_header = stor_header;
  
  always @(*) extractSize(req_header, wr_size, wr_offset, wr_uncacheable);
  
  wire [`AXI4_DATA_WIDTH-1:0] wdata_swapped = SWAP_ENDIANESS ? swapData(wdata, wr_size) :
                                                                        wdata;
  
  wire [`AXI4_DATA_WIDTH-1:0] wdata_flipped = wr_uncacheable ? swapData(wdata_swapped, 7'b1000000) : 
  								      wdata_swapped;
  
  // wire [`AXI4_STRB_WIDTH-1:0] wstrb = ({`AXI4_STRB_WIDTH'h0,1'b1} << wr_size) -`AXI4_STRB_WIDTH'h1;
  wire [`AXI4_STRB_WIDTH-1:0] wstrb = wr_size[0] ? { 1{1'b1}} :
                                      wr_size[1] ? { 2{1'b1}} :
                                      wr_size[2] ? { 4{1'b1}} :
                                      wr_size[3] ? { 8{1'b1}} :
                                      wr_size[4] ? {16{1'b1}} :
                                      wr_size[5] ? {32{1'b1}} :
                                      wr_size[6] ? {64{1'b1}} :
                                      `AXI4_DATA_WIDTH'h0;
                                      
  wire [`AXI4_STRB_WIDTH-1:0] wstrb_flipped =  wr_uncacheable ? swapData(wstrb, wr_size) : wstrb;  
  
  wire [`AXI4_DATA_WIDTH -1:0] debug_req_data;                             
  
  assign debug_req_data = wdata_swapped << (8*wr_offset);
  
  assign write_req_data = wdata_flipped << (8*wr_offset);
  assign write_req_strb = wstrb         <<    wr_offset;
  
  function automatic [`AXI4_DATA_WIDTH-1:0] swapData;
  input [`AXI4_DATA_WIDTH-1:0] data;
  input [6:0] size;
  reg [$clog2(`AXI4_DATA_WIDTH/8)-1:0] swap_grnlty;
  reg [$clog2(`AXI4_DATA_WIDTH/8)  :0] itr_swp;
  begin
  // swap_grnlty = size - 7'h1;
  // the following code produces less LUTs
  swap_grnlty = size[0] ? 6'd0  :
                size[1] ? 6'd1  :
                size[2] ? 6'd3  :
                size[3] ? 6'd7  :
                size[4] ? 6'd15 :
                size[5] ? 6'd31 :
                          6'd63;
  swapData = `AXI4_DATA_WIDTH'h0;
  for (itr_swp = 0; itr_swp <= swap_grnlty; itr_swp = itr_swp+1)
    swapData[itr_swp*8 +: 8] = data[(swap_grnlty - itr_swp)*8 +: 8];
  end
endfunction

task automatic extractSize;
  input  [`MSG_HEADER_WIDTH-1 :0] header;
  output [6:0] size;
  output [$clog2(`AXI4_DATA_WIDTH/8)-1:0] offset;
  output uncacheable;
  reg [`PHY_ADDR_WIDTH-1:0] virt_addr;
  reg uncacheable;
  begin
  virt_addr = header[`MSG_ADDR];
  uncacheable = (virt_addr[`PHY_ADDR_WIDTH-1]) ||
                (header[`MSG_TYPE] == `MSG_TYPE_NC_LOAD_REQ) ||
                (header[`MSG_TYPE] == `MSG_TYPE_NC_STORE_REQ) ||
	            (header[`MSG_ADDR] >= 64'h40000000) && (header[`MSG_ADDR] < 64'h80000000);
  if (uncacheable)
    case (header[`MSG_DATA_SIZE])
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
  offset = uncacheable ? virt_addr : 0;  
  end
  
endtask

    
    
endmodule
