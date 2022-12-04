/* -----------------------------------------------------------
* Project Name   : MEEP
* Organization   : Barcelona Supercomputing Center
* Test           : core_mon.sv
* Author(s)      : Saad Khalid
* Email(s)       : saad.khalid@bsc.es
* ------------------------------------------------------------
* Description:
*   In this core_mon, there is a monitor and reference model for
* PMU. Based on the core state, reference PMU registers update
* and compared with PMU CSRs from RTL. If there is a mismatch,
* it reports PC, Instr and actual/expected values of mismatched
* register.
* ------------------------------------------------------------
*/
`ifdef PMU_MONITOR

import drac_pkg::*;
import riscv_pkg::*;

module pmu_mon(
  input        clk,
  input        rst,
  input        commit,
  input [39:0] pc,
  input [31:0] instr,
  input [63:0] xreg_dest,
  input        xreg_wr_valid,
  input [63:0] freg_dest,
  input        freg_wr_valid,
  input  [6:0] csr_cmd,
  input [11:0] csr_addr,
  input [63:0] csr_wdata,
  input [63:0] csr_rdata,
  input        excep,
  input        interrupt,
  input [63:0] cause,
  input [63:0] tval,
  input [63:0] mcycle,
  input [63:0] minstret,
  input [63:0] mhpmevent3,
  input [63:0] mhpmevent4,
  input [63:0] mhpmevent5,
  input [63:0] mhpmevent6,
  input [63:0] mhpmevent7,
  input [63:0] mhpmevent8,
  input [63:0] mhpmevent9,
  input [63:0] mhpmevent10,
  input [63:0] mhpmevent11,
  input [63:0] mhpmevent12,
  input [63:0] mhpmevent13,
  input [63:0] mhpmevent14,
  input [63:0] mhpmevent15,
  input [63:0] mhpmevent16,
  input [63:0] mhpmevent17,
  input [63:0] mhpmevent18,
  input [63:0] mhpmevent19,
  input [63:0] mhpmevent20,
  input [63:0] mhpmevent21,
  input [63:0] mhpmevent22,
  input [63:0] mhpmevent23,
  input [63:0] mhpmevent24,
  input [63:0] mhpmevent25,
  input [63:0] mhpmevent26,
  input [63:0] mhpmevent27,
  input [63:0] mhpmevent28,
  input [63:0] mhpmevent29,
  input [63:0] mhpmevent30,
  input [63:0] mhpmevent31,
  input [63:0] mhpmcounter3,
  input [63:0] mhpmcounter4,
  input [63:0] mhpmcounter5,
  input [63:0] mhpmcounter6,
  input [63:0] mhpmcounter7,
  input [63:0] mhpmcounter8,
  input [63:0] mhpmcounter9,
  input [63:0] mhpmcounter10,
  input [63:0] mhpmcounter11,
  input [63:0] mhpmcounter12,
  input [63:0] mhpmcounter13,
  input [63:0] mhpmcounter14,
  input [63:0] mhpmcounter15,
  input [63:0] mhpmcounter16,
  input [63:0] mhpmcounter17,
  input [63:0] mhpmcounter18,
  input [63:0] mhpmcounter19,
  input [63:0] mhpmcounter20,
  input [63:0] mhpmcounter21,
  input [63:0] mhpmcounter22,
  input [63:0] mhpmcounter23,
  input [63:0] mhpmcounter24,
  input [63:0] mhpmcounter25,
  input [63:0] mhpmcounter26,
  input [63:0] mhpmcounter27,
  input [63:0] mhpmcounter28,
  input [63:0] mhpmcounter29,
  input [63:0] mhpmcounter30,
  input [63:0] mhpmcounter31,
  input [31:0] count_inhibit,
  input [63:0] vl,
  input [63:0] vtype,
  input        vec_arith,
  input riscv::priv_lvl_t         priv_lvl,
  input ariane_pkg::exception_t   csr_excep,
  input drac_pkg::pipeline_ctrl_t control_intf,
  input drac_pkg::to_PMU_t        pmu_flags
);

typedef enum {HPME_NEW_INST                  = 1,
              HPME_IS_BRANCH                 = 2,
              HPME_IS_BRANCH_HIT             = 3,
              HPME_IS_BRANCH_FALSE_POSITIVE  = 4,
              HPME_IS_BRANCH_TAKEN           = 5,
              HPME_IS_SC_WORD_OP             = 6,
              HPME_IS_SC_DWORD_OP            = 7,
              HPME_IS_VEC_BYTE_OP            = 8,
              HPME_IS_VEC_HWORD_OP           = 9,
              HPME_IS_VEC_WORD_OP            = 10,
              HPME_IS_VEC_DWORD_OP           = 11,
              HPME_IS_VEC_BYTE_INST          = 12,
              HPME_IS_VEC_HWORD_INST         = 13,
              HPME_IS_VEC_WORD_INST          = 14,
              HPME_IS_VEC_DWORD_INST         = 15} supported_hpmevents;

// Macros
`define IS_WRITE_ALL_CSR_BITS(bits)  ((csr_cmd == CSR_CMD_WRITE) || ((csr_cmd == CSR_CMD_SET || csr_cmd == CSR_CMD_CLEAR) && csr_wdata == ((1 << bits)-1)))

