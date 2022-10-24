


module openpiton_wrapper(    
    input            chipset_clk,
    input            mc_clk,
    input            vpu_clk,
    input   [4:0]    pcie_gpio ,
    output           ExtArstn,
    input            mc_rstn,

    // AXI Write Address Channel Signals
    output wire [`AXI4_ID_WIDTH     -1:0]    mem_axi_awid,
    output wire [`AXI4_ADDR_WIDTH   -1:0]    mem_axi_awaddr,
    output wire [`AXI4_LEN_WIDTH    -1:0]    mem_axi_awlen,
    output wire [`AXI4_SIZE_WIDTH   -1:0]    mem_axi_awsize,
    output wire [`AXI4_BURST_WIDTH  -1:0]    mem_axi_awburst,
    output wire                              mem_axi_awlock,
    output wire [`AXI4_CACHE_WIDTH  -1:0]    mem_axi_awcache,
    output wire [`AXI4_PROT_WIDTH   -1:0]    mem_axi_awprot,
    output wire [`AXI4_QOS_WIDTH    -1:0]    mem_axi_awqos,
    output wire [`AXI4_REGION_WIDTH -1:0]    mem_axi_awregion,
    output wire [`AXI4_USER_WIDTH   -1:0]    mem_axi_awuser,
    output wire                              mem_axi_awvalid,
    input  wire                              mem_axi_awready,

    // AXI Write Data Channel Signals
    output wire  [`AXI4_ID_WIDTH     -1:0]    mem_axi_wid,
    output wire  [`AXI4_DATA_WIDTH   -1:0]    mem_axi_wdata,
    output wire  [`AXI4_STRB_WIDTH   -1:0]    mem_axi_wstrb,
    output wire                               mem_axi_wlast,
    output wire  [`AXI4_USER_WIDTH   -1:0]    mem_axi_wuser,
    output wire                               mem_axi_wvalid,
    input  wire                               mem_axi_wready,

    // AXI Read Address Channel Signals
    output wire  [`AXI4_ID_WIDTH     -1:0]    mem_axi_arid,
    output wire  [`AXI4_ADDR_WIDTH   -1:0]    mem_axi_araddr,
    output wire  [`AXI4_LEN_WIDTH    -1:0]    mem_axi_arlen,
    output wire  [`AXI4_SIZE_WIDTH   -1:0]    mem_axi_arsize,
    output wire  [`AXI4_BURST_WIDTH  -1:0]    mem_axi_arburst,
    output wire                               mem_axi_arlock,
    output wire  [`AXI4_CACHE_WIDTH  -1:0]    mem_axi_arcache,
    output wire  [`AXI4_PROT_WIDTH   -1:0]    mem_axi_arprot,
    output wire  [`AXI4_QOS_WIDTH    -1:0]    mem_axi_arqos,
    output wire  [`AXI4_REGION_WIDTH -1:0]    mem_axi_arregion,
    output wire  [`AXI4_USER_WIDTH   -1:0]    mem_axi_aruser,
    output wire                               mem_axi_arvalid,
    input  wire                               mem_axi_arready,

    // AXI Read Data Channel Signals
    input  wire  [`AXI4_ID_WIDTH     -1:0]    mem_axi_rid,
    input  wire  [`AXI4_DATA_WIDTH   -1:0]    mem_axi_rdata,
    input  wire  [`AXI4_RESP_WIDTH   -1:0]    mem_axi_rresp,
    input  wire                               mem_axi_rlast,
    input  wire  [`AXI4_USER_WIDTH   -1:0]    mem_axi_ruser,
    input  wire                               mem_axi_rvalid,
    output wire                               mem_axi_rready,

    // AXI Write Response Channel Signals
    input  wire  [`AXI4_ID_WIDTH     -1:0]    mem_axi_bid,
    input  wire  [`AXI4_RESP_WIDTH   -1:0]    mem_axi_bresp,
    input  wire  [`AXI4_USER_WIDTH   -1:0]    mem_axi_buser,
    input  wire                               mem_axi_bvalid,
    output wire                               mem_axi_bready,

    input mem_calib_complete,

 	    //Ethernet
    input wire                               eth_axi_aclk,
    input wire                               eth_axi_arstn,        
    input wire   [1:0]                       eth_irq, //TODO: connect it downstream
    
  `ifdef ETHERNET_DMA
    output [`C_M_AXI_LITE_ADDR_WIDTH-1:0]   eth_axi_awaddr,
    output                                  eth_axi_awvalid,
    input                                   eth_axi_awready,

    output [`C_M_AXI_LITE_DATA_WIDTH-1:0]   eth_axi_wdata,
    output [`C_M_AXI_LITE_DATA_WIDTH/8-1:0] eth_axi_wstrb,
    output                                  eth_axi_wvalid,
    input                                   eth_axi_wready,

    input  [`C_M_AXI_LITE_RESP_WIDTH-1:0]   eth_axi_bresp,
    input                                   eth_axi_bvalid,
    output                                  eth_axi_bready,

    output [`C_M_AXI_LITE_ADDR_WIDTH-1:0]   eth_axi_araddr,
    output                                  eth_axi_arvalid,
    input                                   eth_axi_arready,

    input  [`C_M_AXI_LITE_DATA_WIDTH-1:0]   eth_axi_rdata,
    input  [`C_M_AXI_LITE_RESP_WIDTH-1:0]   eth_axi_rresp,
    input                                   eth_axi_rvalid,
    output                                  eth_axi_rready,
  
  `else
    // AXI interface
    output wire [`AXI4_ID_WIDTH     -1:0]    eth_axi_awid,
    output wire [`AXI4_ADDR_WIDTH   -1:0]    eth_axi_awaddr,
    output wire [`AXI4_LEN_WIDTH    -1:0]    eth_axi_awlen,
    output wire [`AXI4_SIZE_WIDTH   -1:0]    eth_axi_awsize,
    output wire [`AXI4_BURST_WIDTH  -1:0]    eth_axi_awburst,
    output wire                              eth_axi_awlock,
    output wire [`AXI4_CACHE_WIDTH  -1:0]    eth_axi_awcache,
    output wire [`AXI4_PROT_WIDTH   -1:0]    eth_axi_awprot,
    output wire [`AXI4_QOS_WIDTH    -1:0]    eth_axi_awqos,
    output wire [`AXI4_REGION_WIDTH -1:0]    eth_axi_awregion,
    output wire [`AXI4_USER_WIDTH   -1:0]    eth_axi_awuser,
    output wire                              eth_axi_awvalid,
    input  wire                              eth_axi_awready,

    output wire  [`AXI4_ID_WIDTH     -1:0]    eth_axi_wid,
    output wire  [`AXI4_DATA_WIDTH   -1:0]    eth_axi_wdata,
    output wire  [`AXI4_STRB_WIDTH   -1:0]    eth_axi_wstrb,
    output wire                               eth_axi_wlast,
    output wire  [`AXI4_USER_WIDTH   -1:0]    eth_axi_wuser,
    output wire                               eth_axi_wvalid,
    input  wire                               eth_axi_wready,

    output wire  [`AXI4_ID_WIDTH     -1:0]    eth_axi_arid,
    output wire  [`AXI4_ADDR_WIDTH   -1:0]    eth_axi_araddr,
    output wire  [`AXI4_LEN_WIDTH    -1:0]    eth_axi_arlen,
    output wire  [`AXI4_SIZE_WIDTH   -1:0]    eth_axi_arsize,
    output wire  [`AXI4_BURST_WIDTH  -1:0]    eth_axi_arburst,
    output wire                               eth_axi_arlock,
    output wire  [`AXI4_CACHE_WIDTH  -1:0]    eth_axi_arcache,
    output wire  [`AXI4_PROT_WIDTH   -1:0]    eth_axi_arprot,
    output wire  [`AXI4_QOS_WIDTH    -1:0]    eth_axi_arqos,
    output wire  [`AXI4_REGION_WIDTH -1:0]    eth_axi_arregion,
    output wire  [`AXI4_USER_WIDTH   -1:0]    eth_axi_aruser,
    output wire                               eth_axi_arvalid,
    input  wire                               eth_axi_arready,

    input  wire  [`AXI4_ID_WIDTH     -1:0]    eth_axi_rid,
    input  wire  [`AXI4_DATA_WIDTH   -1:0]    eth_axi_rdata,
    input  wire  [`AXI4_RESP_WIDTH   -1:0]    eth_axi_rresp,
    input  wire                               eth_axi_rlast,
    input  wire  [`AXI4_USER_WIDTH   -1:0]    eth_axi_ruser,
    input  wire                               eth_axi_rvalid,
    output wire                               eth_axi_rready,

    input  wire  [`AXI4_ID_WIDTH     -1:0]    eth_axi_bid,
    input  wire  [`AXI4_RESP_WIDTH   -1:0]    eth_axi_bresp,
    input  wire  [`AXI4_USER_WIDTH   -1:0]    eth_axi_buser,
    input  wire                               eth_axi_bvalid,
    output wire                               eth_axi_bready, 
   `endif

    // AXI interface
    output [`AXI4_ID_WIDTH     -1:0]     sram_axi_awid,
    output [`AXI4_ADDR_WIDTH   -1:0]     sram_axi_awaddr,
    output [`AXI4_LEN_WIDTH    -1:0]     sram_axi_awlen,
    output [`AXI4_SIZE_WIDTH   -1:0]     sram_axi_awsize,
    output [`AXI4_BURST_WIDTH  -1:0]     sram_axi_awburst,
    output                               sram_axi_awlock,
    output [`AXI4_CACHE_WIDTH  -1:0]     sram_axi_awcache,
    output [`AXI4_PROT_WIDTH   -1:0]     sram_axi_awprot,
    output [`AXI4_QOS_WIDTH    -1:0]     sram_axi_awqos,
    output [`AXI4_REGION_WIDTH -1:0]     sram_axi_awregion,
    output [`AXI4_USER_WIDTH   -1:0]     sram_axi_awuser,
    output                               sram_axi_awvalid,
    input                                sram_axi_awready,

    output  [`AXI4_ID_WIDTH     -1:0]    sram_axi_wid,
    output  [`AXI4_DATA_WIDTH   -1:0]    sram_axi_wdata,
    output  [`AXI4_STRB_WIDTH   -1:0]    sram_axi_wstrb,
    output                               sram_axi_wlast,
    output  [`AXI4_USER_WIDTH   -1:0]    sram_axi_wuser,
    output                               sram_axi_wvalid,
    input                                sram_axi_wready,

    output  [`AXI4_ID_WIDTH     -1:0]    sram_axi_arid,
    output  [`AXI4_ADDR_WIDTH   -1:0]    sram_axi_araddr,
    output  [`AXI4_LEN_WIDTH    -1:0]    sram_axi_arlen,
    output  [`AXI4_SIZE_WIDTH   -1:0]    sram_axi_arsize,
    output  [`AXI4_BURST_WIDTH  -1:0]    sram_axi_arburst,
    output                               sram_axi_arlock,
    output  [`AXI4_CACHE_WIDTH  -1:0]    sram_axi_arcache,
    output  [`AXI4_PROT_WIDTH   -1:0]    sram_axi_arprot,
    output  [`AXI4_QOS_WIDTH    -1:0]    sram_axi_arqos,
    output  [`AXI4_REGION_WIDTH -1:0]    sram_axi_arregion,
    output  [`AXI4_USER_WIDTH   -1:0]    sram_axi_aruser,
    output                               sram_axi_arvalid,
    input                                sram_axi_arready,

    input   [`AXI4_ID_WIDTH     -1:0]    sram_axi_rid,
    input   [`AXI4_DATA_WIDTH   -1:0]    sram_axi_rdata,
    input   [`AXI4_RESP_WIDTH   -1:0]    sram_axi_rresp,
    input                                sram_axi_rlast,
    input   [`AXI4_USER_WIDTH   -1:0]    sram_axi_ruser,
    input                                sram_axi_rvalid,
    output                               sram_axi_rready,

    input   [`AXI4_ID_WIDTH     -1:0]    sram_axi_bid,
    input   [`AXI4_RESP_WIDTH   -1:0]    sram_axi_bresp,
    input   [`AXI4_USER_WIDTH   -1:0]    sram_axi_buser,
    input                                sram_axi_bvalid,
    output                               sram_axi_bready,

    // AXI non-cacheable system memory
    `ifdef PITON_NONCACH_MEM
    //input wire                               ncmem_axi_aclk,
    //input wire                               ncmem_axi_arstn,
    
    output wire [`AXI4_ID_WIDTH     -1:0]    ncmem_axi_awid,
    output wire [`AXI4_ADDR_WIDTH   -1:0]    ncmem_axi_awaddr,
    output wire [`AXI4_LEN_WIDTH    -1:0]    ncmem_axi_awlen,
    output wire [`AXI4_SIZE_WIDTH   -1:0]    ncmem_axi_awsize,
    output wire [`AXI4_BURST_WIDTH  -1:0]    ncmem_axi_awburst,
    output wire                              ncmem_axi_awlock,
    output wire [`AXI4_CACHE_WIDTH  -1:0]    ncmem_axi_awcache,
    output wire [`AXI4_PROT_WIDTH   -1:0]    ncmem_axi_awprot,
    output wire [`AXI4_QOS_WIDTH    -1:0]    ncmem_axi_awqos,
    output wire [`AXI4_REGION_WIDTH -1:0]    ncmem_axi_awregion,
    output wire [`AXI4_USER_WIDTH   -1:0]    ncmem_axi_awuser,
    output wire                              ncmem_axi_awvalid,
    input  wire                              ncmem_axi_awready,

    output wire  [`AXI4_ID_WIDTH     -1:0]    ncmem_axi_wid,
    output wire  [`AXI4_DATA_WIDTH   -1:0]    ncmem_axi_wdata,
    output wire  [`AXI4_STRB_WIDTH   -1:0]    ncmem_axi_wstrb,
    output wire                               ncmem_axi_wlast,
    output wire  [`AXI4_USER_WIDTH   -1:0]    ncmem_axi_wuser,
    output wire                               ncmem_axi_wvalid,
    input  wire                               ncmem_axi_wready,

    output wire  [`AXI4_ID_WIDTH     -1:0]    ncmem_axi_arid,
    output wire  [`AXI4_ADDR_WIDTH   -1:0]    ncmem_axi_araddr,
    output wire  [`AXI4_LEN_WIDTH    -1:0]    ncmem_axi_arlen,
    output wire  [`AXI4_SIZE_WIDTH   -1:0]    ncmem_axi_arsize,
    output wire  [`AXI4_BURST_WIDTH  -1:0]    ncmem_axi_arburst,
    output wire                               ncmem_axi_arlock,
    output wire  [`AXI4_CACHE_WIDTH  -1:0]    ncmem_axi_arcache,
    output wire  [`AXI4_PROT_WIDTH   -1:0]    ncmem_axi_arprot,
    output wire  [`AXI4_QOS_WIDTH    -1:0]    ncmem_axi_arqos,
    output wire  [`AXI4_REGION_WIDTH -1:0]    ncmem_axi_arregion,
    output wire  [`AXI4_USER_WIDTH   -1:0]    ncmem_axi_aruser,
    output wire                               ncmem_axi_arvalid,
    input  wire                               ncmem_axi_arready,

    input  wire  [`AXI4_ID_WIDTH     -1:0]    ncmem_axi_rid,
    input  wire  [`AXI4_DATA_WIDTH   -1:0]    ncmem_axi_rdata,
    input  wire  [`AXI4_RESP_WIDTH   -1:0]    ncmem_axi_rresp,
    input  wire                               ncmem_axi_rlast,
    input  wire  [`AXI4_USER_WIDTH   -1:0]    ncmem_axi_ruser,
    input  wire                               ncmem_axi_rvalid,
    output wire                               ncmem_axi_rready,

    input  wire  [`AXI4_ID_WIDTH     -1:0]    ncmem_axi_bid,
    input  wire  [`AXI4_RESP_WIDTH   -1:0]    ncmem_axi_bresp,
    input  wire  [`AXI4_USER_WIDTH   -1:0]    ncmem_axi_buser,
    input  wire                               ncmem_axi_bvalid,
    output wire                               ncmem_axi_bready,
    `endif

    // AXI UART
    output  [12:0]                       uart_axi_awaddr,
    output                               uart_axi_awvalid,
    input                                uart_axi_awready,
    output  [31:0]                       uart_axi_wdata,
    output  [3:0 ]                       uart_axi_wstrb,
    output                               uart_axi_wvalid,
    input                                uart_axi_wready,
    input  [1:0]                         uart_axi_bresp,
    input                                uart_axi_bvalid,
    output                               uart_axi_bready,
    output  [12:0]                       uart_axi_araddr,
    output                               uart_axi_arvalid,
    input                                uart_axi_arready,
    input  [31:0]                        uart_axi_rdata,
    input  [1:0]                         uart_axi_rresp,
    input                                uart_axi_rvalid,
    output                               uart_axi_rready,

    output 				 uart_irq

  );

  system ACME_OP (
            .* // implicit connection of all signals at once
         );

endmodule
