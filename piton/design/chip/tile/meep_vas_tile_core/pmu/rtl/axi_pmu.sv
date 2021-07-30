// Title      : axi_pmu
// Project    : MEEP
// License    : <License type>
/*****************************************************************************/
// File        : axi_pmu.sv
// Author      : Pablo Criado Albillos; pablo.criado@bsc.es
// Company     : Barcelona Supercomputing Center (BSC)
// Created     : 28/07/2021
// Last update : 30/07/2021
/*****************************************************************************/
// Description: Performance Monitoring Unit - Axi register handler
//
// Comments    : https://wiki.meep-project.eu/index.php/Lagarto_PMU_openpiton
/*****************************************************************************/
// Copyright (c) 2021 BSC
/*****************************************************************************/
// Revisions  :
// Date/Time                Version               Engineer
// 28/07/2021               1.0                   pablo.criado@bsc.es
// Comments   : Initial implementation
/*****************************************************************************/

module axi_pmu #(
    // Width of S_AXI data bus
    parameter integer C_S_AXI_DATA_WIDTH = 64,
    // Width of S_AXI address bus
    parameter integer C_S_AXI_ADDR_WIDTH = 64
    // Amount of counters
    // parameter integer N_COUNTERS	= 23,
    // Configuration registers
    // parameter integer N_CONF_REGS	= 1
) (
    // Global Clock Signal
    input logic S_AXI_ACLK,
    // Global Reset Signal. This Signal is Active LOW
    input logic S_AXI_ARESETN,
    // Write address (issued by master, acceped by Slave)
    input logic [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
    // Write channel Protection type. This signal indicates the
    // privilege and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
    input logic [2 : 0] S_AXI_AWPROT,
    // Write address valid. This signal indicates that the master signaling
    // valid write address and control information.
    input logic S_AXI_AWVALID,
    // Write address ready. This signal indicates that the slave is ready
    // to accept an address and associated control signals.
    output logic S_AXI_AWREADY,
    // Write data (issued by master, acceped by Slave) 
    input logic [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
    // Write strobes. This signal indicates which byte lanes hold
    // valid data. There is one write strobe bit for each eight
    // bits of the write data bus.    
    input logic [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
    // Write valid. This signal indicates that valid write
    // data and strobes are available.
    input logic S_AXI_WVALID,
    // Write ready. This signal indicates that the slave
    // can accept the write data.
    output logic S_AXI_WREADY,
    // Write response. This signal indicates the status
    // of the write transaction.
    output logic [1 : 0] S_AXI_BRESP,
    // Write response valid. This signal indicates that the channel
    // is signaling a valid write response.
    output logic S_AXI_BVALID,
    // Response ready. This signal indicates that the master
    // can accept a write response.
    input logic S_AXI_BREADY,
    // Read address (issued by master, acceped by Slave)
    input logic [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
    // Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether the
    // transaction is a data access or an instruction access.
    input logic [2 : 0] S_AXI_ARPROT,
    // Read address valid. This signal indicates that the channel
    // is signaling valid read address and control information.
    input logic S_AXI_ARVALID,
    // Read address ready. This signal indicates that the slave is
    // ready to accept an address and associated control signals.
    output logic S_AXI_ARREADY,
    // Read data (issued by slave)
    output logic [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
    // Read response. This signal indicates the status of the
    // read transfer.
    output logic [1 : 0] S_AXI_RRESP,
    // Read valid. This signal indicates that the channel is
    // signaling the required read data.
    output logic S_AXI_RVALID,
    // Read ready. This signal indicates that the master can
    // accept the read data and response information.
    input logic S_AXI_RREADY,

    //TODO use parameters
    // Interface to counters
    // Read interface		
    output logic counter_read_enable,
    input logic counter_read_valid,
    output logic [7:0] counter_read_address,
    input logic [63:0] counter_read_data,
    // Write interface
    output logic counter_write_enable,
    input logic counter_write_valid,
    output logic [7:0] counter_write_address,
    output logic [63:0] counter_write_data
);


  localparam integer ADDRESS_OFFSET = 'hfff5100000;


  // Writing logic

  // Signaling for writing address input
  logic aw_available;  // Signal to indicate writing address is available to be used
  always_ff @(posedge S_AXI_ACLK) begin
    if (S_AXI_ARESETN == 1'b0) begin
      aw_available <= 1'b0;
      S_AXI_AWREADY <= 1'b0;
      counter_write_address <= 0;
    end else begin
      if (~aw_available && S_AXI_AWVALID) begin
        // We are ready to receive the address
        S_AXI_AWREADY <= 1'b1;
        aw_available <= 1'b1;
        counter_write_address <= (S_AXI_AWADDR - ADDRESS_OFFSET) >> 3;
      end else if (S_AXI_AWREADY) begin
        S_AXI_AWREADY <= 1'b0;
      end
    end
  end

  // Signaling for writing data input
  logic w_available;  // Signal to indicate writing data is available to be used
  always_ff @(posedge S_AXI_ACLK) begin
    if (S_AXI_ARESETN == 1'b0) begin
      w_available <= 1'b0;
      S_AXI_WREADY <= 1'b0;
      counter_write_data <= 0;
    end else begin
      if (~w_available && S_AXI_WVALID) begin
        // We are ready to receive the data
        S_AXI_WREADY <= 1'b1;
        w_available <= 1'b1;
        counter_write_data <= S_AXI_WDATA;
      end else if (S_AXI_WREADY) begin
        S_AXI_WREADY <= 1'b0;
      end
    end
  end

  // Handle writing
  logic counter_write_valid_syn;
  synchronizer_2_stage write_syn (
      .in (counter_write_valid),
      .out(counter_write_valid_syn),
      .clk(S_AXI_ACLK)
  );

  always_ff @(posedge S_AXI_ACLK) begin
    if (S_AXI_ARESETN == 1'b0) begin
      counter_write_enable <= 1'b0;
      S_AXI_BVALID <= 0;
      S_AXI_BRESP <= 2'b0;
    end else begin
      if (aw_available && w_available && ~counter_write_enable && ~S_AXI_BVALID) begin
        //	Data and address are available, start request
        counter_write_enable <= 1'b1;
      end else if (counter_write_enable && counter_write_valid_syn) begin
        //	Write operation finished
        counter_write_enable <= 1'b0;
        aw_available <= 0'b0;
        w_available <= 0'b0;

        //	Send response
        S_AXI_BRESP <= 2'b0;
        S_AXI_BVALID <= 1'b1;
      end else if (S_AXI_BVALID && S_AXI_BREADY) begin
        S_AXI_BVALID <= 1'b0;
      end
    end
  end

  // Read logic

  // Signaling for reading address input
  logic ar_available;  // Signal to indicate reading address is available to be used
  always_ff @(posedge S_AXI_ACLK) begin
    if (S_AXI_ARESETN == 1'b0) begin
      ar_available <= 1'b0;
      S_AXI_ARREADY <= 1'b0;
      counter_read_address <= 0;
    end else begin
      if (~ar_available && S_AXI_ARVALID) begin
        // We are ready to receive the address
        S_AXI_ARREADY <= 1'b1;
        ar_available <= 1'b1;
        counter_read_address <= (S_AXI_ARADDR - ADDRESS_OFFSET) >> 3;
      end else if (S_AXI_ARREADY) begin
        S_AXI_ARREADY <= 1'b0;
      end
    end
  end

  // Synchronizer for read_valid signal from register bank
  logic counter_read_valid_syn;
  synchronizer_2_stage read_syn (
      .in (counter_read_valid),
      .out(counter_read_valid_syn),
      .clk(S_AXI_ACLK)
  );

  always_ff @(posedge S_AXI_ACLK) begin
    if (S_AXI_ARESETN == 1'b0) begin
      counter_read_enable <= 1'b0;
      S_AXI_RVALID <= 0;
      S_AXI_RRESP <= 2'b0;
      S_AXI_RDATA <= 0;
    end else begin
      if (ar_available && ~counter_read_enable && ~S_AXI_RVALID) begin
        //	Address is available, start read request
        counter_read_enable <= 1'b1;
      end else if (counter_read_enable && counter_read_valid_syn) begin
        //	Read operation finished
        S_AXI_RDATA <= counter_read_data;

        counter_read_enable <= 1'b0;
        ar_available <= 0'b0;

        //	Send response
        S_AXI_RRESP <= 2'b0;
        S_AXI_RVALID <= 1'b1;
      end else if (S_AXI_RVALID && S_AXI_RREADY) begin
        S_AXI_RVALID <= 1'b0;
        S_AXI_RDATA  <= 0;
      end
    end
  end
endmodule
