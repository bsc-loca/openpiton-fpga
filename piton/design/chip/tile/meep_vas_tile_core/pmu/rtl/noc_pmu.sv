// Title      : noc_pmu
// Project    : MEEP
// License    : <License type>
/*****************************************************************************/
// File        : noc_pmu.sv
// Author      : Pablo Criado Albillos; pablo.criado@bsc.es
// Company     : Barcelona Supercomputing Center (BSC)
// Created     : 28/07/2021
// Last update : 30/07/2021
/*****************************************************************************/
// Description: Performance Monitoring Unit - NoC interface
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

`include "define.tmp.h"

module noc_pmu #(
    // Data width
    parameter int unsigned DATA_WIDTH = 64,
    // Address width
    parameter int unsigned ADDRESS_WIDTH = 64,

    // Number of CPU cores
    parameter integer TILE_COUNT,
    // Number of event signals
    parameter integer EVENT_SIGNAL_COUNT = 23,
    // Bit width for register addressing
    parameter integer ADDR_REG_WIDTH = 6,
    // Bit width for tile addressing
    parameter integer ADDR_TILE_WIDTH = 7,
    // Bit width for 64bit alignment
    parameter integer ADDR_ALIGN_WIDTH = 3
) (
    input rst,

    input noc_clk,
    input [DATA_WIDTH-1:0] buf_noc2_data_i,
    input buf_noc2_valid_i,
    output buf_noc2_ready_o,
    output [DATA_WIDTH-1:0] buf_noc3_data_o,
    output buf_noc3_valid_o,
    input buf_noc3_ready_i,

    input counter_clk,
    input [TILE_COUNT-1:0][EVENT_SIGNAL_COUNT-1:0] pmu_sig_i
);

  AXI_BUS #(
      .AXI_ID_WIDTH  (1),
      .AXI_ADDR_WIDTH(ADDRESS_WIDTH),
      .AXI_DATA_WIDTH(DATA_WIDTH),
      .AXI_USER_WIDTH(1)
  ) plic_master ();

  noc_axilite_bridge #(
      .SLAVE_RESP_BYTEWIDTH(0),
      .SWAP_ENDIANESS      (1),
      // this disables shifting of unaligned read data
      .ALIGN_RDATA         (0)
  ) i_plic_axilite_bridge (
      .clk                 (noc_clk),
      .rst                 (~rst),  // Inverse??
      // to/from NOC
      .splitter_bridge_val (buf_noc2_valid_i),
      .splitter_bridge_data(buf_noc2_data_i),
      .bridge_splitter_rdy (buf_noc2_ready_o),
      .bridge_splitter_val (buf_noc3_valid_o),
      .bridge_splitter_data(buf_noc3_data_o),
      .splitter_bridge_rdy (buf_noc3_ready_i),
      //axi lite signals
      //write address channel
      .m_axi_awaddr        (plic_master.aw_addr),
      .m_axi_awvalid       (plic_master.aw_valid),
      .m_axi_awready       (plic_master.aw_ready),
      //write data channel
      .m_axi_wdata         (plic_master.w_data),
      .m_axi_wstrb         (plic_master.w_strb),
      .m_axi_wvalid        (plic_master.w_valid),
      .m_axi_wready        (plic_master.w_ready),
      //read address channel
      .m_axi_araddr        (plic_master.ar_addr),
      .m_axi_arvalid       (plic_master.ar_valid),
      .m_axi_arready       (plic_master.ar_ready),
      //read data channel
      .m_axi_rdata         (plic_master.r_data),
      .m_axi_rresp         (plic_master.r_resp),
      .m_axi_rvalid        (plic_master.r_valid),
      .m_axi_rready        (plic_master.r_ready),
      //write response channel
      .m_axi_bresp         (plic_master.b_resp),
      .m_axi_bvalid        (plic_master.b_valid),
      .m_axi_bready        (plic_master.b_ready),
      // non-axi-lite signals
      .w_reqbuf_size       (plic_master.aw_size),
      .r_reqbuf_size       (plic_master.ar_size)
  );


  logic [DATA_WIDTH-1:0] counter_read_data, counter_write_data;
  logic [ADDR_TILE_WIDTH+ADDR_REG_WIDTH+ADDR_ALIGN_WIDTH-1:0]
      counter_read_address, counter_write_address;
  logic counter_read_enable, counter_read_valid, counter_write_enable, counter_write_valid;
  logic counter_read_enable_syn, counter_write_enable_syn;  // Synchronized signals
  axi_pmu #(
      .COUNTER_DATA_WIDTH(DATA_WIDTH),
      .COUNTER_ADDRESS_WIDTH(ADDR_TILE_WIDTH + ADDR_REG_WIDTH + ADDR_ALIGN_WIDTH)
  ) axi_pmu (
      .S_AXI_ACLK(noc_clk),
      .S_AXI_ARESETN(rst),
      .S_AXI_AWADDR(plic_master.aw_addr),
      .S_AXI_AWPROT(),
      .S_AXI_AWVALID(plic_master.aw_valid),
      .S_AXI_AWREADY(plic_master.aw_ready),
      .S_AXI_WDATA(plic_master.w_data),
      .S_AXI_WSTRB(plic_master.w_strb),
      .S_AXI_WVALID(plic_master.w_valid),
      .S_AXI_WREADY(plic_master.w_ready),
      .S_AXI_BRESP(plic_master.b_resp),
      .S_AXI_BVALID(plic_master.b_valid),
      .S_AXI_BREADY(plic_master.b_ready),
      .S_AXI_ARADDR(plic_master.ar_addr),
      .S_AXI_ARPROT(plic_master.ar_prot),
      .S_AXI_ARVALID(plic_master.ar_valid),
      .S_AXI_ARREADY(plic_master.ar_ready),
      .S_AXI_RDATA(plic_master.r_data),
      .S_AXI_RRESP(plic_master.r_resp),
      .S_AXI_RVALID(plic_master.r_valid),
      .S_AXI_RREADY(plic_master.r_ready),

      // Data read from AXI bridge to registers
      .counter_read_enable(counter_read_enable),
      .counter_read_valid(counter_read_valid),
      .counter_read_address(counter_read_address),
      .counter_read_data(counter_read_data),

      // Data write from AXI bridge to registers
      .counter_write_enable(counter_write_enable),
      .counter_write_valid(counter_write_valid),
      .counter_write_address(counter_write_address),
      .counter_write_data(counter_write_data)
  );

  logic [TILE_COUNT-1:0][EVENT_SIGNAL_COUNT:0][DATA_WIDTH-1:0] registers;  // Data registers (as many as input signals + 1 config)

  // Read logic
  synchronizer_2_stage read_syn (
      .in (counter_read_enable),
      .out(counter_read_enable_syn),
      .clk(counter_clk)
  );
  // Decode read address
  logic [ADDR_TILE_WIDTH-1:0] read_tile;
  logic [ ADDR_REG_WIDTH-1:0] read_register;
  assign read_tile = counter_read_address[ADDR_REG_WIDTH+ADDR_ALIGN_WIDTH+:ADDR_TILE_WIDTH];
  assign read_register = counter_read_address[ADDR_ALIGN_WIDTH+:ADDR_REG_WIDTH];

  always_ff @(counter_clk) begin
    if (counter_read_enable_syn && ~counter_read_valid) begin
      // Check address is in bounds
      if (read_tile < TILE_COUNT && read_register < EVENT_SIGNAL_COUNT + 1) begin
        counter_read_data <= registers[read_tile][read_register];
      end else begin
        counter_read_data <= {DATA_WIDTH{1'b1}};
        /* synopsys translate_off */
        $display("An attempt was made to access a PMU register out of bounds");
        /* synopsys translate_on */
      end
      counter_read_valid <= 1'b1;
    end else if (~counter_read_enable_syn) begin
      counter_read_data  <= 0;
      counter_read_valid <= 1'b0;
    end
  end

  // Write logic
  synchronizer_2_stage write_syn (
      .in (counter_write_enable),
      .out(counter_write_enable_syn),
      .clk(counter_clk)
  );
  logic [ADDR_TILE_WIDTH+ADDR_REG_WIDTH+ADDR_ALIGN_WIDTH-1:0] write_address;
  logic [DATA_WIDTH-1:0] write_data;
  logic write_enable;
  // Decode write address
  logic [ADDR_TILE_WIDTH-1:0] write_tile;
  logic [ADDR_REG_WIDTH-1:0] write_register;
  assign write_tile = write_address[ADDR_REG_WIDTH+ADDR_ALIGN_WIDTH+:ADDR_TILE_WIDTH];
  assign write_register = write_address[ADDR_ALIGN_WIDTH+:ADDR_REG_WIDTH];

  always_ff @(counter_clk) begin
    if (counter_write_enable_syn) begin
      write_enable <= 1'b1;
      write_data <= counter_write_data;
      write_address <= counter_write_address;
      // Inform successfull write
      counter_write_valid <= 1'b1;
    end else begin
      write_enable <= 1'b0;
      counter_write_valid <= 1'b0;
    end
  end

  // Counter logic
  always_ff @(posedge counter_clk) begin
    for (int tile = 0; tile < TILE_COUNT; tile++) begin
      // Fetch counter status from config register (last one for the tile)
      logic counter_enable, counter_reset;
      counter_enable = registers[tile][0][0];
      counter_reset  = registers[tile][0][1];

      // Logic for counters
      for (int register = 1; register < EVENT_SIGNAL_COUNT + 1; register++) begin
        if (rst == 1'b0 || counter_reset == 1'b1) registers[tile][register] <= 0;  // Reset logic
        else if (write_enable && write_tile == tile && write_register == register) begin
          registers[tile][register] <= write_data;  // Write incoming data to register
        end else if (counter_enable == 1'b1 && pmu_sig_i[tile][register-1] == 1'b1)
          registers[tile][register] <= registers[tile][register]+1; // Increment counters when required
      end

      // Logic for config register
      if (rst == 1'b0) registers[tile][0] <= 2'b00;  // Reset config
      else if (write_enable && write_tile == tile && write_register == 0) begin
        registers[tile][0] <= write_data;  // Write incoming data to register
      end

    end

  end

endmodule
