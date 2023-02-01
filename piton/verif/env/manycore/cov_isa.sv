
module cov_isa(
    input                                   i_clk,
    input                                   i_rsn,
    input                                   i_valid,
    input var cov_isa_defs::instruction_t   i_instruction
    );
import cov_isa_defs::*;

function is_f_instruction (int inst);
    bit [NB_OPCODE - 1 : 0] opcode;
    opcode = inst[NB_OPCODE- 1 : 0];
    return ((opcode == OP_FP) || (opcode == LOAD_FP) || (opcode == STORE_FP) || (opcode == FMADD) || (opcode == FMSUB) || (opcode == FNMADD) || (opcode == FNMSUB));
endfunction : is_f_instruction

function is_c_instruction (int inst);
    bit [NB_C_OPCODE - 1 : 0] opcode;
    opcode = inst[NB_C_OPCODE- 1 : 0];
    return ((opcode == C0) || (opcode == C1) || (opcode == C2));
endfunction : is_c_instruction

    //------------------------------------------------
    //          ALL TYPES OF INSTRUCTIONS
    //------------------------------------------------

    //R TYPE instructions
    covergroup cg_rv32i_r_type @(posedge i_clk);
        cp_r_opcode: coverpoint i_instruction.r_type.opcode iff ( i_rsn && i_valid ){
            bins opcode = {OP}; //opcode corresponds to r_type
        }

        cp_r_funct3: coverpoint i_instruction.r_type.funct3 iff ( i_rsn && i_valid ){ //funct3 all possible values
            bins ADD_SUB    = {F3_ADD_SUB};
            bins SLL        = {F3_SLL};
            bins SLT        = {F3_SLT};
            bins SLTU       = {F3_SLTU};
            bins XOR        = {F3_XOR};
            bins SRL_SRA    = {F3_SRL_SRA};
            bins OR         = {F3_OR};
            bins AND        = {F3_AND};
        }

        cp_r_funct7: coverpoint i_instruction.r_type.funct7 iff ( i_rsn && i_valid ){ //funct7 all possible values
            bins ARIT       = {F7_ARITH};
            bins LOGIC      = {F7_LOGIC};
        }

        cp_r_cross_all: cross cp_r_opcode, cp_r_funct3 iff ( i_rsn && i_valid ) ; //all possible combinations of R opcode and type of operation

        cp_r_cross_arith_logic: cross cp_r_opcode, cp_r_funct3, cp_r_funct7 iff ( i_rsn && i_valid ){ //for operations that can be arithmetic or logic
            // option.cross_auto_bin_max = 0; //we only care about two, defined below
            bins ADD_SUB = binsof( cp_r_funct3) intersect { (F3_ADD_SUB) } && binsof( cp_r_opcode ) && binsof( cp_r_funct7 );
            bins SRL_SRA = binsof( cp_r_funct3) intersect { (F3_SRL_SRA) } && binsof( cp_r_opcode ) && binsof( cp_r_funct7 );
            ignore_bins others = cp_r_cross_arith_logic with (!(cp_r_funct3 inside {F3_ADD_SUB, F3_SRL_SRA}));
        }

    endgroup: cg_rv32i_r_type

    cg_rv32i_r_type u_cg_rv32i_r_type;

    covergroup cg_rv64i_r_type @(posedge i_clk);
        cp_r_opcode: coverpoint i_instruction.r_type.opcode iff ( i_rsn && i_valid ){
            bins opcode = {OP_32}; //opcode corresponds to r_type
        }

        cp_r_funct3: coverpoint i_instruction.r_type.funct3 iff ( i_rsn && i_valid ){ //funct3 all possible values
            bins ADDW_SUBW  = {F3_ADD_SUB};
            bins SLLW       = {F3_SLL};
            bins SRLW_SRAW  = {F3_SRL_SRA};
        }

        cp_r_funct7: coverpoint i_instruction.r_type.funct7 iff ( i_rsn && i_valid ){ //funct7 all possible values
            bins ARIT       = {F7_ARITH};
            bins LOGIC      = {F7_LOGIC};
        }

        cp_r_cross_all: cross cp_r_opcode, cp_r_funct3 iff ( i_rsn && i_valid ); //all possible combinations of R opcode and type of operation

        cp_r_cross_arith_logic: cross cp_r_opcode, cp_r_funct3, cp_r_funct7 iff ( i_rsn && i_valid ){ //for operations that can be arithmetic or logic
            // option.cross_auto_bin_max = 0; //we only care about two, defined below
            bins ADDW_SUBW = binsof( cp_r_funct3) intersect { (F3_ADD_SUB) } && binsof( cp_r_opcode ) && binsof( cp_r_funct7 );
            bins SRLW_SRAW = binsof( cp_r_funct3) intersect { (F3_SRL_SRA) } && binsof( cp_r_opcode ) && binsof( cp_r_funct7 );
            ignore_bins others = cp_r_cross_arith_logic with  (!(cp_r_funct3 inside {F3_ADD_SUB, F3_SRL_SRA}));
            //ignore bins not_legal = binsof ( cp_r_funct3.SSL ) & binsof ( cp_r_funct3.SLT ) & binsof ( cp_r_funct3.SLTU ) & binsof ( cp_r_funct3.XOR ) & binsof ( cp_r_funct3.XOR ) & binsof ( cp_r_funct3.AND );
        }

    endgroup: cg_rv64i_r_type

    cg_rv64i_r_type u_cg_rv64i_r_type;

    //I TYPE instructions - immediate
    covergroup cg_rv32i_i_type @(posedge i_clk);
        cp_i_opcode: coverpoint i_instruction.i_type.opcode iff ( i_rsn && i_valid ){
            bins opcode = {OP_IMM}; //opcode corresponds to i_type
        }

        cp_i_funct3: coverpoint i_instruction.i_type.funct3 iff ( i_rsn && i_valid ){ //funct3 all possible values
            bins ADDI       = {F3_ADD_SUB}; //ADDI
            bins SLLI       = {F3_SLL};     //SLLI
            bins SLTI       = {F3_SLT};     //SLTI
            bins SLTIU      = {F3_SLTU};    //SLTIU
            bins XORI       = {F3_XOR};     //XORI
            bins SRLI_SRAI  = {F3_SRL_SRA}; //SRLI or SRAI
            bins ORI        = {F3_OR};      //ORI
            bins ANDI       = {F3_AND};      //ANDI
        }

        cp_i_funct7: coverpoint i_instruction.r_type.funct7 iff ( i_rsn && i_valid ){ //funct7 all possible values
            bins ARIT       = {F7_ARITH};   //SRAI
            bins LOGIC      = {F7_LOGIC};   //SRLI
        }

        cp_i_cross_all: cross cp_i_opcode, cp_i_funct3 iff ( i_rsn && i_valid ); //all possible combinations of I opcode and type of operation

        cp_i_cross_arith_logic: cross cp_i_opcode, cp_i_funct3, cp_i_funct7 iff ( i_rsn && i_valid ){ //for operations that can be arithmetic or logic
            // option.cross_auto_bin_max = 0; //we only care about one, defined below
            bins SRLI_SRAI   = binsof (cp_i_funct3) intersect {(F3_SRL_SRA)} && binsof( cp_i_opcode) && binsof(cp_i_funct7);
            ignore_bins others = cp_i_cross_arith_logic with (cp_i_funct3 != F3_SRL_SRA);
        }
    endgroup: cg_rv32i_i_type

    cg_rv32i_i_type u_cg_rv32i_i_type;

    covergroup cg_rv64i_i_type @(posedge i_clk);
        cp_i_opcode_32: coverpoint i_instruction.i_type.opcode iff ( i_rsn && i_valid ){
            bins opcode = {OP_IMM_32}; //opcode corresponds to i_type
        }

        cp_i_funct3_32: coverpoint i_instruction.i_type.funct3 iff ( i_rsn && i_valid ){ //funct3 all possible values
            bins ADDIW      = {F3_ADD_SUB}; //ADDIW
            bins SLLIW      = {F3_SLL};     //SLLIw
            bins SRLIW_SRAIW= {F3_SRL_SRA}; //SRLIW or SRAIW
        }

        cp_i_funct7_32: coverpoint i_instruction.r_type.funct7 iff ( i_rsn && i_valid ){ //funct7 all possible values
            bins ARIT       = {F7_ARITH};   //SRAI
            bins LOGIC      = {F7_LOGIC};   //SRLI
        }

        cp_i_cross_all_32: cross cp_i_opcode_32, cp_i_funct3_32 iff ( i_rsn && i_valid ) ; //all possible combinations of I opcode and type of operation

        cp_i_cross_arith_logic_32: cross cp_i_opcode_32, cp_i_funct3_32, cp_i_funct7_32 iff ( i_rsn && i_valid ){ //for operations that can be arithmetic or logic
            // option.cross_auto_bin_max = 0; //we only care about one, defined below
            bins SRLIW_SRAIW   = binsof (cp_i_funct3_32) intersect {(F3_SRL_SRA)} && binsof( cp_i_opcode_32) && binsof(cp_i_funct7_32);
            ignore_bins others = cp_i_cross_arith_logic_32 with (cp_i_funct3_32 != F3_SRL_SRA);
        }

        cp_i_opcode: coverpoint i_instruction.i_type.opcode iff ( i_rsn && i_valid ){
            bins opcide = {OP_IMM};
        }

        cp_i_funct3 : coverpoint i_instruction.i_type.funct3 iff ( i_rsn && i_valid ){
            bins SLLI       = {F3_SLL};
            bins SRLI_SRAI  = {F3_SRL_SRA};
        }

        cp_i_imm11_6 : coverpoint i_instruction.i_type.imm[11:6] iff ( i_rsn && i_valid ){
            bins ARIT       = {IMM11_6_ARITH};   //SRAI
            bins LOGIC      = {IMM11_6_LOGIC};   //SRLI
        }

        cp_cross_all_64 : cross cp_i_opcode, cp_i_funct3 iff ( i_rsn && i_valid ) ;

        cp_i_cross_arith_logic: cross cp_i_opcode, cp_i_funct3, cp_i_imm11_6 iff ( i_rsn && i_valid ){ //for operations that can be arithmetic or logic
            // option.cross_auto_bin_max = 0; //we only care about one, defined below
            bins SRLI_SRAI   = binsof (cp_i_funct3) intersect {(F3_SRL_SRA)} && binsof( cp_i_opcode) && binsof(cp_i_imm11_6);
            ignore_bins others = cp_i_cross_arith_logic with (cp_i_funct3 != F3_SRL_SRA);
        }
    endgroup: cg_rv64i_i_type

    cg_rv64i_i_type u_cg_rv64i_i_type;

    //I TYPE instructions - LOAD instructions
    covergroup cg_load_type @(posedge i_clk);
        cp_load_opcode: coverpoint i_instruction.i_type.opcode iff ( i_rsn && i_valid ){
            bins opcode = {LOAD};
        }

        cp_load_funct3: coverpoint i_instruction.i_type.funct3 iff ( i_rsn && i_valid ){
            bins LB     = {F3_LB };
            bins LH     = {F3_LH };
            bins LW     = {F3_LW };
            bins LBU    = {F3_LBU};
            bins LHU    = {F3_LHU};
            bins LWU    = {F3_LWU};
            bins LD     = {F3_LD};
        }

        cp_cross_load_all: cross cp_load_opcode, cp_load_funct3 iff ( i_rsn && i_valid );
    endgroup: cg_load_type

    cg_load_type u_cg_load_type;

    //I TYPE instructions - JALR instruction
    covergroup cg_jalr_type @(posedge i_clk);
        cp_jalr_opcode: coverpoint i_instruction.i_type.opcode iff ( i_rsn && i_valid ){
            bins opcode = {JALR};
        }
    endgroup: cg_jalr_type

    cg_jalr_type u_cg_jalr_type;

    //U TYPE instructions
    covergroup cg_u_type @(posedge i_clk);
        cp_u_opcode: coverpoint i_instruction.u_type.opcode iff ( i_rsn && i_valid ){
            bins opcode[] = {LUI, AUIPC};
        }
    endgroup: cg_u_type

    cg_u_type u_cg_u_type;

    //J TYPE instructions
    covergroup cg_j_type @(posedge i_clk);
        cp_j_opcode: coverpoint i_instruction.j_type.opcode iff ( i_rsn && i_valid ){
            bins opcode = {JAL};
        }
    endgroup: cg_j_type

    cg_j_type u_cg_j_type;

    //B TYPE instructions
    covergroup cg_b_type @(posedge i_clk);
        cp_b_opcode: coverpoint i_instruction.b_type.opcode iff ( i_rsn && i_valid ){
            bins opcode = {BRANCH};
        }

        cp_b_funct3: coverpoint i_instruction.b_type.funct3 iff ( i_rsn && i_valid ){
            bins BEQ    = {F3_BEQ };
            bins BNE    = {F3_BNE };
            bins BLT    = {F3_BLT };
            bins BGE    = {F3_BGE };
            bins BLTU   = {F3_BLTU};
            bins BGEU   = {F3_BGEU};
        }

        cp_cross_b_all: cross cp_b_opcode, cp_b_funct3 iff ( i_rsn && i_valid );
    endgroup

    cg_b_type u_cg_b_type;

    //S TYPE instructions
    covergroup cg_s_type @(posedge i_clk);
        cp_s_opcode: coverpoint i_instruction.s_type.opcode iff ( i_rsn && i_valid ){
            bins opcode = {STORE};
        }

        cp_s_funct3: coverpoint i_instruction.s_type.funct3 iff ( i_rsn && i_valid ){
            bins SB     = {F3_SB};
            bins SH     = {F3_SH};
            bins SW     = {F3_SW};
            bins SD     = {F3_SD};
        }

        cp_cross_s_all: cross cp_s_opcode, cp_s_funct3 iff ( i_rsn && i_valid );
    endgroup

    cg_s_type u_cg_s_type;

    //M Extension
    covergroup cg_m_extension @(posedge i_clk);
        cp_m_opcode_32: coverpoint i_instruction.r_type.opcode iff ( i_rsn && i_valid ){
            bins opcode = {OP};
        }

        cp_m_opcode_64: coverpoint i_instruction.r_type.opcode iff ( i_rsn && i_valid ){
            bins opcode = {OP_32};
        }

        cp_m_funct3: coverpoint i_instruction.r_type.funct3 iff ( i_rsn && i_valid ){
            bins MUL_MULW   = {F3_MUL_MULW};
            bins MULH       = {F3_MULH};
            bins MULHSU     = {F3_MULHSU};
            bins MULHU      = {F3_MULHU};
            bins DIV_DIVW   = {F3_DIV_DIVW};
            bins DIVU_DIVUW = {F3_DIVU_DIVUW};
            bins REM_REMW   = {F3_REM_REMW};
            bins REMU_REMUW = {F3_REMU_REMUW};
        }

        cp_m_funct7 : coverpoint i_instruction.r_type.funct7 iff ( i_rsn && i_valid ){
            bins F7_M       = {F7_M};
        }

        cp_rv32m : cross cp_m_opcode_32, cp_m_funct7, cp_m_funct3 iff ( i_rsn && i_valid );
        cp_rv64m : cross cp_m_opcode_64, cp_m_funct7, cp_m_funct3 iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins MULW   = binsof (cp_m_funct3) intersect {(F3_MUL_MULW)} && binsof( cp_m_opcode_64) && binsof(cp_m_funct7);
            bins DIVW   = binsof (cp_m_funct3) intersect {(F3_DIV_DIVW)} && binsof( cp_m_opcode_64) && binsof(cp_m_funct7);
            bins DUVUW  = binsof (cp_m_funct3) intersect {(F3_DIVU_DIVUW)} && binsof( cp_m_opcode_64) && binsof(cp_m_funct7);
            bins REMW   = binsof (cp_m_funct3) intersect {(F3_REM_REMW)} && binsof( cp_m_opcode_64) && binsof(cp_m_funct7);
            bins REMUW  = binsof (cp_m_funct3) intersect {(F3_REMU_REMUW)} && binsof( cp_m_opcode_64) && binsof(cp_m_funct7);

            ignore_bins others = cp_rv64m with (!(cp_m_funct3 inside {F3_MULH, F3_MULHSU, F3_MULHU}));
        }
    endgroup

    cg_m_extension u_cg_m_extension;

    //A Extension
    covergroup  cg_a_extension @(posedge i_clk);
        cp_a_opcode: coverpoint i_instruction.a_type.opcode iff ( i_rsn && i_valid ){
            bins opcode = {AMO};
        }

        cp_a_funct3_32 : coverpoint i_instruction.a_type.funct3 iff ( i_rsn && i_valid ){
            bins A32 = {F3_A32};
        }

        cp_a_funct3_64 : coverpoint i_instruction.a_type.funct3 iff ( i_rsn && i_valid ){
            bins A64 = {F3_A64};
        }

        cp_a_funct5 : coverpoint i_instruction.a_type.funct5 iff ( i_rsn && i_valid ){
            bins LR         = {F5_LR};
            bins SC         = {F5_SC};
            bins AMOSWAP    = {F5_AMOSWAP};
            bins AMOADD     = {F5_AMOADD};
            bins AMOXOR     = {F5_AMOXOR};
            bins AMOAND     = {F5_AMOAND};
            bins AMOOR      = {F5_AMOOR};
            bins AMOMIN     = {F5_AMOMIN};
            bins AMOMAX     = {F5_AMOMAX};
            bins AMOMINU    = {F5_AMOMINU};
            bins AMOMAXU    = {F5_AMOMAXU};
        }

        cp_a32: cross cp_a_opcode, cp_a_funct3_32, cp_a_funct5 iff ( i_rsn && i_valid );
        cp_a64: cross cp_a_opcode, cp_a_funct3_64, cp_a_funct5 iff ( i_rsn && i_valid );
    endgroup :  cg_a_extension

    cg_a_extension u_cg_a_extension;

    // F extension

    covergroup cg_fd_extension @(posedge i_clk);
        cp_fd_ld_opcode : coverpoint i_instruction.fd_ld_type.opcode iff ( i_rsn && i_valid ){
            bins  opcode = {LOAD_FP};
        }
        cp_fd_st_opcode : coverpoint i_instruction.fd_st_type.opcode iff ( i_rsn && i_valid ){
            bins  opcode = {STORE_FP};
        }
        cp_fd_arith_opcode : coverpoint i_instruction.fd_arith_type.opcode iff ( i_rsn && i_valid ){
            bins  opcode = {OP_FP};
        }
        cp_fd_fused_opcode : coverpoint i_instruction.fd_fused_type.opcode iff ( i_rsn && i_valid ){
            bins  opcode[] = {FNMADD, FNMSUB, FMADD, FMSUB};
        }
        cp_fd_funct5 : coverpoint i_instruction.fd_arith_type.funct5 iff ( i_rsn && i_valid && is_f_instruction(i_instruction.instruction) ){
            bins  FADD         = {F5_FADD    };
            bins  FSUB         = {F5_FSUB    };
            bins  FMUL         = {F5_FMUL    };
            bins  FDIV         = {F5_FDIV    };
            bins  FSQRT        = {F5_FSQRT   };
            bins  FSGNJ        = {F5_FSGNJ   };
            bins  FMINMAX      = {F5_FMINMAX };
            bins  FCVT_S_W     = {F5_FCVT_S_W};
            bins  FCVT_W_S     = {F5_FCVT_W_S};
            // bins  FCVT_F_I     = {F5_FCVT_F_I};
            // bins  FMV_X_W      = {F5_FMV_X_W };
            bins  FMV_W_X      = {F5_FMV_W_X };
            bins  FCMP         = {F5_FCMP    };
            bins  FCLASS       = {F5_FCLASS  };
            // bins  FCVT_I_D     = {F5_FCVT_I_D};
            // bins  FCVT_D_I     = {F5_FCVT_D_I};
            bins  FCVT_S_D     = {F5_FCVT_S_D};
            // bins  FCVT_D_S     = {F5_FCVT_D_S};
            // bins  FMV_X_D      = {F5_FMV_X_D };
            // bins  FMV_D_X      = {F5_FMV_D_X };
        }
        cp_fd_fmt : coverpoint i_instruction.fd_arith_type.fmt iff ( i_rsn && i_valid && is_f_instruction(i_instruction.instruction) ){
            bins  SINGLE  = {FMT_S};
            bins  DOUBLE  = {FMT_D};
        }
        cp_fd_rm : coverpoint i_instruction.fd_arith_type.rm iff ( i_rsn && i_valid && is_f_instruction(i_instruction.instruction) ){
            bins RM_RNE   =  {F_RM_RNE};
            bins RM_RTZ   =  {F_RM_RTZ};
            bins RM_RDN   =  {F_RM_RDN};
            bins RM_RUP   =  {F_RM_RUP};
            bins RM_RMM   =  {F_RM_RMM};
            bins RM_DYN   =  {F_RM_DYN};
            bins RM_MIN   =  {F_RM_MIN};
            bins RM_MAX   =  {F_RM_MAX};
            bins RM_EQ    =  {F_RM_EQ };
            bins RM_LT    =  {F_RM_LT };
            bins RM_LE    =  {F_RM_LE };
            bins RM_J     =  {F_RM_J  };
            bins RM_JN    =  {F_RM_JN };
            bins RM_JX    =  {F_RM_JX };
        }
        cp_fd_width : coverpoint i_instruction.fd_ld_type.width iff ( i_rsn && i_valid && is_f_instruction(i_instruction.instruction) ){
            bins  WORD   = {WIDTH_WORD};
            bins  DWORD  = {WIDTH_DWORD};
        }

        cp_fd_rs2_fcvt : coverpoint i_instruction.fd_arith_type.rs2 iff ( i_rsn && i_valid && is_f_instruction(i_instruction.instruction) ){
            bins  FCVT    = {FCVT};
            bins  FCVT_U  = {FCVT_U};
            bins  FCVTL   = {FCVTL};
            bins  FCVTL_U = {FCVTL_U};
        }

        cp_fd_ld_inst: cross cp_fd_ld_opcode, cp_fd_width iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins FLW = binsof (cp_fd_width) intersect {(WIDTH_WORD)} && binsof (cp_fd_ld_opcode);
            bins FLD = binsof (cp_fd_width) intersect {(WIDTH_DWORD)} && binsof (cp_fd_ld_opcode);
        }

        cp_fd_st_inst: cross cp_fd_st_opcode, cp_fd_width iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins FSW = binsof (cp_fd_width) intersect {(WIDTH_WORD)} && binsof (cp_fd_st_opcode);
            bins FSD = binsof (cp_fd_width) intersect {(WIDTH_DWORD)} && binsof (cp_fd_st_opcode);
        }

        cp_fd_arith_inst: cross cp_fd_arith_opcode, cp_fd_rm, cp_fd_fmt, cp_fd_funct5  iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins FADD_S   = binsof (cp_fd_funct5) intersect {(F5_FADD)}    && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_arith_opcode);
            bins FSUB_S   = binsof (cp_fd_funct5) intersect {(F5_FSUB)}    && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_arith_opcode);
            bins FMUL_S   = binsof (cp_fd_funct5) intersect {(F5_FMUL)}    && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_arith_opcode);
            bins FDIV_S   = binsof (cp_fd_funct5) intersect {(F5_FDIV)}    && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_arith_opcode);
            bins FSQRT_S  = binsof (cp_fd_funct5) intersect {(F5_FSQRT)}   && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_arith_opcode);
            bins FMIN_S   = binsof (cp_fd_funct5) intersect {(F5_FMINMAX)} && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_arith_opcode);
            bins FMAX_S   = binsof (cp_fd_funct5) intersect {(F5_FMINMAX)} && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_arith_opcode);
            bins FSGNJ_S  = binsof (cp_fd_funct5) intersect {(F5_FSGNJ)}   && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_rm) intersect {(F_RM_J)}   && binsof (cp_fd_arith_opcode);
            bins FSGNJN_S = binsof (cp_fd_funct5) intersect {(F5_FSGNJ)}   && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_rm) intersect {(F_RM_JN)}  && binsof (cp_fd_arith_opcode);
            bins FSGNJX_S = binsof (cp_fd_funct5) intersect {(F5_FSGNJ)}   && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_rm) intersect {(F_RM_JX)}  && binsof (cp_fd_arith_opcode);
            bins FEQ_S    = binsof (cp_fd_funct5) intersect {(F5_FCMP)}    && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_rm) intersect {(F_RM_EQ)}  && binsof (cp_fd_arith_opcode);
            bins FLT_S    = binsof (cp_fd_funct5) intersect {(F5_FCMP)}    && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_rm) intersect {(F_RM_LT)}  && binsof (cp_fd_arith_opcode);
            bins FLE_S    = binsof (cp_fd_funct5) intersect {(F5_FCMP)}    && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_rm) intersect {(F_RM_LE)}  && binsof (cp_fd_arith_opcode);
            bins FCLASS_S = binsof (cp_fd_funct5) intersect {(F5_FCLASS)}  && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_rm) intersect {(F_RM_LT)} && binsof (cp_fd_arith_opcode);
            bins FMV_X_W  = binsof (cp_fd_funct5) intersect {(F5_FCLASS)}  && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_rm) intersect {(F_RM_LE)} && binsof (cp_fd_arith_opcode);
            bins FMV_W_X  = binsof (cp_fd_funct5) intersect {(F5_FMV_W_X)} && binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_arith_opcode);


            bins FADD_D   = binsof (cp_fd_funct5) intersect {(F5_FADD)}    && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_arith_opcode);
            bins FSUB_D   = binsof (cp_fd_funct5) intersect {(F5_FSUB)}    && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_arith_opcode);
            bins FMUL_D   = binsof (cp_fd_funct5) intersect {(F5_FMUL)}    && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_arith_opcode);
            bins FDIV_D   = binsof (cp_fd_funct5) intersect {(F5_FDIV)}    && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_arith_opcode);
            bins FSQRT_D  = binsof (cp_fd_funct5) intersect {(F5_FSQRT)}   && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_arith_opcode);
            bins FMIN_D   = binsof (cp_fd_funct5) intersect {(F5_FMINMAX)} && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_arith_opcode);
            bins FMAX_D   = binsof (cp_fd_funct5) intersect {(F5_FMINMAX)} && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_arith_opcode);
            bins FSGNJ_D  = binsof (cp_fd_funct5) intersect {(F5_FSGNJ)}   && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_rm) intersect {(F_RM_J)}   && binsof (cp_fd_arith_opcode);
            bins FSGNJN_D = binsof (cp_fd_funct5) intersect {(F5_FSGNJ)}   && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_rm) intersect {(F_RM_JN)}  && binsof (cp_fd_arith_opcode);
            bins FSGNJX_D = binsof (cp_fd_funct5) intersect {(F5_FSGNJ)}   && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_rm) intersect {(F_RM_JX)}  && binsof (cp_fd_arith_opcode);
            bins FEQ_D    = binsof (cp_fd_funct5) intersect {(F5_FCMP)}    && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_rm) intersect {(F_RM_EQ)}  && binsof (cp_fd_arith_opcode);
            bins FLT_D    = binsof (cp_fd_funct5) intersect {(F5_FCMP)}    && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_rm) intersect {(F_RM_LT)}  && binsof (cp_fd_arith_opcode);
            bins FLE_D    = binsof (cp_fd_funct5) intersect {(F5_FCMP)}    && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_rm) intersect {(F_RM_LE)}  && binsof (cp_fd_arith_opcode);
            bins FCLASS_D = binsof (cp_fd_funct5) intersect {(F5_FCLASS)}  && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_rm) intersect {(F_RM_LT)} && binsof (cp_fd_arith_opcode);
            bins FMV_X_D  = binsof (cp_fd_funct5) intersect {(F5_FCLASS)}  && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_rm) intersect {(F_RM_LE)} && binsof (cp_fd_arith_opcode);
            bins FMV_D_X  = binsof (cp_fd_funct5) intersect {(F5_FMV_W_X)} && binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_arith_opcode);

            ignore_bins others_funct = cp_fd_arith_inst with (cp_fd_funct5 inside {F5_FCVT_W_S, F5_FCVT_S_W, F5_FCVT_S_D});
            ignore_bins others_rm = cp_fd_arith_inst with (!(cp_fd_rm inside {F_RM_J, F_RM_JN, F_RM_JX, F_RM_EQ, F_RM_LT, F_RM_LE}));
            ignore_bins others_fsgnj = cp_fd_arith_inst with (cp_fd_funct5 == F5_FSGNJ && !(cp_fd_rm inside {F_RM_J, F_RM_JN, F_RM_JX}));
            ignore_bins others_fcmp = cp_fd_arith_inst with (cp_fd_funct5 == F5_FCMP && !(cp_fd_rm inside {F_RM_EQ, F_RM_LT, F_RM_LE}));
            ignore_bins others_fclass = cp_fd_arith_inst with (cp_fd_funct5 == F5_FCLASS && !(cp_fd_rm inside {F_RM_LT, F_RM_LE}));
        }

        cp_fd_fcvt_inst: cross cp_fd_arith_opcode, cp_fd_fmt, cp_fd_funct5, cp_fd_rs2_fcvt iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins FCVT_W_S   = binsof (cp_fd_funct5) intersect {(F5_FCVT_W_S)}  && binsof (cp_fd_fmt) intersect {(FMT_S)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVT)}    && binsof (cp_fd_arith_opcode);
            bins FCVT_WU_S  = binsof (cp_fd_funct5) intersect {(F5_FCVT_W_S)}  && binsof (cp_fd_fmt) intersect {(FMT_S)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVT_U)}  && binsof (cp_fd_arith_opcode);
            bins FCVT_S_W   = binsof (cp_fd_funct5) intersect {(F5_FCVT_S_W)}  && binsof (cp_fd_fmt) intersect {(FMT_S)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVT)}    && binsof (cp_fd_arith_opcode);
            bins FCVT_S_WU  = binsof (cp_fd_funct5) intersect {(F5_FCVT_S_W)}  && binsof (cp_fd_fmt) intersect {(FMT_S)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVT_U)}  && binsof (cp_fd_arith_opcode);

            bins FCVT_L_S   = binsof (cp_fd_funct5) intersect {(F5_FCVT_W_S)}  && binsof (cp_fd_fmt) intersect {(FMT_S)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVTL)}   && binsof (cp_fd_arith_opcode);
            bins FCVT_LU_S  = binsof (cp_fd_funct5) intersect {(F5_FCVT_W_S)}  && binsof (cp_fd_fmt) intersect {(FMT_S)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVTL_U)} && binsof (cp_fd_arith_opcode);
            bins FCVT_S_L   = binsof (cp_fd_funct5) intersect {(F5_FCVT_S_W)}  && binsof (cp_fd_fmt) intersect {(FMT_S)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVTL)}   && binsof (cp_fd_arith_opcode);
            bins FCVT_S_LU  = binsof (cp_fd_funct5) intersect {(F5_FCVT_S_W)}  && binsof (cp_fd_fmt) intersect {(FMT_S)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVTL_U)} && binsof (cp_fd_arith_opcode);

            bins FCVT_S_D   = binsof (cp_fd_funct5) intersect {(F5_FCVT_S_D)}  && binsof (cp_fd_fmt) intersect {(FMT_S)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVT_U)}  && binsof (cp_fd_arith_opcode);
            bins FCVT_D_S   = binsof (cp_fd_funct5) intersect {(F5_FCVT_S_D)}  && binsof (cp_fd_fmt) intersect {(FMT_D)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVT)}    && binsof (cp_fd_arith_opcode);

            bins FCVT_W_D   = binsof (cp_fd_funct5) intersect {(F5_FCVT_W_S)}  && binsof (cp_fd_fmt) intersect {(FMT_D)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVT)}    && binsof (cp_fd_arith_opcode);
            bins FCVT_WU_D  = binsof (cp_fd_funct5) intersect {(F5_FCVT_W_S)}  && binsof (cp_fd_fmt) intersect {(FMT_D)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVT_U)}  && binsof (cp_fd_arith_opcode);
            bins FCVT_D_W   = binsof (cp_fd_funct5) intersect {(F5_FCVT_S_W)}  && binsof (cp_fd_fmt) intersect {(FMT_D)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVT)}    && binsof (cp_fd_arith_opcode);
            bins FCVT_D_WU  = binsof (cp_fd_funct5) intersect {(F5_FCVT_S_W)}  && binsof (cp_fd_fmt) intersect {(FMT_D)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVT_U)}  && binsof (cp_fd_arith_opcode);

            bins FCVT_L_D   = binsof (cp_fd_funct5) intersect {(F5_FCVT_W_S)}  && binsof (cp_fd_fmt) intersect {(FMT_D)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVTL)}   && binsof (cp_fd_arith_opcode);
            bins FCVT_LU_D  = binsof (cp_fd_funct5) intersect {(F5_FCVT_W_S)}  && binsof (cp_fd_fmt) intersect {(FMT_D)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVTL_U)} && binsof (cp_fd_arith_opcode);
            bins FCVT_D_L   = binsof (cp_fd_funct5) intersect {(F5_FCVT_S_W)}  && binsof (cp_fd_fmt) intersect {(FMT_D)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVTL)}   && binsof (cp_fd_arith_opcode);
            bins FCVT_D_LU  = binsof (cp_fd_funct5) intersect {(F5_FCVT_S_W)}  && binsof (cp_fd_fmt) intersect {(FMT_D)}  && binsof (cp_fd_rs2_fcvt) intersect {(FCVTL_U)} && binsof (cp_fd_arith_opcode);

            ignore_bins others_funct = cp_fd_fcvt_inst with (!(cp_fd_funct5 inside {F5_FCVT_W_S, F5_FCVT_S_W, F5_FCVT_S_D}));
            ignore_bins others1 = cp_fd_fcvt_inst with (cp_fd_funct5 == F5_FCVT_S_D && (cp_fd_rs2_fcvt == FCVTL_U || cp_fd_rs2_fcvt == FCVTL));
            ignore_bins others2 = cp_fd_fcvt_inst with (cp_fd_fmt == FMT_D && cp_fd_rs2_fcvt == FCVT_U);
            ignore_bins others3 = cp_fd_fcvt_inst with (cp_fd_fmt == FMT_S && cp_fd_rs2_fcvt == FCVT);
        }

        cp_fd_fused_inst: cross cp_fd_fused_opcode, cp_fd_fmt iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins FMADD_S   = binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_fused_opcode) intersect {(FMADD)};
            bins FNMADD_S  = binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_fused_opcode) intersect {(FNMADD)};
            bins FMSUB_S   = binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_fused_opcode) intersect {(FMSUB)};
            bins FNMSUB_S  = binsof (cp_fd_fmt) intersect {(FMT_S)} && binsof (cp_fd_fused_opcode) intersect {(FNMSUB)};

            bins FMADD_D   = binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_fused_opcode) intersect {(FMADD)};
            bins FNMADD_D  = binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_fused_opcode) intersect {(FNMADD)};
            bins FMSUB_D   = binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_fused_opcode) intersect {(FMSUB)};
            bins FNMSUB_D  = binsof (cp_fd_fmt) intersect {(FMT_D)} && binsof (cp_fd_fused_opcode) intersect {(FNMSUB)};
        }

        // cp_fused_cross_mstatus_fs: cross i_mstatus.fs, cp_fd_fused_inst iff ( i_rsn && i_valid ){
        //     ignore_bins non_implemented_states = cp_fused_cross_mstatus_fs with (i_mstatus.fs == Clean || i_mstatus.fs == Initial);
        // }
        // instruction cannot be committed when fs bit is 0, so coverpoint not possible
        // all this can be done through a single assertion that assert (!(mstatus.fs==Dirty && is_f_instruction(i_instruction.instruction) && commit_valid))

        // if we want to cover for that evry floating instruction came into pipe when mstatus.fs bit is clean we will need instruction from that
    endgroup : cg_fd_extension

    cg_fd_extension u_cg_fd_extension;

    // C extension

    covergroup cg_c_extension @(posedge i_clk iff is_c_instruction(i_instruction.instruction));

        cp_opcode : coverpoint i_instruction.instruction[1:0] iff ( i_rsn && i_valid ){
            bins C0 = {C0};
            bins C1 = {C1};
            bins C2 = {C2};
        }

        cp_funct2 : coverpoint i_instruction.ca_type.funct2 iff ( i_rsn && i_valid ){
            bins C_SUB_SUBW = {C_SUB_SUBW_FUNCT2};
            bins C_XOR_ADDW = {C_XOR_ADDW_FUNCT2};
            bins C_OR       = {C_OR_FUNCT2};
            bins C_AND      = {C_AND_FUNCT2};
        }

        cp_funct3 : coverpoint i_instruction.ci_type.funct3 iff ( i_rsn && i_valid ){
        }

        cp_funct4 : coverpoint i_instruction.cr_type.funct4 iff ( i_rsn && i_valid ){
            bins C_MV_JR       = {C_MV_JR_FUNCT4};
            bins C_ADD_EB_JALR = {C_ADD_EB_JALR_FUNCT4};
        }

        cp_rs1 : coverpoint i_instruction.cr_type.rs1 iff ( i_rsn && i_valid ){
            bins ZERO       = {5'b00000};
            bins NON_ZERO   = {[5'b00001 : 5'b11111]};
        }

        cp_rs2 : coverpoint i_instruction.cr_type.rs2 iff ( i_rsn && i_valid ){
            bins ZERO       = {5'b00000};
            bins NON_ZERO   = {[5'b00001 : 5'b11111]};
        }

        cp_rd : coverpoint i_instruction.ci_type.rs1 iff ( i_rsn && i_valid ){
            bins ZERO       = {5'b00000};
            bins SP         = {5'b00010};
            bins OTHER      = {5'b00001, [5'b00011 : 5'b11111]};
        }

        cp_funct6 : coverpoint i_instruction.ca_type.funct6 iff ( i_rsn && i_valid ){
            bins ARITH_F6 = {C_ARITH1_FUNCT6};  // also covers C_AND_FUNCT6, C_XOR_FUNCT6, C_OR_FUNCT6
            bins ARITH_W_F6 = {C_ARITH2_FUNCT6};  // also covers C_ADDW_FUNCT6
        }

        cp_cb_imm2: coverpoint i_instruction.cb_type.offset2 iff ( i_rsn && i_valid ){
            // for SRLI AND SRAI instructions, these 3 bits of offset are divided into shamt and funct2
            bins C_OFFSET_SRLI = {3'b000};
            bins C_OFFSET_SRAI = {3'b001};
            bins C_IMM_ANDI    = {3'b110, 3'b010};
        }

        cp_cr_type : cross cp_funct4, cp_opcode, cp_rs1, cp_rs2 iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins C_JR     = binsof (cp_funct4) intersect {(C_MV_JR_FUNCT4)}       && binsof (cp_rs1) intersect {[5'd1 : 5'd31]} && binsof (cp_rs2) intersect {5'd0}           && binsof (cp_opcode) intersect {C2};
            bins C_MV     = binsof (cp_funct4) intersect {(C_MV_JR_FUNCT4)}       && binsof (cp_rs1) intersect {[5'd1 : 5'd31]} && binsof (cp_rs2) intersect {[5'd1 : 5'd31]} && binsof (cp_opcode) intersect {C2};
            bins C_EBREAK = binsof (cp_funct4) intersect {(C_ADD_EB_JALR_FUNCT4)} && binsof (cp_rs1) intersect {5'd0}           && binsof (cp_rs2) intersect {5'd0}           && binsof (cp_opcode) intersect {C2};
            bins C_JALR   = binsof (cp_funct4) intersect {(C_ADD_EB_JALR_FUNCT4)} && binsof (cp_rs1) intersect {[5'd1 : 5'd31]} && binsof (cp_rs2) intersect {5'd0}           && binsof (cp_opcode) intersect {C2};
            bins C_ADD    = binsof (cp_funct4) intersect {(C_ADD_EB_JALR_FUNCT4)} && binsof (cp_rs1) intersect {[5'd1 : 5'd31]} && binsof (cp_rs2) intersect {[5'd1 : 5'd31]} && binsof (cp_opcode) intersect {C2};

            ignore_bins others_op = cp_cr_type with (cp_opcode != C2 || (cp_rs1 == 0 && cp_funct4 == C_MV_JR_FUNCT4));
            ignore_bins others2 = cp_cr_type with (cp_rs1 == 0 && cp_rs2 != 0);
        }

        cp_ci_type : cross cp_funct3, cp_opcode, cp_rd  iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins C_LWSP     = binsof (cp_funct3) intersect {(C_LWSP_FUNCT3)}     && binsof (cp_opcode) intersect {C2};
            bins C_LDSP     = binsof (cp_funct3) intersect {(C_LDSP_FUNCT3)}     && binsof (cp_opcode) intersect {C2};
            bins C_FLDSP    = binsof (cp_funct3) intersect {(C_FLDSP_FUNCT3)}    && binsof (cp_opcode) intersect {C2};
            bins C_ADDI     = binsof (cp_funct3) intersect {(C_ADDI_FUNCT3)}     && binsof (cp_opcode) intersect {C1};
            bins C_ADDIW    = binsof (cp_funct3) intersect {(C_ADDIW_FUNCT3)}    && binsof (cp_opcode) intersect {C1};
            bins C_LI       = binsof (cp_funct3) intersect {(C_LI_FUNCT3)}       && binsof (cp_opcode) intersect {C1};
            bins C_ADDI16SP = binsof (cp_funct3) intersect {(C_ADDI16SP_LUI_FUNCT3)} && binsof (cp_opcode) intersect {C1} && binsof (cp_rd) intersect {5'd2};
            bins C_LUI      = binsof (cp_funct3) intersect {(C_ADDI16SP_LUI_FUNCT3)} && binsof (cp_opcode) intersect {C1} && binsof (cp_rd) intersect {5'd1, [5'd3:5'd31]};
            bins C_SLLI     = binsof (cp_funct3) intersect {(C_SLLI_FUNCT3)}     && binsof (cp_opcode) intersect {C1} && binsof (cp_rd) intersect {5'd1, [5'd3:5'd31]};

            ignore_bins others_op = cp_ci_type with (cp_opcode == C0);
            ignore_bins others2 = cp_ci_type with (cp_opcode == C2 && !(cp_funct3 inside {C_LWSP_FUNCT3, C_LDSP_FUNCT3, C_FLDSP_FUNCT3}));
            ignore_bins others3 = cp_ci_type with (cp_opcode == C1 && !(cp_funct3 inside {C_ADDI_FUNCT3, C_ADDIW_FUNCT3, C_LI_FUNCT3, C_ADDI16SP_LUI_FUNCT3, C_SLLI_FUNCT3}));
            ignore_bins others4 = cp_ci_type with (cp_opcode == C1 && cp_funct3 == C_ADDI16SP_LUI_FUNCT3 && cp_rd == 0);
            ignore_bins others5 = cp_ci_type with (cp_opcode == C1 && cp_funct3 == C_SLLI_FUNCT3 && cp_rd == 2);
        }

        cp_css_type : cross cp_funct3, cp_opcode  iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins C_SWSP     = binsof (cp_funct3) intersect {(C_SWSP_FUNCT3)}     && binsof (cp_opcode) intersect {C2};
            bins C_SDSP     = binsof (cp_funct3) intersect {(C_SDSP_FUNCT3)}     && binsof (cp_opcode) intersect {C2};
            bins C_FSDSP    = binsof (cp_funct3) intersect {(C_FSDSP_FUNCT3)}    && binsof (cp_opcode) intersect {C2};

            ignore_bins others_op = cp_css_type with (cp_opcode != C2 || !(cp_funct3 inside {C_SWSP_FUNCT3, C_SDSP_FUNCT3, C_FSDSP_FUNCT3}));
        }

        cp_ciw_type : cross cp_funct3, cp_opcode  iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins C_ADDI4SPN     = binsof (cp_funct3) intersect {(C_ADDI4SPN_FUNCT3)} && binsof (cp_opcode) intersect {C0};

            ignore_bins others_op = cp_ciw_type with (cp_opcode != C0 || cp_funct3 != C_ADDI4SPN_FUNCT3);
        }

        cp_cl_type : cross cp_funct3, cp_opcode  iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins C_LW     = binsof (cp_funct3) intersect {(C_LW_FUNCT3)} && binsof (cp_opcode) intersect {C0};
            bins C_LD     = binsof (cp_funct3) intersect {(C_LD_FUNCT3)} && binsof (cp_opcode) intersect {C0};
            bins C_FLD    = binsof (cp_funct3) intersect {(C_FLD_FUNCT3)} && binsof (cp_opcode) intersect {C0};

            ignore_bins others_op = cp_cl_type with (cp_opcode != C0 || !(cp_funct3 inside {C_LW_FUNCT3, C_LD_FUNCT3, C_FLD_FUNCT3}));
        }

        cp_cs_type : cross cp_funct3, cp_opcode  iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins C_SW     = binsof (cp_funct3) intersect {(C_SW_FUNCT3)} && binsof (cp_opcode) intersect {C0};
            bins C_SD     = binsof (cp_funct3) intersect {(C_SD_FUNCT3)} && binsof (cp_opcode) intersect {C0};
            bins C_FSD    = binsof (cp_funct3) intersect {(C_FSD_FUNCT3)} && binsof (cp_opcode) intersect {C0};

            ignore_bins others_op = cp_cs_type with (cp_opcode != C0 || !(cp_funct3 inside {C_SW_FUNCT3, C_SD_FUNCT3, C_FSD_FUNCT3}));
        }

        cp_ca_type : cross cp_funct6, cp_funct2, cp_opcode  iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins C_AND    = binsof (cp_funct6) intersect {(C_ARITH1_FUNCT6)} && binsof (cp_funct2) intersect {(C_AND_FUNCT2)}      && binsof (cp_opcode) intersect {C1};
            bins C_OR     = binsof (cp_funct6) intersect {(C_ARITH1_FUNCT6)} && binsof (cp_funct2) intersect {(C_OR_FUNCT2)}       && binsof (cp_opcode) intersect {C1};
            bins C_XOR    = binsof (cp_funct6) intersect {(C_ARITH1_FUNCT6)} && binsof (cp_funct2) intersect {(C_XOR_ADDW_FUNCT2)} && binsof (cp_opcode) intersect {C1};
            bins C_SUB    = binsof (cp_funct6) intersect {(C_ARITH1_FUNCT6)} && binsof (cp_funct2) intersect {(C_SUB_SUBW_FUNCT2)} && binsof (cp_opcode) intersect {C1};
            bins C_ADDW   = binsof (cp_funct6) intersect {(C_ARITH2_FUNCT6)} && binsof (cp_funct2) intersect {(C_XOR_ADDW_FUNCT2)} && binsof (cp_opcode) intersect {C1};
            bins C_SUBW   = binsof (cp_funct6) intersect {(C_ARITH2_FUNCT6)} && binsof (cp_funct2) intersect {(C_SUB_SUBW_FUNCT2)} && binsof (cp_opcode) intersect {C1};

            ignore_bins others_op = cp_ca_type with (cp_opcode != C1);
            ignore_bins others_funct = cp_ca_type with (cp_funct2 inside {C_OR_FUNCT2, C_AND_FUNCT2} && cp_funct6 == C_ARITH2_FUNCT6);
        }

        cp_cb_type : cross cp_funct3, cp_opcode, cp_cb_imm2  iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins C_BEQZ    = binsof (cp_funct3) intersect {(C_BEQZ_FUNCT3)} && binsof (cp_opcode) intersect {C1};
            bins C_BNEZ    = binsof (cp_funct3) intersect {(C_BNEZ_FUNCT3)} && binsof (cp_opcode) intersect {C1};
            bins C_SRLI64  = binsof (cp_funct3) intersect {(C_COMMON_Q1_FUNCT3)} && binsof (cp_opcode) intersect {C1} && binsof (cp_cb_imm2) intersect {3'b000};
            bins C_SRAI64  = binsof (cp_funct3) intersect {(C_COMMON_Q1_FUNCT3)} && binsof (cp_opcode) intersect {C1} && binsof (cp_cb_imm2) intersect {3'b001};
            bins C_ANDI    = binsof (cp_funct3) intersect {(C_COMMON_Q1_FUNCT3)} && binsof (cp_opcode) intersect {C1} && binsof (cp_cb_imm2) intersect {3'b010,3'b110};

            ignore_bins others_op = cp_cb_type with (!(cp_funct3 inside {C_BEQZ_FUNCT3, C_BNEZ_FUNCT3, C_COMMON_Q1_FUNCT3}) || cp_opcode != C1);
        }

        cp_cj_type : cross cp_funct3, cp_opcode  iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins C_J      = binsof (cp_funct3) intersect {(C_J_FUNCT3)} && binsof (cp_opcode) intersect {C1};

            ignore_bins others = cp_cj_type with (cp_funct3 != C_J_FUNCT3 || cp_opcode != C1);
            // bins C_JAL    = binsof (cp_funct3) intersect {(C_JAL_)} && binsof (cp_opcode) intersect {C1}; // TODO: only RV32, need to confirm
        }

        // cp_cr_type : cross cp_funct4, cp_opcode, cp_rs1, cp_rs2 iff ( i_rsn && i_valid ){
        //     bins C_JR     = binsof (cp_funct4) intersect {(C_JR_FUNCT4)}     && binsof (cp_rs1.NON_ZERO) && binsof (cp_rs2.ZERO)     && binsof (cp_opcode) intersect {C2};
        //     bins C_MV     = binsof (cp_funct4) intersect {(C_MV_FUNCT4)}     && binsof (cp_rs1.NON_ZERO) && binsof (cp_rs2.NON_ZERO) && binsof (cp_opcode) intersect {C2};
        //     bins C_EBREAK = binsof (cp_funct4) intersect {(C_EBREAK_FUNCT4)} && binsof (cp_rs1.ZERO)     && binsof (cp_rs2.ZERO)     && binsof (cp_opcode) intersect {C2};
        //     bins C_JALR   = binsof (cp_funct4) intersect {(C_JALR_FUNCT4)}   && binsof (cp_rs1.NON_ZERO) && binsof (cp_rs2.ZERO)     && binsof (cp_opcode) intersect {C2};
        //     bins C_ADD    = binsof (cp_funct4) intersect {(C_ADD_FUNCT4)}    && binsof (cp_rs1.NON_ZERO) && binsof (cp_rs2.NON_ZERO) && binsof (cp_opcode) intersect {C2};
        // }


    endgroup : cg_c_extension

    cg_c_extension u_cg_c_extension;



    //MISC_MEM
    covergroup cg_misc_mem @(posedge i_clk);
        cp_opcode : coverpoint i_instruction.i_type.opcode iff ( i_rsn && i_valid ){
            bins opcode = {MISC_MEM};
        }

        cp_funct3 : coverpoint i_instruction.i_type.funct3 iff ( i_rsn && i_valid ){
            bins FENCE  = {F3_FENCE};
            bins FENCEI = {F3_FENCEI};
        }

        cp_misc_mem : cross cp_opcode, cp_funct3 iff ( i_rsn && i_valid ) ;
    endgroup : cg_misc_mem

    cg_misc_mem u_cg_misc_mem;

    //SYSTEM/CSR

    covergroup cg_csr @(posedge i_clk);
        cp_opcode : coverpoint i_instruction.csr_type.opcode iff ( i_rsn && i_valid ){
            bins opcode = {SYSTEM};
        }

        cp_funct3 : coverpoint i_instruction.csr_type.funct3 iff ( i_rsn && i_valid ){
            bins ECALL_EBREAK   = {F3_ECALL_EBREAK};
            bins CSRRW          = {F3_CSRRW };
            bins CSRRS          = {F3_CSRRS };
            bins CSRRC          = {F3_CSRRC };
            bins CSRRWI         = {F3_CSRRWI};
            bins CSRRSI         = {F3_CSRRSI};
            bins CSRRCI         = {F3_CSRRCI};
        }

        cp_csr : coverpoint i_instruction.csr_type.csr iff ( i_rsn && i_valid ){
            bins ECALL  = {ECALL};
            bins EBREAK = {EBREAK};
        }

        cp_system_csr : cross cp_opcode, cp_funct3 iff ( i_rsn && i_valid );
        cp_ecall_ebreak : cross cp_opcode, cp_funct3, cp_csr iff ( i_rsn && i_valid ){
            // option.cross_auto_bin_max = 0;
            bins ecall   = binsof (cp_funct3) intersect {(F3_ECALL_EBREAK)} && binsof( cp_opcode) && binsof(cp_csr) intersect {(ECALL)};
            bins ebreak   = binsof (cp_funct3) intersect {(F3_ECALL_EBREAK)} && binsof( cp_opcode) && binsof(cp_csr) intersect {(EBREAK)};

            ignore_bins others1 = !binsof (cp_funct3) intersect {(F3_ECALL_EBREAK)};
        }

    endgroup : cg_csr

    cg_csr u_cg_csr;
    //------------------------------------------------
    //          ALL REGISTERS AS SOURCE AND OPERAND
    //------------------------------------------------

    covergroup cg_registers @(posedge i_clk);
        cp_source1: coverpoint i_instruction.r_type.rs1 iff ( i_rsn && i_valid ){
            bins all[] = {[0:31]};
        }

        cp_source2: coverpoint i_instruction.r_type.rs2 iff ( i_rsn && i_valid ){
            bins all[] = {[0:31]};
        }

        cp_dest: coverpoint i_instruction.r_type.rd iff ( i_rsn && i_valid ){
            bins all[] = {[0:31]};
        }
    endgroup: cg_registers

    cg_registers u_cg_registers;

    initial
    begin
        u_cg_rv32i_r_type   = new();
        u_cg_rv64i_r_type   = new();
        u_cg_rv32i_i_type   = new();
        u_cg_rv64i_i_type   = new();
        u_cg_load_type  = new();
        u_cg_jalr_type  = new();
        u_cg_u_type = new();
        u_cg_j_type = new();
        u_cg_b_type = new();
        u_cg_s_type = new();
        u_cg_m_extension    = new();
        u_cg_a_extension    = new();
        u_cg_misc_mem   = new();
        u_cg_csr    = new();
        u_cg_registers  = new();
        u_cg_fd_extension = new();
        u_cg_c_extension = new();
    end



endmodule : cov_isa