`define SET_CHECK_IF_NOT_INHIBITED(inhibit_bit, check_reg) \
  if (!count_inhibit[inhibit_bit]) begin                   \
    check_reg <= 1;                                        \
  end

`define UPDATE_REF_CSR(ref_csr)                                       \
  if (csr_cmd == CSR_CMD_WRITE)      ref_csr <= csr_wdata;            \
  else if (csr_cmd == CSR_CMD_SET)   ref_csr <= ref_csr | csr_wdata;  \
  else if (csr_cmd == CSR_CMD_CLEAR) ref_csr <= ref_csr & ~csr_wdata;

`define CHECK_REG(csr)                                                                                      \
  if (check_``csr && csr != ref_``csr) begin                                                                \
    $display("Lagarto Core Monitor: PC[%16h], INSTR[%8h] mcountinhibit[%8h]", pc, instr, count_inhibit);    \
    $error("Lagarto Core Monitor: %s Mismatch - actual [%16h], expected [%16h]", `"csr`", csr, ref_``csr);  \
  end

`define PRINT_REG(csr)                                                                            \
  if (check_``csr) begin                                                                          \
    $display("Lagarto Core Monitor: %s [%16h], ref_%s [%16h]", `"csr`", csr, `"csr`", ref_``csr); \
  end

bit [63:0] ref_minstret = 0;
bit [63:0] ref_mcycle = 1;
longint unsigned ref_hpm_counter[29];

logic check_mcycle;
logic check_minstret;
logic check_hpmc[29];

localparam VSEW_8  = 3'b000;
localparam VSEW_16 = 3'b001;
localparam VSEW_32 = 3'b010;
localparam VSEW_64 = 3'b011;

`define MHPMCOUNTER_CHECK(event_num)                                                                          \
  if (mhpmcounter``event_num != ref_hpm_counter[event_num-3] && check_hpmc[event_num-3]) begin                \
    $display("Lagarto Core Monitor: PC[%16h], INSTR[%8h] mcountinhibit[%8h]", pc, instr, count_inhibit);      \
    $error("Lagarto Core Monitor: %s Mismatch - actual [%16h], expected [%16h]", `"mhpmcounter``event_num`",  \
                                                                                      mhpmcounter``event_num, \
                                                                               ref_hpm_counter[event_num-3]); \
  end

