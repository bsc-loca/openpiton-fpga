
module endianess_swapper_top #(
  parameter AXI_ID_WIDTH   = 1  ,
  parameter AXI_ADDR_WIDTH = 48 ,
  parameter AXI_DATA_WIDTH = 256
)(
  input                           ACLK         ,
  input                           ARESETN      ,
  //
  input  [AXI_ID_WIDTH-1:0]       S_AXI_AWID   ,
  input  [AXI_ADDR_WIDTH-1:0]     S_AXI_AWADDR ,
  input  [7:0]                    S_AXI_AWLEN  ,
  input  [2:0]                    S_AXI_AWSIZE ,
  input  [1:0]                    S_AXI_AWBURST,
  input  [1:0]                    S_AXI_AWLOCK ,
  input  [3:0]                    S_AXI_AWCACHE,
  input  [2:0]                    S_AXI_AWPROT ,
  input                           S_AXI_AWVALID,
  output                          S_AXI_AWREADY,
  // Write Data Channel
  input  [AXI_DATA_WIDTH-1:0]     S_AXI_WDATA  ,
  input  [(AXI_DATA_WIDTH/8)-1:0] S_AXI_WSTRB  ,
  input                           S_AXI_WLAST  ,
  input                           S_AXI_WVALID ,
  output                          S_AXI_WREADY ,
  // Write Responce Channel
  output [AXI_ID_WIDTH-1:0]       S_AXI_BID    ,
  output [1:0]                    S_AXI_BRESP  ,
  output                          S_AXI_BVALID ,
  input                           S_AXI_BREADY ,
  //  Read Address Channel
  input  [AXI_ID_WIDTH-1:0]       S_AXI_ARID   ,
  input  [AXI_ADDR_WIDTH-1:0]     S_AXI_ARADDR ,
  input  [7:0]                    S_AXI_ARLEN  ,
  input  [2:0]                    S_AXI_ARSIZE ,
  input  [1:0]                    S_AXI_ARBURST,
  input  [1:0]                    S_AXI_ARLOCK ,
  input  [3:0]                    S_AXI_ARCACHE,
  input  [2:0]                    S_AXI_ARPROT ,
  input                           S_AXI_ARVALID,
  output                          S_AXI_ARREADY,
  // Read Responce Channel
  output [AXI_ID_WIDTH-1:0]       S_AXI_RID    ,
  output [AXI_DATA_WIDTH-1:0]     S_AXI_RDATA  ,
  output [1:0]                    S_AXI_RRESP  ,
  output                          S_AXI_RLAST  ,
  output                          S_AXI_RVALID ,
  input                           S_AXI_RREADY ,
  // Write Address Channel
  output [AXI_ID_WIDTH-1:0]       M_AXI_AWID   ,
  output [AXI_ADDR_WIDTH-1:0]     M_AXI_AWADDR ,
  output [7:0]                    M_AXI_AWLEN  ,
  output [2:0]                    M_AXI_AWSIZE ,
  output [1:0]                    M_AXI_AWBURST,
  output [1:0]                    M_AXI_AWLOCK ,
  output [3:0]                    M_AXI_AWCACHE,
  output [2:0]                    M_AXI_AWPROT ,
  output                          M_AXI_AWVALID,
  input                           M_AXI_AWREADY,
  // Write Data Channel
  output [AXI_DATA_WIDTH-1:0]     M_AXI_WDATA  ,
  output [(AXI_DATA_WIDTH/8)-1:0] M_AXI_WSTRB  ,
  output                          M_AXI_WLAST  ,
  output                          M_AXI_WVALID ,
  input                           M_AXI_WREADY ,
  // Write Responce Channel
  input  [AXI_ID_WIDTH-1:0]       M_AXI_BID    ,
  input  [1:0]                    M_AXI_BRESP  ,
  input                           M_AXI_BVALID ,
  output                          M_AXI_BREADY ,
  //  Read Address Channel
  output [AXI_ID_WIDTH-1:0]       M_AXI_ARID   ,
  output [AXI_ADDR_WIDTH-1:0]     M_AXI_ARADDR ,
  output [7:0]                    M_AXI_ARLEN  ,
  output [2:0]                    M_AXI_ARSIZE ,
  output [1:0]                    M_AXI_ARBURST,
  output [1:0]                    M_AXI_ARLOCK ,
  output [3:0]                    M_AXI_ARCACHE,
  output [2:0]                    M_AXI_ARPROT ,
  output                          M_AXI_ARVALID,
  input                           M_AXI_ARREADY,
  // Read Responce Channel
  input  [AXI_ID_WIDTH-1:0]       M_AXI_RID    ,
  input  [AXI_DATA_WIDTH-1:0]     M_AXI_RDATA  ,
  input  [1:0]                    M_AXI_RRESP  ,
  input                           M_AXI_RLAST  ,
  input                           M_AXI_RVALID ,
  output                          M_AXI_RREADY 
);

