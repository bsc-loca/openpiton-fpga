/* -----------------------------------------------------------
* Project Name   : MEEP
* Organization   : Barcelona Supercomputing Center
* Test           : spike_scoreboard.sv
* Author(s)      : Saad Khalid
* Email(s)       : saad.khalid@bsc.es
* ------------------------------------------------------------
* Description:
* ------------------------------------------------------------
*/

`ifdef MEEP_COSIM

module spike_scoreboard(
  input                           clk,
  input                           rst,
  input                           commit,
  input [63:0]                    pc,
  input drac_pkg::exe_wb_instr_t  wb_stage,
  input  [4:0]                    xreg_dest,
  input drac_pkg::cu_rr_t         cu_rr_int,
  input [63:0]                    commit_data,
  input drac_pkg::reg64_t         xreg_1,
  input drac_pkg::reg64_t         xreg_2,
  input drac_pkg::reg64_t         xreg_3,
  input drac_pkg::reg64_t         xreg_4,
  input drac_pkg::reg64_t         xreg_5,
  input drac_pkg::reg64_t         xreg_6,
  input drac_pkg::reg64_t         xreg_7,
  input drac_pkg::reg64_t         xreg_8,
  input drac_pkg::reg64_t         xreg_9,
  input drac_pkg::reg64_t         xreg_10,
  input drac_pkg::reg64_t         xreg_11,
  input drac_pkg::reg64_t         xreg_12,
  input drac_pkg::reg64_t         xreg_13,
  input drac_pkg::reg64_t         xreg_14,
  input drac_pkg::reg64_t         xreg_15,
  input drac_pkg::reg64_t         xreg_16,
  input drac_pkg::reg64_t         xreg_17,
  input drac_pkg::reg64_t         xreg_18,
  input drac_pkg::reg64_t         xreg_19,
  input drac_pkg::reg64_t         xreg_20,
  input drac_pkg::reg64_t         xreg_21,
  input drac_pkg::reg64_t         xreg_22,
  input drac_pkg::reg64_t         xreg_23,
  input drac_pkg::reg64_t         xreg_24,
  input drac_pkg::reg64_t         xreg_25,
  input drac_pkg::reg64_t         xreg_26,
  input drac_pkg::reg64_t         xreg_27,
  input drac_pkg::reg64_t         xreg_28,
  input drac_pkg::reg64_t         xreg_29,
  input drac_pkg::reg64_t         xreg_30,
  input drac_pkg::reg64_t         xreg_31,
  input                           excep,
  input ariane_pkg::exception_t   csr_excep,
  input ariane_pkg::exception_t   ex_excep,
  input [63:0]                    csr_mip,
  input drac_pkg::pipeline_ctrl_t control_intf,
  input [63:0]                    hart_id,
  input [63:0]                    ref_hart_id
);

// OpenPiton-Lagarto implementation specific addresses
localparam logic [63:0] CLINT_BASE    = 64'h000000fff1020000;
localparam logic [63:0] BOOTROM_START = 64'hfff1010000;
localparam logic [63:0] BOOTROM_END   = 64'hfff1020000;
localparam logic [63:0] UART_START    = 64'hfff0c2c000;
localparam logic [63:0] UART_END      = 64'hfff0d00000;
localparam logic [63:0] MMR_MTIME     = CLINT_BASE + 64'h000000000000bff8;

// Default prints for Spike and RTL Commit Info
`define PRINT_SPIKE $display("[MEEP-COSIM][Spike] Core [%0d]: PC[%16h] Instr[%8h] r[%2d]:[%16h]    frg[%2d][%16h][%1d] DASM(0x%4h)", hart_id, spike_log.pc, spike_log.ins, spike_commit_log.dst, spike_commit_log.data, spike_commit_log.dst, spike_commit_log.data, is_float, spike_log.ins);

