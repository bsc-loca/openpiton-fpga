// This module flips every nibble inside a word (32 bits)
// It starts over for each word

module wordFlip #(
    parameter integer DATA_WIDTH = 256
) (
    input      [DATA_WIDTH-1:0] dataIn,
    output reg [DATA_WIDTH-1:0] dataOut // Nibble-wise flip every word
);


function automatic [31:0] swapNibbles;
  input reg [31:0] wordIn;
  reg [4:0] itLen;
  integer i;

  begin  

  itLen = 7;

  for (i = 0; i < itLen; i = i + 1)
    swapNibbles[4*i +: 4] = wordIn[(itLen-i)*4 +: 4];      
  end 
   

endfunction

task automatic navigateWords;
  input reg [DATA_WIDTH-1:0] BusIn;
  output reg [DATA_WIDTH-1:0] BusOut;
  reg [$clog2(DATA_WIDTH/32)  :0] itLen;
  integer i;

  begin  

  itLen = DATA_WIDTH/32;

  for (i = 0; i < itLen; i = i + 1)
    BusOut[32*i +: 32] = swapNibbles(BusIn[i*32 +: 32]);      
  end 
   
endtask

always @(*) navigateWords(dataIn,dataOut);

endmodule