// common functions
function void check_hpmcounter();
  `MHPMCOUNTER_CHECK(3)
  `MHPMCOUNTER_CHECK(4)
  `MHPMCOUNTER_CHECK(5)
  `MHPMCOUNTER_CHECK(6)
  `MHPMCOUNTER_CHECK(7)
  `MHPMCOUNTER_CHECK(8)
  `MHPMCOUNTER_CHECK(9)
  `MHPMCOUNTER_CHECK(10)
  `MHPMCOUNTER_CHECK(11)
  `MHPMCOUNTER_CHECK(12)
  `MHPMCOUNTER_CHECK(13)
  `MHPMCOUNTER_CHECK(14)
  `MHPMCOUNTER_CHECK(15)
  `MHPMCOUNTER_CHECK(16)
  `MHPMCOUNTER_CHECK(17)
  `MHPMCOUNTER_CHECK(18)
  `MHPMCOUNTER_CHECK(19)
  `MHPMCOUNTER_CHECK(20)
  `MHPMCOUNTER_CHECK(21)
  `MHPMCOUNTER_CHECK(22)
  `MHPMCOUNTER_CHECK(23)
  `MHPMCOUNTER_CHECK(24)
  `MHPMCOUNTER_CHECK(25)
  `MHPMCOUNTER_CHECK(26)
  `MHPMCOUNTER_CHECK(27)
endfunction

function void check_hpmcounter_vec();
  `MHPMCOUNTER_CHECK(28)
  `MHPMCOUNTER_CHECK(29)
  `MHPMCOUNTER_CHECK(30)
  `MHPMCOUNTER_CHECK(31)
endfunction

function bit check_event(int event_name, int hpm_counter);
  case(hpm_counter)
    3  : return event_name == mhpmevent3;
    4  : return event_name == mhpmevent4;
    5  : return event_name == mhpmevent5;
    6  : return event_name == mhpmevent6;
    7  : return event_name == mhpmevent7;
    8  : return event_name == mhpmevent8;
    9  : return event_name == mhpmevent9;
    10 : return event_name == mhpmevent10;
    11 : return event_name == mhpmevent11;
    12 : return event_name == mhpmevent12;
    13 : return event_name == mhpmevent13;
    14 : return event_name == mhpmevent14;
    15 : return event_name == mhpmevent15;
    16 : return event_name == mhpmevent16;
    17 : return event_name == mhpmevent17;
    18 : return event_name == mhpmevent18;
    19 : return event_name == mhpmevent19;
    20 : return event_name == mhpmevent20;
    21 : return event_name == mhpmevent21;
    22 : return event_name == mhpmevent22;
    23 : return event_name == mhpmevent23;
    24 : return event_name == mhpmevent24;
    25 : return event_name == mhpmevent25;
    26 : return event_name == mhpmevent26;
    27 : return event_name == mhpmevent27;
    28 : return event_name == mhpmevent28;
    29 : return event_name == mhpmevent29;
    30 : return event_name == mhpmevent30;
    31 : return event_name == mhpmevent31;
    default : return 0;
  endcase

endfunction

logic instruction_commit;
logic commit_or_except;
logic is_exception;
logic is_vector_mem;
logic is_vector_arith;
logic is_vector_arith_ops;
logic is_vector;
logic is_scalar_arith_word;
logic is_scalar_arith_double;
logic is_float;
logic is_float_word;
logic is_float_double;
logic ecall_or_ebreak;
logic instr_retire_or_ecall_ebreak;

assign is_exception       = excep || csr_excep.valid;
assign commit_or_except   = commit && !control_intf.stall_exe;
assign instruction_commit = commit_or_except && !is_exception;

assign ecall_or_ebreak = csr_excep.cause == riscv::BREAKPOINT     ||
                         csr_excep.cause == riscv::ENV_CALL_UMODE ||
                         csr_excep.cause == riscv::ENV_CALL_SMODE ||
                         csr_excep.cause == riscv::ENV_CALL_MMODE;

assign instr_retire_or_ecall_ebreak = instruction_commit || (commit_or_except && ecall_or_ebreak);

assign is_float = instr[6:0] inside {riscv_pkg::OP_FP,
                                     riscv_pkg::OP_FMADD,
                                     riscv_pkg::OP_FMSUB,
                                     riscv_pkg::OP_FNMSUB,
                                     riscv_pkg::OP_FNMADD};
assign is_float_word   = is_float && instr[26:25] == riscv_pkg::FMT_S;
assign is_float_double = is_float && instr[26:25] == riscv_pkg::FMT_D;

assign is_scalar_arith_word   = is_float_word || (instr[6:0] inside {riscv_pkg::OP_ALU_I_W, riscv_pkg::OP_ALU_W});
assign is_scalar_arith_double = is_float_double || (instr[6:0] inside {riscv_pkg::OP_ALU_I, riscv_pkg::OP_ALU});

assign is_vector_mem   = (instr[6:0] inside {riscv_pkg::OP_LOAD_FP, riscv_pkg::OP_STORE_FP, riscv_pkg::OP_ATOMICS}) &&
                         (instr[14:12] inside {riscv_pkg::VECTOR_BYTE, riscv_pkg::VECTOR_HALFWORD, riscv_pkg::VECTOR_WORD, riscv_pkg::VECTOR_ELEMENT});
assign is_vector_arith = instr[6:0] == riscv_pkg::OP_VECTOR;
assign is_vector_arith_ops   = is_vector_arith && instr[14:12] != riscv_pkg::F3_OPCFG;
assign is_vector_except_vset = is_vector_mem || is_vector_arith_ops;

// PMU Scoreboard
always @(posedge clk iff rst) begin
  if (commit_or_except) begin
    `ifdef PMU_SCOREBOARD_DEBUG
      $display("Lagarto Core Monitor: PC[%16h] INSTR[%8h]", pc, instr);
    `endif

    `CHECK_REG(minstret)
    `CHECK_REG(mcycle)
    check_hpmcounter();
    check_hpmcounter_vec();
  end
end

always @(posedge clk or negedge rst) begin
  if (!rst) begin
    check_mcycle              <= 0;
    check_minstret            <= 0;
    for (int counter_offset=0; counter_offset<=28; counter_offset++) begin
      check_hpmc[counter_offset] <= 0;
    end
  end else begin
    `SET_CHECK_IF_NOT_INHIBITED(0, check_mcycle)

    `SET_CHECK_IF_NOT_INHIBITED(2, check_minstret)

    for (int counter_offset=0; counter_offset<=28; counter_offset++) begin
      `SET_CHECK_IF_NOT_INHIBITED(counter_offset + 3, check_hpmc[counter_offset])
    end
  end