`define PRINT_RTL $display("[MEEP-COSIM][RTL]   Core [%0d]: PC[%16h] Instr[%8h] r[%2d]:[%16h][%1d] frg[%2d][%16h][%1d] DASM(0x%4h)", hart_id, pc_extended, instr, xreg_dest, commit_data, xreg_wr_valid, wb_stage.frd, commit_data, cu_rr_int.fwrite_enable, instr);

// hartid must be correct otherwise it could access non-existent hart of spike
HART_ID_CHECK:  assert property (@(posedge clk) ref_hart_id == hart_id)
                else $fatal("Incorrect hart ID from Design - Ref[%0d] Act[%0d]", ref_hart_id, hart_id);

import spike_dpi_pkg::*;
import riscv_pkg::*;
import drac_pkg::*;

logic [31:0]        instr;
longint unsigned    start_compare_pc = 64'h80000000;                               // after this PC, instruction by instruction match would start
int unsigned        spike_instr = 0;                                               // for tracking instruction number on spike
int unsigned        spike_instr_timeout = 100;
core_info_t         spike_log;
core_commit_info_t  spike_commit_log;
bit                 do_comparison = 0;
longint unsigned    pc_extended;
logic               xreg_wr_valid;
logic               is_exception;
logic               commit_or_excep;
logic               is_compressed;
logic [63:0]        exception_cause;
logic [63:0]        rs1_data;
logic               is_float;
logic [11:0]        instr_csr_addr;
logic               system_instr;
logic               is_mtime_mmr_read;
logic               is_mmio_read;
logic               is_mip_read;

assign instr = wb_stage.inst_orig;
assign pc_extended = $signed(pc);
assign xreg_wr_valid = cu_rr_int.write_enable && xreg_dest != 0;
assign is_exception = excep || csr_excep.valid;
assign commit_or_excep = commit && !control_intf.stall_exe;
assign is_compressed = ~&instr[1:0];
assign exception_cause = ex_excep.valid ? ex_excep.cause : csr_excep.cause;
assign is_float = instr[6:0] inside {riscv_pkg::OP_FP,
                                     riscv_pkg::OP_LOAD_FP,
                                     riscv_pkg::OP_STORE_FP,
                                     riscv_pkg::OP_FMADD,
                                     riscv_pkg::OP_FMSUB,
                                     riscv_pkg::OP_FNMSUB,
                                     riscv_pkg::OP_FNMADD};
assign instr_csr_addr = instr[31:20];
assign system_instr = instr[6:0] == riscv_pkg::OP_SYSTEM;
assign is_counter_read = xreg_wr_valid && system_instr && ((instr_csr_addr >= riscv::CSR_MCYCLE && instr_csr_addr <= riscv::CSR_MHPM_COUNTER_31) ||
                                                           (instr_csr_addr >= riscv::CSR_CYCLE && instr_csr_addr <= riscv::CSR_HPM_COUNTER_31));
assign is_mtime_mmr_read = xreg_wr_valid && rs1_data == MMR_MTIME && instr[6:0] == riscv_pkg::OP_LOAD;
assign is_mmio_read = xreg_wr_valid && ((rs1_data >= BOOTROM_START && rs1_data <= BOOTROM_END) || (rs1_data >= UART_START && rs1_data <= UART_END)) && instr[6:0] == riscv_pkg::OP_LOAD;
assign is_mip_read = xreg_wr_valid && system_instr && instr_csr_addr == riscv::CSR_MIP;

// Spike setup for cosimulation
initial begin
  @(posedge clk);

  // waiting till Spike reaches that particular PC after which instruction match will start,
  while(spike_log.pc != start_compare_pc) begin
    step(spike_log, hart_id);
      get_spike_commit_info(spike_commit_log, hart_id);

      `PRINT_RTL;
      `PRINT_SPIKE;

    spike_instr++;

    // there are only a few starting PCs, which are being ignored now so timing out after a certain threshold
    if (spike_instr >= spike_instr_timeout) begin
      $fatal("[MEEP-COSIM] Core [%0d]: Spike instruction count exceeded %d, but still did not reach start_compare_pc", hart_id, spike_instr_timeout);
    end
  end

  $display("[MEEP-COSIM] Core [%0d]: Spike at PC[%16h]. Now waiting for the step after RTL instruction will be committed.", hart_id, start_compare_pc);
end

// Cosimulation - Scoreboard
always @(posedge clk) begin
  if(commit_or_excep || (commit && is_exception)) begin
    // Instruction comparison
    if (pc_extended == start_compare_pc || do_comparison) begin
      // as soon as RTL PC reaches start_compare_pc, it should start comparison
      do_comparison <= 1;

      // Overriding stuff from RTL
      // 1. HPM counter CSRs
      // 2. mip CSR

      // when there is interrupt on RTL, override mip CSR since it depends upon MMRs in hardware
      // and Spike may have values reflected immediately in mip, so overriding mip CSR in Spike
      if (spike_get_csr(riscv::CSR_MIP) != csr_mip && is_exception && exception_cause[63]) begin
        $display("[MEEP-COSIM] Overridden Spike mip - Hart[%0d] spike old mip[%0h] spike new mip[%16h]" , hart_id, spike_get_csr(riscv::CSR_MIP), csr_mip);
        override_csr_backdoor(hart_id, riscv::CSR_MIP, csr_mip);
      end

      // do not increment for 1st instruction, since its already at the correct PC
      if (do_comparison) begin
        step(spike_log, hart_id);
        spike_instr++;
      end

      // Counters (instret, cycle and other PMU counters) are not implemented in Spike
      // since those counters are already being checked via PMU scoreboard so just
      // overriding Spike whenever there is a read from any counter. Also reg data comparison
      // for such instruction is not necessary
      // mtime MMR and mip CSR read could also contain different values for Spike and RTL so
      // overriding those too
      if (is_counter_read || is_mtime_mmr_read || is_mmio_read || is_mip_read) begin
        override_spike_gpr(hart_id, xreg_dest, commit_data);
        $display("[MEEP-COSIM] Overridden Spike - Core[%0d] GPR[%0d][%16h]" , hart_id, xreg_dest, spike_get_gpr(xreg_dest));
      end

      get_spike_commit_info(spike_commit_log, hart_id);

      `PRINT_RTL;

      if (is_exception) begin
          if (exception_cause[63]) begin
            $display("[MEEP-COSIM] Interrupt - mcause[%16h]", exception_cause);
          end else begin
            $display("[MEEP-COSIM] Exception - mcause[%16h]", exception_cause);
          end
      end else begin
          // PC Comparison
          if (pc_extended != spike_log.pc) begin
            $fatal(1, "[MEEP-COSIM] Core [%0d]: PC Mismatch between RTL[%16h] and Spike[%16h]!", hart_id, pc_extended, spike_log.pc);
            `PRINT_SPIKE;
          end

          // Instruction Comparison
          if (is_compressed) begin
            if (instr[15:0] != spike_log.ins[15:0]) begin
              `PRINT_SPIKE;
              $fatal(1, "[MEEP-COSIM] Core [%0d]: Instruction Mismatch between RTL[%8h] and Spike[%8h]!", hart_id, instr[15:0], spike_log.ins[15:0]);
            end
          end else begin
            if (instr != spike_log.ins) begin
              `PRINT_SPIKE;
              $fatal(1, "[MEEP-COSIM] Core [%0d]: Instruction Mismatch between RTL[%16h] and Spike[%16h]!", hart_id, instr, spike_log.ins);
            end
          end

          // Destination X-Reg Comparison
          if (xreg_wr_valid && xreg_dest != spike_commit_log.dst) begin
            `PRINT_SPIKE;
            $fatal(1, "[MEEP-COSIM] Core [%0d]: Destination Register Address Mismatch between RTL[%d] and Spike[%d]!", hart_id, xreg_dest, spike_commit_log.dst);
          end
          // Destination X-Reg Data Comparison
          if (xreg_wr_valid && commit_data != spike_commit_log.data && !is_counter_read && !is_mtime_mmr_read && !is_mmio_read && !is_mip_read) begin
            `PRINT_SPIKE;
            if (system_instr) begin
              $fatal(1, "[MEEP-COSIM] Core [%0d]: CSR - 0x%3h Read Mismatch between RTL[%16h] and Spike[%16h]!", hart_id, instr_csr_addr, commit_data, spike_commit_log.data);
            end else begin
              $fatal(1, "[MEEP-COSIM] Core [%0d]: Destination Register Data Mismatch between RTL[%16h] and Spike[%16h]!", hart_id, commit_data, spike_commit_log.data);
            end
         end
          // Destination F-Reg Comparison
          if (cu_rr_int.fwrite_enable && wb_stage.frd != spike_commit_log.dst) begin
            `PRINT_SPIKE;
            $fatal(1, "[MEEP-COSIM] Core [%0d]: Destination Floating Register Address Mismatch between RTL[%d] and Spike[%d]!", hart_id, xreg_dest, spike_commit_log.dst);
          end
          // Destination F-Reg Data Comparison
          if (cu_rr_int.fwrite_enable && commit_data != spike_commit_log.data) begin
            `PRINT_SPIKE;
            $fatal(1, "[MEEP-COSIM] Core [%0d]: Destination Floating Register Data Mismatch between RTL[%16h] and Spike[%16h]!", hart_id, commit_data, spike_commit_log.data);
          end
      end

      // if (spike_instr >= 50000) begin
      //   do_comparison <= 0;
      //   stop_execution();
      //   $finish();
      // end
    end
  end
end

always_comb begin
  case (wb_stage.rs1)
    1  : rs1_data = xreg_1;
    2  : rs1_data = xreg_2;
    3  : rs1_data = xreg_3;
    4  : rs1_data = xreg_4;
    5  : rs1_data = xreg_5;
    6  : rs1_data = xreg_6;
    7  : rs1_data = xreg_7;
    8  : rs1_data = xreg_8;
    9  : rs1_data = xreg_9;
    10 : rs1_data = xreg_10;
    11 : rs1_data = xreg_11;
    12 : rs1_data = xreg_12;
    13 : rs1_data = xreg_13;
    14 : rs1_data = xreg_14;
    15 : rs1_data = xreg_15;
    16 : rs1_data = xreg_16;
    17 : rs1_data = xreg_17;
    18 : rs1_data = xreg_18;
    19 : rs1_data = xreg_19;
    20 : rs1_data = xreg_20;
    21 : rs1_data = xreg_21;
    22 : rs1_data = xreg_22;
    23 : rs1_data = xreg_23;
    24 : rs1_data = xreg_24;
    25 : rs1_data = xreg_25;
    26 : rs1_data = xreg_26;
    27 : rs1_data = xreg_27;
    28 : rs1_data = xreg_28;
    29 : rs1_data = xreg_29;
    30 : rs1_data = xreg_30;
    31 : rs1_data = xreg_31;
    default: rs1_data = 64'h0;
  endcase
end

endmodule
`endif
