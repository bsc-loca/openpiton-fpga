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

import vpu_scoreboard_pkg::*;

module spike_scoreboard(
  input                           clk,
  input                           rst,
  input                           commit,
  input [63:0]                    pc,
  input drac_pkg::exe_wb_instr_t  exe_to_wb_wb,
  input  [4:0]                    xreg_dest,
  input drac_pkg::cu_rr_t         cu_rr_int,
  input [63:0]                    commit_data,
  input                           excep,
  input ariane_pkg::exception_t   csr_excep,
  input drac_pkg::pipeline_ctrl_t control_intf,
  input drac_pkg::vpu_completed_t vpu_resp,
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
logic               vpu_completed;
logic               scalar_instr_commit;
logic               vector_instr_commit;
logic               commit_or_excep;
logic               is_compressed;
logic               is_vector;
logic [31:0]        instr;
vreg_elements_t     vpu_res;
// logic [vpu_scoreboard_pkg::MAX_VLEN-1:0] vrf_vpu [int];
// logic [vpu_scoreboard_pkg::MAX_VLEN-1:0] vrf_spike [int];

assign instr = exe_to_wb_wb.inst;
assign is_vector = exe_to_wb_wb.is_vector;
assign vpu_completed = vpu_resp.valid;
assign pc_extended = $signed(pc);
assign xreg_wr_valid = cu_rr_int.write_enable && xreg_dest != 0;
assign is_exception = excep || csr_excep.valid;
assign scalar_instr_commit = commit && !control_intf.stall_exe && !is_vector;
assign vector_instr_commit = vpu_completed;
assign commit_or_excep = scalar_instr_commit || vector_instr_commit || is_exception;
assign is_compressed = ~&instr[1:0];

vpu_sim_vreg_if vreg_if();

`ifdef BSC_RTL_SRAMS
  generate
    for(genvar i = 0; i < vpu_scoreboard_pkg::N_LANES; i++) begin
      for(genvar bnk = 0; bnk < vpu_scoreboard_pkg::N_BANKS; bnk++) begin
        for(genvar j = 0; j < vpu_scoreboard_pkg::VRF_WPACK; j++) begin
          assign vreg_if.lane[i].bank[bnk].subbank[j] = `VPU_0.vector_lane_gen[i].vector_lane_inst.vrf_slice_wrapper_inst.vrf_slice_inst.vrf_bank_gen[bnk].vrf_bank_inst.ram_dp_gen[j].ram_dp_inst.mem;
        end
      end
    end
  endgenerate
`endif

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

mailbox vrf_spike = new();
logic [4:0] vdest_rtl;

// Vector Scoreboard
always @(posedge clk) begin
  automatic logic [vpu_scoreboard_pkg::MAX_VLEN-1:0] vec_reg_spike;
  automatic logic [vpu_scoreboard_pkg::MAX_VLEN-1:0] vec_reg_rtl;

  vdest_rtl <= `VPU_0.lreg_rob_renaming; // TODO: make VPU_0 macro parameterizable for multi core
  if (`VPU_0.completed_valid_o) begin
    vpu_res = retrieve_vpu_result(`VPU_0.reorder_buffer_inst.vreg_o, 64);
    vrf_spike.get(vec_reg_spike);

    for (int elem = 0; elem < vpu_scoreboard_pkg::MAX_64BIT_BLOCKS; elem++) begin
      vec_reg_rtl = {vec_reg_rtl << 64, vpu_res[vpu_scoreboard_pkg::MAX_64BIT_BLOCKS - elem - 1]};
    end

    $display("[MEEP-COSIM][VPU-RTL]   Core [%0d]: V[%h][%h]", hart_id, vdest_rtl, vec_reg_rtl);
    $display("[MEEP-COSIM][VPU-Spike] Core [%0d]: V[%h][%h]", hart_id, vdest_rtl, vec_reg_spike);

    if (vec_reg_rtl != vec_reg_spike) $error("[MEEP-COSIM] Core [%0d]: Vector Reg Mismatch between RTL[%h] and Spike[%h]!", hart_id, vec_reg_rtl, vec_reg_spike);
  end
end

// Cosimulation - Scoreboard
always @(posedge clk) begin
  automatic logic [vpu_scoreboard_pkg::MAX_VLEN-1:0] vec_reg;

  if(commit_or_excep) begin
    // Instruction comparison
    if (pc_extended == start_compare_pc || do_comparison) begin
      // as soon as RTL PC reaches start_compare_pc, it should start comparison
      do_comparison <= 1;
      get_spike_commit_info(spike_commit_log, hart_id);
      $display("[MEEP-COSIM][RTL]   Core [%0d]: PC[%16h] Instr[%8h] r[%0d]:[%16h][%d]", hart_id, pc_extended, instr, xreg_dest, commit_data, xreg_wr_valid);
      $display("[MEEP-COSIM][Spike] Core [%0d]: PC[%16h] Instr[%8h] r[%0d]:[%16h]", hart_id, spike_log.pc, spike_log.ins, spike_commit_log.dst, spike_commit_log.data);

      if (is_vector) begin
        // converting structure into a packed array
        foreach (spike_log.vector_operands.vd[elem]) begin
          vec_reg = {vec_reg << 64, spike_log.vector_operands.vd[elem]};
        end
        vrf_spike.put(vec_reg);
      end

      if (is_exception) begin
        $display("[MEEP-COSIM] Exception - mcause[%16h]", csr_excep.cause);
      // if there is a vector_instr_commit, corresponding PC, instr and scalar reg data would not be for that instruction so skipping in that scenario
      // below check would be for every scalar instruction and vector instruction's PC, instruction. Vector reg contents will be checked on completed_valid from VPU
      end else if (!vector_instr_commit || is_vector) begin
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

// From Unit Level VPU verification environment
    // Function: retrieve_vpu_result
    // Takes value of the destination register of the instruction in the VPU
    function vreg_elements_t retrieve_vpu_result(int vdest, int sew);
        vreg_elements_t vec_el;
        automatic int elements = 0;
        automatic int lane = 0;
        automatic int elems_per_lane = vpu_scoreboard_pkg::MAX_64BIT_BLOCKS/vpu_scoreboard_pkg::N_LANES;
        automatic int bank = (vdest*elems_per_lane)%vpu_scoreboard_pkg::N_BANKS;
        automatic int addr = (vdest*elems_per_lane)/vpu_scoreboard_pkg::N_BANKS;
        automatic int sub_banks = vpu_scoreboard_pkg::VRF_WPACK;
        automatic int i = 0;
        int ilane, ibank, ij, iaddr;

        for (; i < vpu_scoreboard_pkg::MAX_VLEN/vpu_scoreboard_pkg::MIN_SEW; i = i + sub_banks*vpu_scoreboard_pkg::VRF_WBITS/sew) begin
            case (sew)
                8: begin
                    if(vpu_scoreboard_pkg::VRF_WBITS == 4) begin
                      for(int j=0;j<sub_banks/2;j++) begin
                        vec_el[i+j] = {vreg_if.lane[lane].bank[bank].subbank[j*2+1][addr],vreg_if.lane[lane].bank[bank].subbank[j*2][addr]} ;
                      end
                    end
                    if(vpu_scoreboard_pkg::VRF_WBITS == 8) begin
                        for(int j=0;j<sub_banks;j++) begin
                          vec_el[i+j] = vreg_if.lane[lane].bank[bank].subbank[j][addr] ;
                        end
                    end
                end
                16: begin
                      if(vpu_scoreboard_pkg::VRF_WBITS == 4) begin
                        vec_el[i] = {vreg_if.lane[lane].bank[bank].subbank[3][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[2][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[1][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[0][addr]};
                        vec_el[i+1] =  {vreg_if.lane[lane].bank[bank].subbank[7][addr],
                                        vreg_if.lane[lane].bank[bank].subbank[6][addr],
                                        vreg_if.lane[lane].bank[bank].subbank[5][addr],
                                        vreg_if.lane[lane].bank[bank].subbank[4][addr]};
                        vec_el[i+2] = {vreg_if.lane[lane].bank[bank].subbank[11][addr],
                                       vreg_if.lane[lane].bank[bank].subbank[10][addr],
                                       vreg_if.lane[lane].bank[bank].subbank[9][addr],
                                       vreg_if.lane[lane].bank[bank].subbank[8][addr]};
                        vec_el[i+3] =  {vreg_if.lane[lane].bank[bank].subbank[15][addr],
                                        vreg_if.lane[lane].bank[bank].subbank[14][addr],
                                        vreg_if.lane[lane].bank[bank].subbank[13][addr],
                                        vreg_if.lane[lane].bank[bank].subbank[12][addr]};
                      end
                      if(vpu_scoreboard_pkg::VRF_WBITS == 8) begin
                        vec_el[i] = {vreg_if.lane[lane].bank[bank].subbank[1][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[0][addr]};
                        vec_el[i+1] = {vreg_if.lane[lane].bank[bank].subbank[3][addr],
                                       vreg_if.lane[lane].bank[bank].subbank[2][addr]};
                        vec_el[i+2] = {vreg_if.lane[lane].bank[bank].subbank[5][addr],
                                       vreg_if.lane[lane].bank[bank].subbank[4][addr]};
                        vec_el[i+3] = {vreg_if.lane[lane].bank[bank].subbank[7][addr],
                                       vreg_if.lane[lane].bank[bank].subbank[6][addr]};
                      end
                    end
                32: begin
                      if(vpu_scoreboard_pkg::VRF_WBITS == 8) begin
                                    vec_el[i] = {vreg_if.lane[lane].bank[bank].subbank[3][addr],
                                                 vreg_if.lane[lane].bank[bank].subbank[2][addr],
                                                 vreg_if.lane[lane].bank[bank].subbank[1][addr],
                                                 vreg_if.lane[lane].bank[bank].subbank[0][addr]};
                                    vec_el[i+1] = {vreg_if.lane[lane].bank[bank].subbank[7][addr],
                                                   vreg_if.lane[lane].bank[bank].subbank[6][addr],
                                                   vreg_if.lane[lane].bank[bank].subbank[5][addr],
                                                   vreg_if.lane[lane].bank[bank].subbank[4][addr]};
                      end
                      if(vpu_scoreboard_pkg::VRF_WBITS == 4) begin
                        vec_el[i] = {vreg_if.lane[lane].bank[bank].subbank[7][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[6][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[5][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[4][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[3][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[2][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[1][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[0][addr]};
                        vec_el[i+1] = {vreg_if.lane[lane].bank[bank].subbank[15][addr],
                                       vreg_if.lane[lane].bank[bank].subbank[14][addr],
                                       vreg_if.lane[lane].bank[bank].subbank[13][addr],
                                       vreg_if.lane[lane].bank[bank].subbank[12][addr],
                                       vreg_if.lane[lane].bank[bank].subbank[11][addr],
                                       vreg_if.lane[lane].bank[bank].subbank[10][addr],
                                       vreg_if.lane[lane].bank[bank].subbank[9][addr],
                                       vreg_if.lane[lane].bank[bank].subbank[8][addr]};
                      end
                end
                64: begin
                      if(vpu_scoreboard_pkg::VRF_WBITS == 8) begin
                        vec_el[i] = {vreg_if.lane[lane].bank[bank].subbank[7][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[6][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[5][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[4][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[3][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[2][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[1][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[0][addr]};
                      end
                      if(vpu_scoreboard_pkg::VRF_WBITS == 4) begin
                        vec_el[i] = {vreg_if.lane[lane].bank[bank].subbank[15][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[14][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[13][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[12][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[11][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[10][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[9][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[8][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[7][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[6][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[5][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[4][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[3][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[2][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[1][addr],
                                     vreg_if.lane[lane].bank[bank].subbank[0][addr]};
                      end
                end
            endcase
            if (lane == vpu_scoreboard_pkg::N_LANES-1 && bank < vpu_scoreboard_pkg::N_BANKS-1) bank++;
            else if (lane == vpu_scoreboard_pkg::N_LANES-1) begin
                bank = 0;
                addr++;
            end
            if (lane < vpu_scoreboard_pkg::N_LANES-1) lane++;
            else lane = 0;
        end
      return vec_el;
    endfunction : retrieve_vpu_result

endmodule

// From Unit Level VPU verification environment
// Interface: vpu_vreg_if
// VPU VREG Interface
interface vpu_sim_vreg_if ();
    lane_vreg_t lane [vpu_scoreboard_pkg::N_LANES-1:0];
    logic [5:0] rename_vdest;
endinterface : vpu_sim_vreg_if

`endif