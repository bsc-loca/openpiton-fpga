


module openpiton_wrapper(    
    input            chipset_clk,
    input            mc_clk,
    input            vpu_clk,
    input   [4:0]    pcie_gpio ,
    output           ExtArstn,

    // AXI Write Address Channel Signals
    output  [5:0]    mem_axi_awid,
    output  [63:0]   mem_axi_awaddr,
    output  [7:0]    mem_axi_awlen,
    output  [2:0]    mem_axi_awsize,
    output  [1:0]    mem_axi_awburst,
    output           mem_axi_awlock,
    output  [3:0]    mem_axi_awcache,
    output  [2:0]    mem_axi_awprot,
    output  [3:0]    mem_axi_awqos,
    output  [3:0]    mem_axi_awregion,
    output  [10:0]   mem_axi_awuser,
    output           mem_axi_awvalid,
    input            mem_axi_awready,

    // AXI Write Data Channel Signals
    output  [5:0]   mem_axi_wid,
    output  [255:0] mem_axi_wdata,
    output  [63:0]  mem_axi_wstrb,
    output          mem_axi_wlast,
    output  [10:0]  mem_axi_wuser,
    output          mem_axi_wvalid,
    input           mem_axi_wready,

    // AXI Read Address Channel Signals
    output  [5:0]   mem_axi_arid,
    output  [63:0]  mem_axi_araddr,
    output  [7:0]   mem_axi_arlen,
    output  [2:0]   mem_axi_arsize,
    output  [1:0]   mem_axi_arburst,
    output          mem_axi_arlock,
    output  [3:0]   mem_axi_arcache,
    output  [2:0]   mem_axi_arprot,
    output  [3:0]   mem_axi_arqos,
    output  [3:0]   mem_axi_arregion,
    output  [10:0]  mem_axi_aruser,
    output          mem_axi_arvalid,
    input           mem_axi_arready,

    // AXI Read Data Channel Signals
    input   [5:0]    mem_axi_rid,
    input   [255:0]  mem_axi_rdata,
    input   [1:0]    mem_axi_rresp,
    input            mem_axi_rlast,
    input   [10:0]   mem_axi_ruser,
    input            mem_axi_rvalid,
    output           mem_axi_rready,

    // AXI Write Response Channel Signals
    input   [5:0]    mem_axi_bid,
    input   [1:0]    mem_axi_bresp,
    input   [10:0]   mem_axi_buser,
    input            mem_axi_bvalid,
    output           mem_axi_bready,

    input mem_calib_complete,

    // Ethernet
    input                                   eth_axi_aclk,
    input                                   eth_axi_arstn,
    input  [1:0]                            eth_irq,

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
    output  [`AXI4_ID_WIDTH     -1:0]    eth_axi_awid,
    output  [`AXI4_ADDR_WIDTH   -1:0]    eth_axi_awaddr,
    output  [`AXI4_LEN_WIDTH    -1:0]    eth_axi_awlen,
    output  [`AXI4_SIZE_WIDTH   -1:0]    eth_axi_awsize,
    output  [`AXI4_BURST_WIDTH  -1:0]    eth_axi_awburst,
    output                               eth_axi_awlock,
    output  [`AXI4_CACHE_WIDTH  -1:0]    eth_axi_awcache,
    output  [`AXI4_PROT_WIDTH   -1:0]    eth_axi_awprot,
    //output  [`AXI4_QOS_WIDTH    -1:0]    eth_axi_awqos,
    //output  [`AXI4_REGION_WIDTH -1:0]    eth_axi_awregion,
    output  [`AXI4_USER_WIDTH   -1:0]    eth_axi_awuser,
    output                               eth_axi_awvalid,
    input                                eth_axi_awready,

    output   [`AXI4_ID_WIDTH     -1:0]    eth_axi_wid,
    output   [`AXI4_DATA_WIDTH   -1:0]    eth_axi_wdata,
    output   [`AXI4_STRB_WIDTH   -1:0]    eth_axi_wstrb,
    output                                eth_axi_wlast,
    output   [`AXI4_USER_WIDTH   -1:0]    eth_axi_wuser,
    output                                eth_axi_wvalid,
    input                                 eth_axi_wready,

    output   [`AXI4_ID_WIDTH     -1:0]    eth_axi_arid,
    output   [`AXI4_ADDR_WIDTH   -1:0]    eth_axi_araddr,
    output   [`AXI4_LEN_WIDTH    -1:0]    eth_axi_arlen,
    output   [`AXI4_SIZE_WIDTH   -1:0]    eth_axi_arsize,
    output   [`AXI4_BURST_WIDTH  -1:0]    eth_axi_arburst,
    output                                eth_axi_arlock,
    output   [`AXI4_CACHE_WIDTH  -1:0]    eth_axi_arcache,
    output   [`AXI4_PROT_WIDTH   -1:0]    eth_axi_arprot,
    //output   [`AXI4_QOS_WIDTH    -1:0]    eth_axi_arqos,
    //output   [`AXI4_REGION_WIDTH -1:0]    eth_axi_arregion,
    output   [`AXI4_USER_WIDTH   -1:0]    eth_axi_aruser,
    output                                eth_axi_arvalid,
    input                                 eth_axi_arready,

    input    [`AXI4_ID_WIDTH     -1:0]    eth_axi_rid,
    input    [`AXI4_DATA_WIDTH   -1:0]    eth_axi_rdata,
    input    [`AXI4_RESP_WIDTH   -1:0]    eth_axi_rresp,
    input                                 eth_axi_rlast,
    input    [`AXI4_USER_WIDTH   -1:0]    eth_axi_ruser,
    input                                 eth_axi_rvalid,
    output                                eth_axi_rready,

    input    [`AXI4_ID_WIDTH     -1:0]    eth_axi_bid,
    input    [`AXI4_RESP_WIDTH   -1:0]    eth_axi_bresp,
    input    [`AXI4_USER_WIDTH   -1:0]    eth_axi_buser,
    input                                 eth_axi_bvalid,
    output                                eth_axi_bready,
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
    //output [`AXI4_QOS_WIDTH    -1:0]     sram_axi_awqos,
    //output [`AXI4_REGION_WIDTH -1:0]     sram_axi_awregion,
    output [`AXI4_USER_WIDTH   -1:0]     sram_axi_awuser,
    output                               sram_axi_awvalid,
    input                                sram_axi_awready,

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
    //output  [`AXI4_QOS_WIDTH    -1:0]    sram_axi_arqos,
    //output  [`AXI4_REGION_WIDTH -1:0]    sram_axi_arregion,
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
    
    `ifdef DEBUG_ROM 
    output                               debug_rom_req,
    output  [63:0]                       debug_rom_addr,
    input   [63:0]                       debug_rom_rdata,
    `endif

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
       .chipset_clk(chipset_clk)	,
       .mc_clk(mc_clk),
       .vpu_clk(vpu_clk),
       .pcie_gpio(pcie_gpio) ,
       .ExtArstn(ExtArstn),
       // AXI Write Address Channel Signals
       .mem_axi_awid(mem_axi_awid),
       .mem_axi_awaddr(mem_axi_awaddr),
       .mem_axi_awlen(mem_axi_awlen),
       .mem_axi_awsize(mem_axi_awsize),
       .mem_axi_awburst(mem_axi_awburst),
       .mem_axi_awlock(mem_axi_awlock),
       .mem_axi_awcache(mem_axi_awcache),
       .mem_axi_awprot(mem_axi_awprot),
       .mem_axi_awqos(mem_axi_awqos),
       .mem_axi_awregion(mem_axi_awregion),
       .mem_axi_awuser(mem_axi_awuser),
       .mem_axi_awvalid(mem_axi_awvalid),
       .mem_axi_awready(mem_axi_awready),

       // AXI Write Data Channel Signals
       .mem_axi_wid(mem_axi_wid),
       .mem_axi_wdata(mem_axi_wdata[255:0]),
       .mem_axi_wstrb(mem_axi_wstrb),
       .mem_axi_wlast(mem_axi_wlast),
       .mem_axi_wuser(mem_axi_wuser),
       .mem_axi_wvalid(mem_axi_wvalid),
       .mem_axi_wready(mem_axi_wready),

       // AXI Read Address Channel Signals
       .mem_axi_arid(mem_axi_arid),
       .mem_axi_araddr(mem_axi_araddr),
       .mem_axi_arlen(mem_axi_arlen),
       .mem_axi_arsize(mem_axi_arsize),
       .mem_axi_arburst(mem_axi_arburst),
       .mem_axi_arlock(mem_axi_arlock),
       .mem_axi_arcache(mem_axi_arcache),
       .mem_axi_arprot(mem_axi_arprot),
       .mem_axi_arqos(mem_axi_arqos),
       .mem_axi_arregion(mem_axi_arregion),
       .mem_axi_aruser(mem_axi_aruser),
       .mem_axi_arvalid(mem_axi_arvalid),
       .mem_axi_arready(mem_axi_arready),

       // AXI Read Data Channel Signals
       .mem_axi_rid(mem_axi_rid),
       .mem_axi_rdata(mem_axi_rdata[255:0]),
       .mem_axi_rresp(mem_axi_rresp),
       .mem_axi_rlast(mem_axi_rlast),
       .mem_axi_ruser(mem_axi_ruser),
       .mem_axi_rvalid(mem_axi_rvalid),
       .mem_axi_rready(mem_axi_rready),

       // AXI Write Response Channel Signals
       .mem_axi_bid(mem_axi_bid),
       .mem_axi_bresp(mem_axi_bresp),
       .mem_axi_buser(mem_axi_buser),
       .mem_axi_bvalid(mem_axi_bvalid),
       .mem_axi_bready(mem_axi_bready),

       .mem_calib_complete(mem_calib_complete),

      // Ethernet
       .eth_axi_aclk  (eth_axi_aclk),
       .eth_axi_arstn (eth_axi_arstn),
       .eth_irq       (eth_irq),

      `ifdef ETHERNET_DMA
       .dma_s_axi_awaddr   (eth_axi_awaddr ) ,
       .dma_s_axi_awvalid  (eth_axi_awvalid) ,
       .dma_s_axi_awready  (eth_axi_awready) ,

       .dma_s_axi_wdata    (eth_axi_wdata  ) ,
       .dma_s_axi_wstrb    (eth_axi_wstrb  ) ,
       .dma_s_axi_wvalid   (eth_axi_wvalid ) ,
       .dma_s_axi_wready   (eth_axi_wready ) ,

       .dma_s_axi_bresp    (eth_axi_bresp  ) ,
       .dma_s_axi_bvalid   (eth_axi_bvalid ) ,
       .dma_s_axi_bready   (eth_axi_bready ) ,

       .dma_s_axi_araddr   (eth_axi_araddr ) ,
       .dma_s_axi_arvalid  (eth_axi_arvalid) ,
       .dma_s_axi_arready  (eth_axi_arready) ,

       .dma_s_axi_rdata    (eth_axi_rdata  ) ,
       .dma_s_axi_rresp    (eth_axi_rresp  ) ,
       .dma_s_axi_rvalid   (eth_axi_rvalid ) ,
       .dma_s_axi_rready   (eth_axi_rready ) ,
      `else

       .eth_axi_araddr(eth_axi_araddr),
       .eth_axi_arburst(eth_axi_arburst),
       .eth_axi_arcache(eth_axi_arcache),
       .eth_axi_arid(eth_axi_arid),
       .eth_axi_arlen(eth_axi_arlen),
       .eth_axi_arlock(eth_axi_arlock),
       .eth_axi_arprot(eth_axi_arprot),
       // .eth_axi_arqos(eth_axi_arqos),
       .eth_axi_arready(eth_axi_arready),
       .eth_axi_arsize(eth_axi_arsize),
       // .eth_axi_aruser(eth_axi_aruser),
       .eth_axi_arvalid(eth_axi_arvalid),

       .eth_axi_awaddr(eth_axi_awaddr),
       .eth_axi_awburst(eth_axi_awburst),
       .eth_axi_awcache(eth_axi_awcache),
       .eth_axi_awid(eth_axi_awid),
       .eth_axi_awlen(eth_axi_awlen),
       .eth_axi_awlock(eth_axi_awlock),
       .eth_axi_awprot(eth_axi_awprot),
//       // .eth_axi_awqos(eth_axi_awqos),
       .eth_axi_awready(eth_axi_awready),
       .eth_axi_awsize(eth_axi_awsize),
//       // .eth_axi_awuser(eth_axi_awuser),
       .eth_axi_awvalid(eth_axi_awvalid),

       .eth_axi_bid(eth_axi_bid),
       .eth_axi_bready(eth_axi_bready),
       .eth_axi_bresp(eth_axi_bresp),
//       // .eth_axi_buser(eth_axi_buser),
       .eth_axi_bvalid(eth_axi_bvalid),

       .eth_axi_rdata(eth_axi_rdata),
       .eth_axi_rid(eth_axi_rid),
       .eth_axi_rlast(eth_axi_rlast),
       .eth_axi_rready(eth_axi_rready),
       .eth_axi_rresp(eth_axi_rresp),
//       // .eth_axi_ruser(eth_axi_ruser),
       .eth_axi_rvalid(eth_axi_rvalid),

       .eth_axi_wdata(eth_axi_wdata),
       .eth_axi_wlast(eth_axi_wlast),
       .eth_axi_wready(eth_axi_wready),
       .eth_axi_wstrb(eth_axi_wstrb),
//       // .eth_axi_wuser(eth_axi_wuser),
       .eth_axi_wvalid(eth_axi_wvalid),
      `endif

        .sram_axi_araddr(sram_axi_araddr),
        .sram_axi_arburst(sram_axi_arburst),
        .sram_axi_arcache(sram_axi_arcache),
        .sram_axi_arid(sram_axi_arid),
        .sram_axi_arlen(sram_axi_arlen),
        .sram_axi_arlock(sram_axi_arlock),
        .sram_axi_arprot(sram_axi_arprot),
//        // .sram_axi_arqos(sram_axi_arqos),
        .sram_axi_arready(sram_axi_arready),
        .sram_axi_arsize(sram_axi_arsize),
//        // .sram_axi_aruser(sram_axi_aruser),
        .sram_axi_arvalid(sram_axi_arvalid),

        .sram_axi_awaddr(sram_axi_awaddr),
        .sram_axi_awburst(sram_axi_awburst),
        .sram_axi_awcache(sram_axi_awcache),
        .sram_axi_awid(sram_axi_awid),
        .sram_axi_awlen(sram_axi_awlen),
        .sram_axi_awlock(sram_axi_awlock),
        .sram_axi_awprot(sram_axi_awprot),
        // .sram_axi_awqos(sram_axi_awqos),
        .sram_axi_awready(sram_axi_awready),
        .sram_axi_awsize(sram_axi_awsize),
//        // .sram_axi_awuser(sram_axi_awuser),
        .sram_axi_awvalid(sram_axi_awvalid),

        .sram_axi_bid(sram_axi_bid),
        .sram_axi_bready(sram_axi_bready),
        .sram_axi_bresp(sram_axi_bresp),
//        // .sram_axi_buser(sram_axi_buser),
        .sram_axi_bvalid(sram_axi_bvalid),

        .sram_axi_rdata(sram_axi_rdata),
        .sram_axi_rid(sram_axi_rid),
        .sram_axi_rlast(sram_axi_rlast),
        .sram_axi_rready(sram_axi_rready),
        .sram_axi_rresp(sram_axi_rresp),
//        // .sram_axi_ruser(sram_axi_ruser),
        .sram_axi_rvalid(sram_axi_rvalid),

        .sram_axi_wdata(sram_axi_wdata),
        .sram_axi_wlast(sram_axi_wlast),
        .sram_axi_wready(sram_axi_wready),
        .sram_axi_wstrb(sram_axi_wstrb),
//        // .sram_axi_wuser(sram_axi_wuser),
        .sram_axi_wvalid(sram_axi_wvalid),
        
         `ifdef DEBUG_ROM 
        .debug_rom_req(debug_rom_req),
        .debug_rom_addr(debug_rom_addr),
        .debug_rom_rdata(debug_rom_rdata),
         `endif

        .uart_axi_awaddr(uart_axi_awaddr),
        .uart_axi_awvalid(uart_axi_awvalid),
        .uart_axi_awready(uart_axi_awready),
        .uart_axi_wdata(uart_axi_wdata),
        .uart_axi_wstrb(uart_axi_wstrb),
        .uart_axi_wvalid(uart_axi_wvalid),
        .uart_axi_wready(uart_axi_wready),
        .uart_axi_bresp(uart_axi_bresp),
        .uart_axi_bvalid(uart_axi_bvalid),
        .uart_axi_bready(uart_axi_bready),
        .uart_axi_araddr(uart_axi_araddr),
        .uart_axi_arvalid(uart_axi_arvalid),
        .uart_axi_arready(uart_axi_arready),
        .uart_axi_rdata(uart_axi_rdata),
        .uart_axi_rresp(uart_axi_rresp),
        .uart_axi_rvalid(uart_axi_rvalid),
        .uart_axi_rready(uart_axi_rready),

        .uart_irq(uart_irq)

         );

endmodule