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
  input [31:0]                    instr,
  input  [4:0]                    xreg_dest,
  input drac_pkg::cu_rr_t         cu_rr_int,
  input [63:0]                    commit_data,
  input                           excep,
  input ariane_pkg::exception_t   csr_excep,
  input drac_pkg::pipeline_ctrl_t control_intf,
  input [63:0]                    hart_id,
  input [63:0]                    ref_hart_id
);

// hartid must be correct otherwise it could access non-existent hart of spike
HART_ID_CHECK:  assert property (@(posedge clk) ref_hart_id == hart_id)
                else $fatal("Incorrect hart ID from Design - Ref[%0d] Act[%0d]", ref_hart_id, hart_id);

import spike_dpi_pkg::*;

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

assign pc_extended = $signed(pc);
assign xreg_wr_valid = cu_rr_int.write_enable && xreg_dest != 0;
assign is_exception = excep || csr_excep.valid;
assign commit_or_excep = commit && !control_intf.stall_exe;
assign is_compressed = ~&instr[1:0];

// Spike setup for cosimulation
initial begin
  @(posedge clk);

  // waiting till Spike reaches that particular PC after which instruction match will start,
  while(spike_log.pc != start_compare_pc) begin
    step(spike_log, hart_id);

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
  if(commit_or_excep) begin
    // Instruction comparison
    if (pc_extended == start_compare_pc || do_comparison) begin
      // as soon as RTL PC reaches start_compare_pc, it should start comparison
      do_comparison <= 1;
      get_spike_commit_info(spike_commit_log, hart_id);

      $display("[MEEP-COSIM][RTL]   Core [%0d]: PC[%16h] Instr[%8h] r[%0d]:[%16h][%d]", hart_id, pc_extended, instr, xreg_dest, commit_data, xreg_wr_valid);
      $display("[MEEP-COSIM][Spike] Core [%0d]: PC[%16h] Instr[%8h] r[%0d]:[%16h]", hart_id, spike_log.pc, spike_log.ins, spike_commit_log.dst, spike_commit_log.data);

      if (is_exception) begin
          $display("[MEEP-COSIM] Exception - mcause[%16h]", csr_excep.cause);
      end else begin
          // PC Comparison
          if (pc_extended != spike_log.pc) $error("[MEEP-COSIM] Core [%0d]: PC Mismatch between RTL[%16h] and Spike[%16h]!", hart_id, pc_extended, spike_log.pc);

          // Instruction Comparison
          if (is_compressed) begin
            if (instr[15:0] != spike_log.ins[15:0]) $error("[MEEP-COSIM] Core [%0d]: Instruction Mismatch between RTL[%8h] and Spike[%8h]!", hart_id, instr[15:0], spike_log.ins[15:0]);
          end else begin
            if (instr != spike_log.ins) $error("[MEEP-COSIM] Core [%0d]: Instruction Mismatch between RTL[%16h] and Spike[%16h]!", hart_id, instr, spike_log.ins);
          end

          // Destination X-Reg Comparison
          if (xreg_wr_valid && xreg_dest != spike_commit_log.dst) $error("[MEEP-COSIM] Core [%0d]: Destination Register Address Mismatch between RTL[%d] and Spike[%d]!", hart_id, xreg_dest, spike_commit_log.dst);

          // Destination X-Reg Data Comparison
          if (xreg_wr_valid && commit_data != spike_commit_log.data) $error("[MEEP-COSIM] Core [%0d]: Destination Register Mismatch between RTL[%16h] and Spike[%16h]!", hart_id, commit_data, spike_commit_log.data);
      end

      step(spike_log, hart_id);
      spike_instr++;

      // if (spike_instr >= 50000) begin
      //   do_comparison <= 0;
      //   stop_execution();
      //   $finish();
      // end
    end
  end
end
endmodule
`endif
