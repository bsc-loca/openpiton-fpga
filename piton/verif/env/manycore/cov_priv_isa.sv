
module cov_priv_isa(
    input                                   i_clk,
    input                                   i_rsn, 
    input                                   i_valid,
    input var cov_isa_defs::instruction_t   i_instruction,
    input var riscv::status_rv64_t          i_mstatus,
    input [63:0]                            i_mcause,
    input [63:0]                            i_scause,
    input [63:0]                            i_mtvec,
    input [63:0]                            i_stvec,
    input [63:0]                            i_mideleg,
    input [63:0]                            i_medeleg,
    input [11:0]                            i_csr_addr,
    input [2:0]                             i_csr_cmd,
    input [1:0]                             i_priv_lvl,
    input var drac_pkg::exception_t         i_pipeline_exc,
    input var drac_pkg::exception_t         i_csr_exc,
    input var drac_pkg::exception_t         i_int,
    input var drac_pkg::instr_type_t        i_instr_type
    );
import riscv::*;
import drac_pkg::*;
import cov_isa_defs::*;

logic exception_valid;
assign exception_valid = i_pipeline_exc.valid | i_csr_exc.valid;

    covergroup cg_exceptions_interrupts @(posedge i_clk);

        cp_datapath_exc: coverpoint i_pipeline_exc.valid iff (i_rsn);

        cp_csr_exc: coverpoint i_csr_exc.valid iff (i_rsn);

        cp_exceptions_m: coverpoint i_mcause iff (i_rsn && exception_valid) {
            //exceptions
            bins INSTRUCTION_ADDR_MISALIGNED = {64'd0};
            bins INSTRUCTION_ACC_FAULT       = {64'd1};
            bins ILLEGAL_INSTRUCTION         = {64'd2};
            bins BREAKPOINT                  = {64'd3};
            bins LOAD_ADDR_MISALIGNED        = {64'd4};
            bins LOAD_ACC_FAULT              = {64'd5};
            bins STORE_ADDR_MISALIGNED       = {64'd6};
            bins STORE_ACC_FAULT             = {64'd7};
            bins ECALL_U_MODE                = {64'd8};
            bins ECALL_S_MODE                = {64'd9};
            bins ECALL_M_MODE                = {64'd11}; //not possible in scause
            bins INSTRUCTION_PG_FAULT        = {64'd12};
            bins LOAD_PG_FAULT               = {64'd13};
            bins STORE_PG_FAULT              = {64'd15};
        }

        cp_interrupts_m: coverpoint i_mcause iff (i_rsn && exception_valid) {
            // interrupts
            bins SUPERVISOR_SOFT_INT         = {{1'b1,63'd1}};
            bins MACHINE_SOFT_INT            = {{1'b1,63'd3}};  //not possible in scause
            bins SUPERVISOR_TIMER_INT        = {{1'b1,63'd5}};
            bins MACHINE_TIMER_INT           = {{1'b1,63'd7}};  //not possible in scause      
            bins SUPERVISOR_EXT_INT          = {{1'b1,63'd9}};
            bins MACHINE_EXT_INT             = {{1'b1,63'd11}}; //not possible in scause
        }

        // coverpoint exc_cross_priv_lvl: cross cp_xcause_values, i_priv_lvl iff (i_rsn) {
        //     ignore_bins
        // }

        cp_exceptions_s: coverpoint i_scause iff (i_rsn && exception_valid) {
            //exceptions
            bins INSTRUCTION_ADDR_MISALIGNED = {64'd0};
            bins INSTRUCTION_ACC_FAULT       = {64'd1};
            bins ILLEGAL_INSTRUCTION         = {64'd2};
            bins BREAKPOINT                  = {64'd3};
            bins LOAD_ADDR_MISALIGNED        = {64'd4};
            bins LOAD_ACC_FAULT              = {64'd5};
            bins STORE_ADDR_MISALIGNED       = {64'd6};
            bins STORE_ACC_FAULT             = {64'd7};
            bins ECALL_U_MODE                = {64'd8};
            bins ECALL_S_MODE                = {64'd9};
            // bins ECALL_M_MODE                = {64'd11}; //not possible in scause
            bins INSTRUCTION_PG_FAULT        = {64'd12};
            bins LOAD_PG_FAULT               = {64'd13};
            bins STORE_PG_FAULT              = {64'd15};
        }

        cp_interrupts_s: coverpoint i_scause iff (i_rsn && exception_valid) {
            // interrupts
            bins SUPERVISOR_SOFT_INT         = {{1'b1,31'd1}};
            bins SUPERVISOR_TIMER_INT        = {{1'b1,31'd5}};
            bins SUPERVISOR_EXT_INT          = {{1'b1,31'd9}};
        }


        cp_priv_levels: coverpoint i_priv_lvl iff (i_rsn) {
            bins m_mode = {2'b11};
            bins s_mode = {2'b01};
        }

        cp_mtvec_mode: coverpoint i_mtvec[1:0] iff (i_rsn) {
            bins normal = {2'b00};
            bins vector = {2'b01};
        }

        cp_stvec_mode: coverpoint i_stvec[1:0] iff (i_rsn) {
            bins normal = {2'b00};
            bins vector = {2'b01};
        }

        cp_mie: coverpoint i_mstatus.mie iff (i_rsn) {
            bins bin_enable = {1'b1};
            bins bin_disable = {1'b0};
        }

        cp_sie: coverpoint i_mstatus.sie iff (i_rsn) {
            bins bin_enable = {1'b1};
            bins bin_disable = {1'b0};
        }

        cp_exc_priv_lvl_s: cross cp_priv_levels, cp_exceptions_s {
            ignore_bins invalid = binsof(cp_priv_levels) intersect {2'b11}; // traps are not delegated to a lower level when happen in a higher priv. level
        }

        cp_exc_priv_lvl_m: cross cp_priv_levels, cp_exceptions_m {
            
        }

        cp_int_priv_lvl_s: cross cp_priv_levels, cp_interrupts_s {
            ignore_bins invalid = binsof(cp_priv_levels) intersect {2'b11}; // traps are not delegated to a lower level when happen in a higher priv. level
        }

        cp_int_priv_lvl_m: cross cp_priv_levels, cp_interrupts_m {
            
        }

        cp_int_mode_m: cross cp_interrupts_m, cp_mtvec_mode {
            
        }

        cp_int_mode_s: cross cp_interrupts_s, cp_stvec_mode {
            
        }

        cp_s_int_mie_sie: cross cp_mie, cp_sie, cp_interrupts_s {
            
        }

        cp_m_int_mie_sie: cross cp_mie, cp_sie, cp_interrupts_m {
            
        }

    endgroup

    covergroup cg_core_xstatus @(posedge i_clk);

    cp_floating_insn: coverpoint i_instr_type iff (i_rsn) {
        // Floating-Point Load and Store Instructions
        bins FLD        = {drac_pkg::FLD};
        bins FLW        = {drac_pkg::FLW};
        bins FSD        = {drac_pkg::FSD};
        bins FSW        = {drac_pkg::FSW};
        // Floating-Point Computational Instructions
        bins FADD       = {drac_pkg::FADD};
        bins FSUB       = {drac_pkg::FSUB};
        bins FMUL       = {drac_pkg::FMUL};
        bins FDIV       = {drac_pkg::FDIV};
        bins FMIN_MAX   = {drac_pkg::FMIN_MAX};
        bins FSQRT      = {drac_pkg::FSQRT};
        bins FMADD      = {drac_pkg::FMADD};
        // bins FMSUB = {FMSUB};
        // bins FNMADD = {FNMADD};
        // bins FNMSUB = {FNMSUB};
        // Floating-Point Conversion and Move Instructions
        bins FCVT_F2I   = {drac_pkg::FCVT_F2I};
        bins FCVT_I2F   = {drac_pkg::FCVT_I2F};
        bins FCVT_F2F   = {drac_pkg::FCVT_F2F};
        bins FSGNJ      = {drac_pkg::FSGNJ};
        bins FMV_F2X    = {drac_pkg::FMV_F2X};
        bins FMV_X2F    = {drac_pkg::FMV_X2F};
        // Floating-Point Compare Instructions
        bins FCMP       = {drac_pkg::FCMP};
        // Floating-Point Classify Instruction
        bins FCLASS     = {drac_pkg::FCLASS};
    }

    cp_sfence_insn: coverpoint i_instr_type iff (i_rsn) {
        bins SFENCE_VMA  = {drac_pkg::SFENCE_VMA};
    }

    cp_wfi_insn: coverpoint i_instr_type iff (i_rsn) {
        bins WFI        = {drac_pkg::WFI};
    }

    cp_mstatus_fs: coverpoint i_mstatus.fs iff (i_rsn) {
        bins clean = {2'b00};
        bins dirty = {2'b11};
    }

    cp_cross_fs_insn: cross cp_mstatus_fs, cp_floating_insn;

    cp_mstatus_vs: coverpoint i_mstatus.vs iff (i_rsn) {
        bins clean = {2'b00};
        bins dirty = {2'b11};
    }

    cp_mstatus_tvm: coverpoint i_mstatus.tvm iff (i_rsn) {
        bins bin_disable = {1'b0};
        bins bin_enable = {1'b1};
    }

    cp_mstatus_sum: coverpoint i_mstatus.sum iff (i_rsn) {
        bins bin_disable = {1'b0};
        bins bin_enable = {1'b1};
    }

    cp_mstatus_mprv: coverpoint i_mstatus.mprv iff (i_rsn) {
        bins bin_disable = {1'b0};
        bins bin_enable = {1'b1};
    }

    cp_mstatus_tw: coverpoint i_mstatus.tw iff (i_rsn) {
        bins bin_disable = {1'b0};
        bins bin_enable = {1'b1};
    }

    cp_mstatus_mpp: coverpoint i_mstatus.mpp iff (i_rsn) {
        bins machine = {2'b11};
        bins supervisor = {2'b01};
    }

    cp_priv_lvl: coverpoint i_priv_lvl iff (i_rsn) {
        bins machine = {2'b11};
        bins supervisor = {2'b01};
    }


    cp_cross_tvm_sfence: cross cp_mstatus_tvm, cp_sfence_insn;
    cp_cross_tw_wfi: cross cp_mstatus_tw, cp_wfi_insn;

    cp_csr_satp: coverpoint i_csr_addr iff (i_csr_cmd) {
        bins satp_addr = {riscv::CSR_SATP};
    }

    cp_cross_tvm_satp: cross cp_mstatus_tvm, cp_csr_satp;

    cp_cross_mpp_mprv_sum: cross cp_mstatus_mprv,cp_mstatus_mpp, cp_mstatus_sum;

    endgroup

    //TODO: wirte coverpoints for delegation registers
    //TODO: write coverpoint for vector instructions, and their cross with mstatus.VS bit


    cg_core_xstatus u_cg_core_xstatus;
    cg_exceptions_interrupts u_cg_exceptions_interrupts;

    initial
    begin
        u_cg_core_xstatus   = new();
        u_cg_exceptions_interrupts = new();
    end



endmodule : cov_priv_isa