end

// PMU Reference Model
always @(posedge clk iff rst) begin

  // increments on every clk cycle, or update directly on CSR write
  if (csr_addr == riscv::CSR_MCYCLE && priv_lvl == riscv::PRIV_LVL_M && csr_cmd inside {CSR_CMD_WRITE, CSR_CMD_SET, CSR_CMD_CLEAR}) begin
    `UPDATE_REF_CSR(ref_mcycle)
  end else if (check_mcycle && !count_inhibit[0]) begin
    ref_mcycle <= ref_mcycle + 1;
  end

  // increments on every valid instruction commit, or update directly on CSR write
  if (csr_addr == riscv::CSR_MINSTRET && priv_lvl == riscv::PRIV_LVL_M && csr_cmd inside {CSR_CMD_WRITE, CSR_CMD_SET, CSR_CMD_CLEAR}) begin
    `UPDATE_REF_CSR(ref_minstret)
  end else if (check_minstret && !count_inhibit[2] && instruction_commit) begin
    ref_minstret <= ref_minstret + 1;
  end

  for (int hpmcounter=0; hpmcounter<=28; hpmcounter++) begin
    if (csr_addr == (riscv::CSR_MHPM_COUNTER_3 + hpmcounter) && priv_lvl == riscv::PRIV_LVL_M && csr_cmd inside {CSR_CMD_WRITE, CSR_CMD_SET, CSR_CMD_CLEAR}) begin
      `UPDATE_REF_CSR(ref_hpm_counter[hpmcounter])
    end else begin
      for (int event_name=HPME_NEW_INST; event_name<=HPME_IS_VEC_DWORD_INST; event_name++) begin
        if (check_event(event_name, hpmcounter+3)) begin
          case (event_name)
            // hpmcounter28-hpmcounter31 are reserved for HPME_IS_VEC_*_OP
            HPME_NEW_INST                 : begin
              if (check_hpmc[hpmcounter] && (hpmcounter + 3 < 28) && !count_inhibit[hpmcounter+3] && instr_retire_or_ecall_ebreak) begin
                ref_hpm_counter[hpmcounter] <= ref_hpm_counter[hpmcounter] + 1;
              end
            end
            HPME_IS_BRANCH                : begin
              if (check_hpmc[hpmcounter] && (hpmcounter + 3 < 28) && !count_inhibit[hpmcounter+3] && pmu_flags.is_branch) begin
                ref_hpm_counter[hpmcounter] <= ref_hpm_counter[hpmcounter] + 1;
              end
            end
            HPME_IS_BRANCH_HIT            : begin
              if (check_hpmc[hpmcounter] && (hpmcounter + 3 < 28) && !count_inhibit[hpmcounter+3] && pmu_flags.is_branch_hit) begin
                ref_hpm_counter[hpmcounter] <= ref_hpm_counter[hpmcounter] + 1;
              end
            end
            HPME_IS_BRANCH_FALSE_POSITIVE : begin
              if (check_hpmc[hpmcounter] && (hpmcounter + 3 < 28) && !count_inhibit[hpmcounter+3] && pmu_flags.is_branch_false_positive) begin
                ref_hpm_counter[hpmcounter] <= ref_hpm_counter[hpmcounter] + 1;
              end
            end
            HPME_IS_BRANCH_TAKEN          : begin
              if (check_hpmc[hpmcounter] && (hpmcounter + 3 < 28) && !count_inhibit[hpmcounter+3] && pmu_flags.branch_taken) begin
                ref_hpm_counter[hpmcounter] <= ref_hpm_counter[hpmcounter] + 1;
              end
            end
            HPME_IS_SC_WORD_OP            : begin
              if (check_hpmc[hpmcounter] && (hpmcounter + 3 < 28) && !count_inhibit[hpmcounter+3] && instruction_commit && is_scalar_arith_word) begin
                ref_hpm_counter[hpmcounter] <= ref_hpm_counter[hpmcounter] + 1;
              end
            end
            HPME_IS_SC_DWORD_OP           : begin
              if (check_hpmc[hpmcounter] && (hpmcounter + 3 < 28) && !count_inhibit[hpmcounter+3] && instruction_commit && is_scalar_arith_double) begin
                ref_hpm_counter[hpmcounter] <= ref_hpm_counter[hpmcounter] + 1;
              end
            end
            HPME_IS_VEC_BYTE_INST         : begin
              if (check_hpmc[hpmcounter] && (hpmcounter + 3 < 28) && !count_inhibit[hpmcounter+3] && vec_arith && vtype[4:2] == VSEW_8 && is_vector_except_vset) begin
                ref_hpm_counter[hpmcounter] <= ref_hpm_counter[hpmcounter] + 1;
              end
            end
            HPME_IS_VEC_HWORD_INST        : begin
              if (check_hpmc[hpmcounter] && (hpmcounter + 3 < 28) && !count_inhibit[hpmcounter+3] && vec_arith && vtype[4:2] == VSEW_16 && is_vector_except_vset) begin
                ref_hpm_counter[hpmcounter] <= ref_hpm_counter[hpmcounter] + 1;
              end
            end
            HPME_IS_VEC_WORD_INST         : begin
              if (check_hpmc[hpmcounter] && (hpmcounter + 3 < 28) && !count_inhibit[hpmcounter+3] && vec_arith && vtype[4:2] == VSEW_32 && is_vector_except_vset) begin
                ref_hpm_counter[hpmcounter] <= ref_hpm_counter[hpmcounter] + 1;
              end
            end
            HPME_IS_VEC_DWORD_INST        : begin
              if (check_hpmc[hpmcounter] && (hpmcounter + 3 < 28) && !count_inhibit[hpmcounter+3] && vec_arith && vtype[4:2] == VSEW_64 && is_vector_except_vset) begin
                ref_hpm_counter[hpmcounter] <= ref_hpm_counter[hpmcounter] + 1;
              end
            end
            // HPME_IS_VEC_*_OP can only be set in hpmcounter28-hpmcounter31
            HPME_IS_VEC_BYTE_OP           : begin
              if (check_hpmc[hpmcounter] && (hpmcounter + 3 == 28) && !count_inhibit[hpmcounter+3] && vec_arith && vtype[4:2] == VSEW_8 && is_vector_arith_ops) begin
                ref_hpm_counter[hpmcounter] <= ref_hpm_counter[hpmcounter] + vl;
              end
            end
            HPME_IS_VEC_HWORD_OP          : begin
              if (check_hpmc[hpmcounter] && (hpmcounter + 3 == 29) && !count_inhibit[hpmcounter+3] && vec_arith && vtype[4:2] == VSEW_16 && is_vector_arith_ops) begin
                ref_hpm_counter[hpmcounter] <= ref_hpm_counter[hpmcounter] + vl;
              end
            end
            HPME_IS_VEC_WORD_OP           : begin
              if (check_hpmc[hpmcounter] && (hpmcounter + 3 == 30) && !count_inhibit[hpmcounter+3] && vec_arith && vtype[4:2] == VSEW_32 && is_vector_arith_ops) begin
                ref_hpm_counter[hpmcounter] <= ref_hpm_counter[hpmcounter] + vl;
              end
            end
            HPME_IS_VEC_DWORD_OP          : begin
              if (check_hpmc[hpmcounter] && (hpmcounter + 3 == 31) && !count_inhibit[hpmcounter+3] && vec_arith && vtype[4:2] == VSEW_64 && is_vector_arith_ops) begin
                ref_hpm_counter[hpmcounter] <= ref_hpm_counter[hpmcounter] + vl;
              end
            end
          endcase
        end
      end
    end
  end
end

// Functional Cover Groups
covergroup csr@(posedge clk iff (rst));
valid_exceptions:
  coverpoint csr_excep.cause iff(csr_excep.valid) {
    bins exception_causes[] = {
      INSTR_ADDR_MISALIGNED,
      INSTR_ACCESS_FAULT,
      ILLEGAL_INSTR,
      BREAKPOINT,
      LD_ADDR_MISALIGNED,
      LD_ACCESS_FAULT,
      ST_AMO_ADDR_MISALIGNED,
      ST_AMO_ACCESS_FAULT,
      USER_ECALL,
      SUPERVISOR_ECALL,
      INSTR_PAGE_FAULT,
      LD_PAGE_FAULT,
      ST_AMO_PAGE_FAULT
    };
  }
implemented_csrs:
  coverpoint csr_addr {
    bins hpm_counter_csrs[] = {
      riscv::CSR_TIME,
      riscv::CSR_MINSTRET,
      riscv::CSR_INSTRET,
      riscv::CSR_MCYCLE,
      riscv::CSR_CYCLE,
      riscv::CSR_MCOUNTINHIBIT,
      riscv::CSR_HPM_COUNTER_3,
      riscv::CSR_HPM_COUNTER_4,
      riscv::CSR_HPM_COUNTER_5,
      riscv::CSR_HPM_COUNTER_6,
      riscv::CSR_HPM_COUNTER_7,
      riscv::CSR_HPM_COUNTER_8,
      riscv::CSR_HPM_COUNTER_9,
      riscv::CSR_HPM_COUNTER_10,
      riscv::CSR_HPM_COUNTER_11,
      riscv::CSR_HPM_COUNTER_12,
      riscv::CSR_HPM_COUNTER_13,
      riscv::CSR_HPM_COUNTER_14,
      riscv::CSR_HPM_COUNTER_15,
      riscv::CSR_HPM_COUNTER_16,
      riscv::CSR_HPM_COUNTER_17,
      riscv::CSR_HPM_COUNTER_18,
      riscv::CSR_HPM_COUNTER_19,
      riscv::CSR_HPM_COUNTER_20,
      riscv::CSR_HPM_COUNTER_21,
      riscv::CSR_HPM_COUNTER_22,
      riscv::CSR_HPM_COUNTER_23,
      riscv::CSR_HPM_COUNTER_24,
      riscv::CSR_HPM_COUNTER_25,
      riscv::CSR_HPM_COUNTER_26,
      riscv::CSR_HPM_COUNTER_27,
      riscv::CSR_HPM_COUNTER_28,
      riscv::CSR_HPM_COUNTER_29,
      riscv::CSR_HPM_COUNTER_30,
      riscv::CSR_HPM_COUNTER_31,
      riscv::CSR_MHPM_COUNTER_3,
      riscv::CSR_MHPM_COUNTER_4,
      riscv::CSR_MHPM_COUNTER_5,
      riscv::CSR_MHPM_COUNTER_6,
      riscv::CSR_MHPM_COUNTER_7,
      riscv::CSR_MHPM_COUNTER_8,
      riscv::CSR_MHPM_COUNTER_9,
      riscv::CSR_MHPM_COUNTER_10,
      riscv::CSR_MHPM_COUNTER_11,
      riscv::CSR_MHPM_COUNTER_12,
      riscv::CSR_MHPM_COUNTER_13,
      riscv::CSR_MHPM_COUNTER_14,
      riscv::CSR_MHPM_COUNTER_15,
      riscv::CSR_MHPM_COUNTER_16,
      riscv::CSR_MHPM_COUNTER_17,
      riscv::CSR_MHPM_COUNTER_18,
      riscv::CSR_MHPM_COUNTER_19,
      riscv::CSR_MHPM_COUNTER_20,
      riscv::CSR_MHPM_COUNTER_21,
      riscv::CSR_MHPM_COUNTER_22,
      riscv::CSR_MHPM_COUNTER_23,
      riscv::CSR_MHPM_COUNTER_24,
      riscv::CSR_MHPM_COUNTER_25,
      riscv::CSR_MHPM_COUNTER_26,
      riscv::CSR_MHPM_COUNTER_27,
      riscv::CSR_MHPM_COUNTER_28,
      riscv::CSR_MHPM_COUNTER_29,
      riscv::CSR_MHPM_COUNTER_30,
      riscv::CSR_MHPM_COUNTER_31
    };
    bins hpm_event_csrs[] = {
      riscv::CSR_MHPM_EVENT_3,
      riscv::CSR_MHPM_EVENT_4,
      riscv::CSR_MHPM_EVENT_5,
      riscv::CSR_MHPM_EVENT_6,
      riscv::CSR_MHPM_EVENT_7,
      riscv::CSR_MHPM_EVENT_8,
      riscv::CSR_MHPM_EVENT_9,
      riscv::CSR_MHPM_EVENT_10,
      riscv::CSR_MHPM_EVENT_11,
      riscv::CSR_MHPM_EVENT_12,
      riscv::CSR_MHPM_EVENT_13,
      riscv::CSR_MHPM_EVENT_14,
      riscv::CSR_MHPM_EVENT_15,
      riscv::CSR_MHPM_EVENT_16,
      riscv::CSR_MHPM_EVENT_17,
      riscv::CSR_MHPM_EVENT_18,
      riscv::CSR_MHPM_EVENT_19,
      riscv::CSR_MHPM_EVENT_20,
      riscv::CSR_MHPM_EVENT_21,
      riscv::CSR_MHPM_EVENT_22,
      riscv::CSR_MHPM_EVENT_23,
      riscv::CSR_MHPM_EVENT_24,
      riscv::CSR_MHPM_EVENT_25,
      riscv::CSR_MHPM_EVENT_26,
      riscv::CSR_MHPM_EVENT_27,
      riscv::CSR_MHPM_EVENT_28,
      riscv::CSR_MHPM_EVENT_29,
      riscv::CSR_MHPM_EVENT_30,
      riscv::CSR_MHPM_EVENT_31
    };
  }
csr_accesses:
  coverpoint csr_cmd {
    bins access[] = {
      CSR_CMD_WRITE,
      CSR_CMD_SET,
      CSR_CMD_CLEAR,
      CSR_CMD_READ
    };
  }
all_csr_accesses:
  cross implemented_csrs, csr_accesses;
hpm_events:
  coverpoint csr_wdata iff(csr_cmd == CSR_CMD_WRITE && csr_addr >= riscv::CSR_MHPM_EVENT_3 && csr_addr <= riscv::CSR_MHPM_EVENT_31) {
    bins events[] = {
      HPME_NEW_INST,
      HPME_IS_BRANCH,
      HPME_IS_BRANCH_HIT,
      HPME_IS_BRANCH_FALSE_POSITIVE,
      HPME_IS_BRANCH_TAKEN,
      HPME_IS_SC_WORD_OP,
      HPME_IS_SC_DWORD_OP,
      HPME_IS_VEC_BYTE_OP,
      HPME_IS_VEC_HWORD_OP,
      HPME_IS_VEC_WORD_OP,
      HPME_IS_VEC_DWORD_OP,
      HPME_IS_VEC_BYTE_INST,
      HPME_IS_VEC_HWORD_INST,
      HPME_IS_VEC_WORD_INST,
      HPME_IS_VEC_DWORD_INST
    };
  }
endgroup

csr csr_coverage = new();

endmodule
`endif
