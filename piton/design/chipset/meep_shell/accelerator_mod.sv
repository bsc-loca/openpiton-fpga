


module openpiton_wrapper (    
    input            chipset_clk,
    input            mc_clk,
    input            vpu_clk,
    input   [4:0]    pcie_gpio ,
    output 	         ExtArstn,
    input            mc_rstn,
    // AXI Write Address Channel Signals
    output  [5:0]    mem_axi_awid ,
    output  [63:0]   mem_axi_awaddr ,
    output  [7:0]    mem_axi_awlen ,
    output  [2:0]    mem_axi_awsize ,
    output  [1:0]    mem_axi_awburst ,
    //output           mem_axi_awlock ,
    //output  [3:0]    mem_axi_awcache ,
    //output  [2:0]    mem_axi_awprot ,
    //output  [3:0]    mem_axi_awqos ,
    //output  [3:0]    mem_axi_awregion ,
    output  [10:0]   mem_axi_awuser ,
    output           mem_axi_awvalid ,
    input            mem_axi_awready ,

    // AXI Write Data Channel Signals
    //input   [5:0]   mem_axi_wid ,
    output  [255:0] mem_axi_wdata ,
    output  [63:0]  mem_axi_wstrb ,
    output          mem_axi_wlast ,
    output  [10:0]  mem_axi_wuser ,
    output          mem_axi_wvalid ,
    input           mem_axi_wready ,

    // AXI Read Address Channel Signals
    output  [5:0]   mem_axi_arid ,
    output  [63:0]  mem_axi_araddr ,
    output  [7:0]   mem_axi_arlen ,
    output  [2:0]   mem_axi_arsize ,
    output  [1:0]   mem_axi_arburst ,
    //output          mem_axi_arlock ,
    //output  [3:0]   mem_axi_arcache ,
    //output  [2:0]   mem_axi_arprot ,
    //output  [3:0]   mem_axi_arqos ,
    //output  [3:0]   mem_axi_arregion ,
    output  [10:0]  mem_axi_aruser ,
    output          mem_axi_arvalid ,
    input           mem_axi_arready ,

    // AXI Read Data Channel Signals
    input   [5:0]    mem_axi_rid ,
    input   [255:0]  mem_axi_rdata ,
    input   [1:0]    mem_axi_rresp ,
    input            mem_axi_rlast ,
    input   [10:0]   mem_axi_ruser ,
    input            mem_axi_rvalid ,
    output           mem_axi_rready ,

    // AXI Write Response Channel Signals
    input   [5:0]    mem_axi_bid ,
    input   [1:0]    mem_axi_bresp ,
    input   [10:0]   mem_axi_buser ,
    input            mem_axi_bvalid ,
    output           mem_axi_bready ,

    input mem_calib_complete ,

    // Ethernet
    input           eth_axi_aclk ,
    input           eth_axi_arstn ,
    input  [1:0]    eth_irq ,

    output [63:0]   eth_axi_awaddr ,
    output          eth_axi_awvalid ,
    input           eth_axi_awready ,

    output [63:0]   eth_axi_wdata ,
    output [7:0]    eth_axi_wstrb ,
    output          eth_axi_wvalid ,
    input           eth_axi_wready ,

    input  [1:0]    eth_axi_bresp ,
    input           eth_axi_bvalid ,
    output          eth_axi_bready ,

    output [63:0]   eth_axi_araddr ,
    output          eth_axi_arvalid ,
    input           eth_axi_arready ,

    input  [63:0]   eth_axi_rdata ,
    input  [1:0]    eth_axi_rresp ,
    input           eth_axi_rvalid ,
    output          eth_axi_rready ,

	
    // AXI interface
    output [5:0]      sram_axi_awid ,
    output [19:0]     sram_axi_awaddr ,
    output [7:0]      sram_axi_awlen ,
    output [2:0]      sram_axi_awsize ,
    output [1:0]      sram_axi_awburst ,
    output            sram_axi_awlock ,
    output [3:0]      sram_axi_awcache ,
    output [2:0]      sram_axi_awprot ,
    //output [3:0]      sram_axi_awqos ,
    //output [3:0]      sram_axi_awregion ,
    output [10:0]     sram_axi_awuser ,
    output            sram_axi_awvalid ,
    input             sram_axi_awready ,

    //input   [5:0]     sram_axi_wid ,
    output  [511:0]   sram_axi_wdata ,
    output  [63:0]    sram_axi_wstrb ,
    output            sram_axi_wlast ,
    output  [10:0]    sram_axi_wuser ,
    output            sram_axi_wvalid ,
    input             sram_axi_wready ,

    output  [5:0]    sram_axi_arid ,
    output  [19:0]   sram_axi_araddr ,
    output  [7:0]    sram_axi_arlen ,
    output  [2:0]    sram_axi_arsize ,
    output  [1:0]    sram_axi_arburst ,
    output           sram_axi_arlock ,
    output  [3:0]    sram_axi_arcache ,
    output  [2:0]    sram_axi_arprot ,
    //output  [3:0]    sram_axi_arqos ,
    //output  [3:0]    sram_axi_arregion ,
    output  [10:0]   sram_axi_aruser ,
    output           sram_axi_arvalid ,
    input            sram_axi_arready ,

    input   [5:0]    sram_axi_rid ,
    input   [511:0]  sram_axi_rdata ,
    input   [1:0]    sram_axi_rresp ,
    input            sram_axi_rlast ,
    input   [10:0]   sram_axi_ruser ,
    input            sram_axi_rvalid ,
    output           sram_axi_rready ,

    input   [5:0]    sram_axi_bid ,
    input   [1:0]    sram_axi_bresp ,
    input   [10:0]   sram_axi_buser ,
    input            sram_axi_bvalid ,
    output           sram_axi_bready ,

    // output          debug_rom_req   ,
    // output  [63:0]  debug_rom_addr  ,
    // input   [63:0]  debug_rom_rdata ,

    // AXI Write Address Channel Signals
    //input ncmem_axi_aclk ,
    //input ncmem_axi_arstn ,

    output  [5:0]    ncmem_axi_awid ,
    output  [63:0]   ncmem_axi_awaddr ,
    output  [7:0]    ncmem_axi_awlen ,
    output  [2:0]    ncmem_axi_awsize ,
    output  [1:0]    ncmem_axi_awburst ,
    //output           ncmem_axi_awlock ,
    //output  [3:0]    ncmem_axi_awcache ,
    //output  [2:0]    ncmem_axi_awprot ,
    //output  [3:0]    ncmem_axi_awqos ,
    //output  [3:0]    ncmem_axi_awregion ,
    output  [10:0]   ncmem_axi_awuser ,
    output           ncmem_axi_awvalid ,
    input            ncmem_axi_awready ,

    // AXI Write Data Channel Signals
    //input   [5:0]   ncmem_axi_wid ,
    output  [255:0] ncmem_axi_wdata ,
    output  [63:0]  ncmem_axi_wstrb ,
    output          ncmem_axi_wlast ,
    output  [10:0]  ncmem_axi_wuser ,
    output          ncmem_axi_wvalid ,
    input           ncmem_axi_wready ,

    // AXI Read Address Channel Signals
    output  [5:0]   ncmem_axi_arid ,
    output  [63:0]  ncmem_axi_araddr ,
    output  [7:0]   ncmem_axi_arlen ,
    output  [2:0]   ncmem_axi_arsize ,
    output  [1:0]   ncmem_axi_arburst ,
    //output          ncmem_axi_arlock ,
    //output  [3:0]   ncmem_axi_arcache ,
    //output  [2:0]   ncmem_axi_arprot ,
    //output  [3:0]   ncmem_axi_arqos ,
    //output  [3:0]   ncmem_axi_arregion ,
    output  [10:0]  ncmem_axi_aruser ,
    output          ncmem_axi_arvalid ,
    input           ncmem_axi_arready ,

    // AXI Read Data Channel Signals
    input   [5:0]    ncmem_axi_rid ,
    input   [255:0]  ncmem_axi_rdata ,
    input   [1:0]    ncmem_axi_rresp ,
    input            ncmem_axi_rlast ,
    input   [10:0]   ncmem_axi_ruser ,
    input            ncmem_axi_rvalid ,
    output           ncmem_axi_rready ,

    // AXI Write Response Channel Signals
    input   [5:0]    ncmem_axi_bid ,
    input   [1:0]    ncmem_axi_bresp ,
    input   [10:0]   ncmem_axi_buser ,
    input            ncmem_axi_bvalid ,
    output           ncmem_axi_bready ,

    output  [12:0]   uart_axi_awaddr ,
    output           uart_axi_awvalid ,
    input            uart_axi_awready ,
    output  [31:0]   uart_axi_wdata ,
    // output  [3:0]    uart_axi_wstrb ,
    output           uart_axi_wvalid ,
    input            uart_axi_wready ,
    input  [1:0]     uart_axi_bresp ,
    input            uart_axi_bvalid ,
    output           uart_axi_bready ,
    output  [12:0]   uart_axi_araddr ,
    output           uart_axi_arvalid ,
    input            uart_axi_arready ,
    input  [31:0]    uart_axi_rdata ,
    input  [1:0]     uart_axi_rresp ,
    input            uart_axi_rvalid ,
    output           uart_axi_rready ,

    output 	     uart_irq
    
  );
