// Hello world

/* module noc_axilite_bridge #(
    // SLAVE_RESP_BYTEWIDTH = 0 enables variable width accesses
    // note that the accesses are still 64bit, but the
    // write-enables are generated according to the access size
    parameter SLAVE_RESP_BYTEWIDTH = 4,
    // swap endianess, needed when used in conjunction with a little endian core like Ariane
    parameter SWAP_ENDIANESS       = 0,
    // shift unaligned read data
    parameter ALIGN_RDATA          = 1
) (
    // Clock + Reset
    input  wire                                   clk,
    input  wire                                   rst,

    // Memory Splitter -> AXI SPI
    input  wire                                   splitter_bridge_val,
    input  wire [`NOC_DATA_WIDTH-1:0]             splitter_bridge_data,
    output wire                                   bridge_splitter_rdy,

    // Memory Splitter <- AXI SPI
    output  reg                                   bridge_splitter_val,
    output  reg  [`NOC_DATA_WIDTH-1:0]            bridge_splitter_data,
    input  wire                                   splitter_bridge_rdy,

    // AXI Write Address Channel Signals
    output  reg  [`C_M_AXI_LITE_ADDR_WIDTH-1:0]   m_axi_awaddr,
    output  reg                                   m_axi_awvalid,
    input  wire                                   m_axi_awready,

    // AXI Write Data Channel Signals
    output wire  [`C_M_AXI_LITE_DATA_WIDTH-1:0]   m_axi_wdata,
    output  reg  [`C_M_AXI_LITE_DATA_WIDTH/8-1:0] m_axi_wstrb,
    output  reg                                   m_axi_wvalid,
    input  wire                                   m_axi_wready,

    // AXI Read Address Channel Signals
    output  reg  [`C_M_AXI_LITE_ADDR_WIDTH-1:0]   m_axi_araddr,
    output  reg                                   m_axi_arvalid,
    input                                         m_axi_arready,

    // AXI Read Data Channel Signals
    input  wire [`C_M_AXI_LITE_DATA_WIDTH-1:0]    m_axi_rdata,
    input  wire [`C_M_AXI_LITE_RESP_WIDTH-1:0]    m_axi_rresp,
    input  wire                                   m_axi_rvalid,
    output  reg                                   m_axi_rready,

    // AXI Write Response Channel Signals
    input  wire [`C_M_AXI_LITE_RESP_WIDTH-1:0]    m_axi_bresp,
    input  wire                                   m_axi_bvalid,
    output reg                                    m_axi_bready,

    // this does not belong to axi lite and is non-standard
    output  reg  [`C_M_AXI_LITE_SIZE_WIDTH-1:0]   w_reqbuf_size,
    output  reg  [`C_M_AXI_LITE_SIZE_WIDTH-1:0]   r_reqbuf_size
); */