wire [AXI_DATA_WIDTH-1:0] m_axi_wdata_int;

wordFlip #(
  .DATA_WIDTH (AXI_DATA_WIDTH)
  ) wordFlip_i (
   .dataIn ( S_AXI_WDATA )  ,
   .dataOut( m_axi_wdata_int )
  );


  // AR channel as is
  assign M_AXI_ARID    = S_AXI_ARID    ;
  assign M_AXI_ARADDR  = S_AXI_ARADDR  ;
  assign M_AXI_ARLEN   = S_AXI_ARLEN   ;
  assign M_AXI_ARSIZE  = S_AXI_ARSIZE  ;
  assign M_AXI_ARBURST = S_AXI_ARBURST ;
  assign M_AXI_ARLOCK  = S_AXI_ARLOCK  ;
  assign M_AXI_ARCACHE = S_AXI_ARCACHE ;
  assign M_AXI_ARPROT  = S_AXI_ARPROT  ;
  assign M_AXI_ARVALID = S_AXI_ARVALID ;
  assign S_AXI_ARREADY = M_AXI_ARREADY ;

  // AW channel as is
  assign M_AXI_AWID    = S_AXI_AWID    ;
  assign M_AXI_AWADDR  = S_AXI_AWADDR  ;
  assign M_AXI_AWLEN   = S_AXI_AWLEN   ;
  assign M_AXI_AWSIZE  = S_AXI_AWSIZE  ;
  assign M_AXI_AWBURST = S_AXI_AWBURST ;
  assign M_AXI_AWLOCK  = S_AXI_AWLOCK  ;
  assign M_AXI_AWCACHE = S_AXI_AWCACHE ;
  assign M_AXI_AWPROT  = S_AXI_AWPROT  ;
  assign M_AXI_AWVALID = S_AXI_AWVALID ;
  assign S_AXI_AWREADY = M_AXI_AWREADY ;

  // W channel as is
  assign M_AXI_WDATA   = m_axi_wdata_int   ;
  assign M_AXI_WSTRB   = S_AXI_WSTRB   ;
  assign M_AXI_WLAST   = S_AXI_WLAST   ;
  assign M_AXI_WVALID  = S_AXI_WVALID  ;
  assign S_AXI_WREADY  = M_AXI_WREADY  ;

  // R channel
  assign S_AXI_RLAST   = M_AXI_RLAST   ;
  assign S_AXI_RRESP   = M_AXI_RRESP   ;
  assign S_AXI_RDATA   = M_AXI_RDATA   ;
  assign S_AXI_RID     = M_AXI_RID     ;
  //
  assign S_AXI_RVALID  = M_AXI_RVALID  ;
  assign M_AXI_RREADY  = S_AXI_RREADY  ;

  // B channel
  assign S_AXI_BRESP   = M_AXI_BRESP   ;
  assign S_AXI_BID     = M_AXI_BID     ;
  //
  assign S_AXI_BVALID  = M_AXI_BVALID  ;
  assign M_AXI_BREADY  = S_AXI_BREADY  ;

endmodule
