package cov_isa_defs;

    parameter       NB_WORD         = 32;
    parameter       NB_BYTE         = 8;
    parameter       N_REGISTERS     = 32;
    parameter       NB_OPCODE       = 7;
    parameter       NB_OPERAND      = 5;
    
    parameter       NB_FUNCT7       = 7;
    parameter       NB_FUNCT5       = 5;
    parameter       NB_FUNCT3       = 3;
    parameter       NB_I_IMM        = 12;
    parameter       NB_I_IMM_11_6   = 6;
    parameter       NB_S_UIMM       = 7;
    parameter       NB_S_LIMM       = 5;

    parameter       NB_B_UUIMM      = 1;
    parameter       NB_B_ULIMM      = 6;
    parameter       NB_B_LUIMM      = 4;
    parameter       NB_B_LLIMM      = 1;

    parameter       NB_U_IMM        = 20;

    parameter       NB_J_UUIMM      = 1;
    parameter       NB_J_ULIMM      = 10;
    parameter       NB_J_LUIMM      = 1;
    parameter       NB_J_LLIMM      = 8;

    parameter       NB_CSR          = 12;

    parameter       NB_F_WIDTH      = 3;
    parameter       NB_F_IMM_4_0    = 5;
    parameter       NB_F_IMM_11_5   = 7;
    parameter       NB_F_FMT        = 2;
    parameter       NB_F_RM         = 3;

    // Compressed instruction parameters

    parameter       NB_C_OPCODE     = 2;
    parameter       NB_C_OPERAND    = 5;
    parameter       NB_C_OPERAND2   = 3;
    parameter       NB_C_FUNCT4     = 4;
    parameter       NB_C_FUNCT2     = 2;
    parameter       NB_C_FUNCT3     = 3;
    parameter       NB_C_FUNCT6     = 6;
    parameter       NB_C_JUMP_TGT   = 11;
    parameter       NB_C_CB_OFF1    = 5;
    parameter       NB_C_CB_OFF2    = 3;
    parameter       NB_C_CI_IMM1    = 5;
    parameter       NB_C_CI_IMM2    = 1;
    parameter       NB_C_CSS_IMM    = 6;
    parameter       NB_C_CIW_IMM    = 8;
    parameter       NB_C_CL_IMM1    = 2;
    parameter       NB_C_CL_IMM2    = 3;
    parameter       NB_C_CS_IMM1    = 2;
    parameter       NB_C_CS_IMM2    = 3; 

    typedef struct packed{
        logic   [NB_FUNCT7  - 1 : 0]    funct7;
        logic   [NB_OPERAND - 1 : 0]    rs2;   
        logic   [NB_OPERAND - 1 : 0]    rs1;   
        logic   [NB_FUNCT3  - 1 : 0]    funct3;
        logic   [NB_OPERAND - 1 : 0]    rd;    
        logic   [NB_OPCODE  - 1 : 0]    opcode;
    } r_type_t;

    typedef struct packed{
        logic   [NB_I_IMM   - 1 : 0]    imm;        
        logic   [NB_OPERAND - 1 : 0]    rs1;
        logic   [NB_FUNCT3  - 1 : 0]    funct3;
        logic   [NB_OPERAND - 1 : 0]    rd;
        logic   [NB_OPCODE  - 1 : 0]    opcode;
    } i_type_t;

    typedef struct packed{
        logic   [NB_S_UIMM  - 1 : 0]    upper_imm;
        logic   [NB_OPERAND - 1 : 0]    rs2;
        logic   [NB_OPERAND - 1 : 0]    rs1;
        logic   [NB_FUNCT3  - 1 : 0]    funct3;
        logic   [NB_S_LIMM  - 1 : 0]    lower_imm;
        logic   [NB_OPCODE  - 1 : 0]    opcode;
    } s_type_t;

    typedef struct packed{
        logic   [NB_B_UUIMM - 1 : 0]    imm12;
        logic   [NB_B_ULIMM - 1 : 0]    imm10_5;
        logic   [NB_OPERAND - 1 : 0]    rs2;
        logic   [NB_OPERAND - 1 : 0]    rs1;
        logic   [NB_FUNCT3  - 1 : 0]    funct3;
        logic   [NB_B_LUIMM - 1 : 0]    imm4_1;
        logic   [NB_B_LLIMM - 1 : 0]    imm11;
        logic   [NB_OPCODE  - 1 : 0]    opcode;
    } b_type_t;

    typedef struct packed{
        logic   [NB_U_IMM   - 1 : 0]    imm;
        logic   [NB_OPERAND - 1 : 0]    rd;
        logic   [NB_OPCODE  - 1 : 0]    opcode;
    } u_type_t;

    typedef struct packed{
        logic   [NB_J_UUIMM - 1 : 0]    imm20;
        logic   [NB_J_ULIMM - 1 : 0]    imm10_1;
        logic   [NB_J_LUIMM - 1 : 0]    imm11;
        logic   [NB_J_LLIMM - 1 : 0]    imm19_12;
        logic   [NB_OPERAND - 1 : 0]    rd;
        logic   [NB_OPCODE  - 1 : 0]    opcode;
    } j_type_t;

    typedef struct packed{
        logic   [NB_FUNCT5  - 1 : 0]    funct5;
        logic                           aq;
        logic                           rl;
        logic   [NB_OPERAND - 1 : 0]    rs2;   
        logic   [NB_OPERAND - 1 : 0]    rs1;   
        logic   [NB_FUNCT3  - 1 : 0]    funct3;
        logic   [NB_OPERAND - 1 : 0]    rd;    
        logic   [NB_OPCODE  - 1 : 0]    opcode;
    } a_type_t;

    typedef struct packed{
        logic   [NB_CSR     - 1 : 0]    csr;
        logic   [NB_OPERAND - 1 : 0]    rs1;   
        logic   [NB_FUNCT3  - 1 : 0]    funct3;
        logic   [NB_OPERAND - 1 : 0]    rd;    
        logic   [NB_OPCODE  - 1 : 0]    opcode;
    } csr_type_t;

    typedef struct packed{
        logic   [NB_F_IMM_11_5 -1 : 0]  imm7;
        logic   [NB_OPERAND - 1 : 0]    rs2;
        logic   [NB_OPERAND - 1 : 0]    rs1;   
        logic   [NB_F_WIDTH  - 1 : 0]   width;
        logic   [NB_F_IMM_4_0 - 1 : 0]  imm5;    
        logic   [NB_OPCODE  - 1 : 0]    opcode;
    } fd_st_type_t;

    typedef struct packed{
        logic   [NB_I_IMM - 1  : 0]     imm12;
        logic   [NB_OPERAND - 1 : 0]    rs1;   
        logic   [NB_F_WIDTH  - 1 : 0]   width;
        logic   [NB_OPERAND - 1 : 0]    rd;    
        logic   [NB_OPCODE  - 1 : 0]    opcode;
    } fd_ld_type_t;

    typedef struct packed{
        logic   [NB_FUNCT5 - 1  : 0]    funct5;
        logic   [NB_F_FMT - 1  : 0]     fmt;
        logic   [NB_OPERAND - 1  : 0]   rs2;
        logic   [NB_OPERAND - 1 : 0]    rs1;   
        logic   [NB_F_RM  - 1 : 0]      rm;
        logic   [NB_OPERAND - 1 : 0]    rd;    
        logic   [NB_OPCODE  - 1 : 0]    opcode;
    } fd_arith_type_t;

    typedef struct packed{
        logic   [NB_OPERAND - 1  : 0]   rs3;
        logic   [NB_F_FMT - 1  : 0]     fmt;
        logic   [NB_OPERAND - 1  : 0]   rs2;
        logic   [NB_OPERAND - 1 : 0]    rs1;   
        logic   [NB_F_RM  - 1 : 0]      rm;
        logic   [NB_OPERAND - 1 : 0]    rd;    
        logic   [NB_OPCODE  - 1 : 0]    opcode;
    } fd_fused_type_t;

    typedef struct packed{
        logic   [NB_WORD/2    - 1 : 0]    dummy;
        logic   [NB_C_FUNCT4  - 1 : 0]    funct4;   
        logic   [NB_C_OPERAND - 1 : 0]    rs1;
        logic   [NB_C_OPERAND - 1 : 0]    rs2;    
        logic   [NB_C_OPCODE  - 1 : 0]    opcode;
    } c_cr_type_t;

    typedef struct packed{
        logic   [NB_WORD/2    - 1 : 0]    dummy;
        logic   [NB_C_FUNCT3  - 1 : 0]    funct3;   
        logic   [NB_C_CI_IMM2  - 1 : 0]   imm;   
        logic   [NB_C_OPERAND - 1 : 0]    rs1;
        logic   [NB_C_CI_IMM1 - 1 : 0]    imm1;    
        logic   [NB_C_OPCODE  - 1 : 0]    opcode;
    } c_ci_type_t;

    typedef struct packed{
        logic   [NB_WORD/2    - 1 : 0]    dummy;
        logic   [NB_C_FUNCT3  - 1 : 0]    funct3;   
        logic   [NB_C_CSS_IMM - 1 : 0]    imm;   
        logic   [NB_C_OPERAND - 1 : 0]    rs2;    
        logic   [NB_C_OPCODE  - 1 : 0]    opcode;
    } c_css_type_t;

    typedef struct packed{
        logic   [NB_WORD/2     - 1 : 0]    dummy;
        logic   [NB_C_FUNCT3   - 1 : 0]    funct3;   
        logic   [NB_C_CIW_IMM  - 1 : 0]    imm;   
        logic   [NB_C_OPERAND2 - 1 : 0]    rd;    
        logic   [NB_C_OPCODE   - 1 : 0]    opcode;
    } c_ciw_type_t;

    typedef struct packed{
        logic   [NB_WORD/2     - 1 : 0]    dummy;
        logic   [NB_C_FUNCT3   - 1 : 0]    funct3;   
        logic   [NB_C_CL_IMM2  - 1 : 0]    imm2;   
        logic   [NB_C_OPERAND2 - 1 : 0]    rs1;    
        logic   [NB_C_CL_IMM1  - 1 : 0]    imm1;   
        logic   [NB_C_OPERAND2 - 1 : 0]    rd;    
        logic   [NB_C_OPCODE   - 1 : 0]    opcode;
    } c_cl_type_t;

    typedef struct packed{
        logic   [NB_WORD/2     - 1 : 0]    dummy;
        logic   [NB_C_FUNCT3   - 1 : 0]    funct3;   
        logic   [NB_C_CL_IMM2  - 1 : 0]    imm2;   
        logic   [NB_C_OPERAND2 - 1 : 0]    rs1;    
        logic   [NB_C_CL_IMM1  - 1 : 0]    imm1;   
        logic   [NB_C_OPERAND2 - 1 : 0]    rs2;    
        logic   [NB_C_OPCODE   - 1 : 0]    opcode;
    } c_cs_type_t;

    typedef struct packed{
        logic   [NB_WORD/2     - 1 : 0]    dummy;
        logic   [NB_C_FUNCT6   - 1 : 0]    funct6;   
        logic   [NB_C_OPERAND2 - 1 : 0]    rs1;    
        logic   [NB_C_FUNCT2   - 1 : 0]    funct2;   
        logic   [NB_C_OPERAND2 - 1 : 0]    rs2;    
        logic   [NB_C_OPCODE   - 1 : 0]    opcode;
    } c_ca_type_t;

    typedef struct packed{
        logic   [NB_WORD/2     - 1 : 0]    dummy;
        logic   [NB_C_FUNCT3   - 1 : 0]    funct3;   
        logic   [NB_C_CB_OFF2  - 1 : 0]    offset2;    
        logic   [NB_C_OPERAND2 - 1 : 0]    rs1;    
        logic   [NB_C_CB_OFF1  - 1 : 0]    offset1;    
        logic   [NB_C_OPCODE   - 1 : 0]    opcode;
    } c_cb_type_t;

    typedef struct packed{
        logic   [NB_WORD/2     - 1 : 0]    dummy;
        logic   [NB_C_FUNCT3   - 1 : 0]    funct3;   
        logic   [NB_C_JUMP_TGT - 1 : 0]    jump_target;     
        logic   [NB_C_OPCODE   - 1 : 0]    opcode;
    } c_cj_type_t;


    typedef union packed{
        logic   [NB_WORD    - 1 : 0]    instruction;
        r_type_t                        r_type;
        i_type_t                        i_type;
        s_type_t                        s_type;
        b_type_t                        b_type;
        u_type_t                        u_type;
        j_type_t                        j_type;
        a_type_t                        a_type;
        csr_type_t                      csr_type;
        fd_st_type_t                    fd_st_type;
        fd_ld_type_t                    fd_ld_type;
        fd_arith_type_t                 fd_arith_type;
        fd_fused_type_t                 fd_fused_type;
        c_cr_type_t                     cr_type;
        c_ci_type_t                     ci_type;
        c_css_type_t                    css_type;
        c_ciw_type_t                    ciw_type;
        c_cl_type_t                     cl_type;
        c_cs_type_t                     cs_type;
        c_ca_type_t                     ca_type;
        c_cb_type_t                     cb_type;
        c_cj_type_t                     cj_type;
    } instruction_t;

    typedef enum logic[NB_FUNCT3 - 1 : 0]{
        F3_BEQ      = 3'b000,
        F3_BNE      = 3'b001,
        F3_BLT      = 3'b100,
        F3_BGE      = 3'b101,
        F3_BLTU     = 3'b110,
        F3_BGEU     = 3'b111
    } branch_funct3;

    typedef enum logic[NB_FUNCT3 - 1 : 0]{
        F3_LB       = 3'b000,
        F3_LH       = 3'b001,
        F3_LW       = 3'b010,
        F3_LBU      = 3'b100,
        F3_LHU      = 3'b101,
        F3_LWU      = 3'b110,
        F3_LD       = 3'b011
    } load_funct3;

    typedef enum logic[NB_FUNCT3 - 1 : 0]{
        F3_SB       = 3'b000,
        F3_SH       = 3'b001,
        F3_SW       = 3'b010,
        F3_SD       = 3'b011
    } store_funct3;

    typedef enum logic[NB_FUNCT3 - 1 : 0]{
        F3_ADD_SUB  = 3'b000,
        F3_SLL      = 3'b001,
        F3_SLT      = 3'b010,
        F3_SLTU     = 3'b011,
        F3_XOR      = 3'b100,
        F3_SRL_SRA  = 3'b101,        
        F3_OR       = 3'b110,
        F3_AND      = 3'b111       
    } i_r_funct3;


    typedef enum logic[NB_FUNCT3 - 1 : 0]{
        F3_JALR     = 3'b000                
    } jalr_funct3;

    typedef enum logic[NB_FUNCT7 - 1 : 0]{
        F7_ARITH    = 7'b0100000,
        F7_LOGIC    = 7'b0000000
    } i_r_funct7;

    typedef enum logic[NB_I_IMM_11_6 - 1 : 0]{
        IMM11_6_ARITH    = 6'b010000,
        IMM11_6_LOGIC    = 6'b000000
    } i_i_funct7;    

    typedef enum logic[NB_FUNCT3 - 1 : 0]{
        F3_MUL_MULW    = 3'b000,
        F3_MULH        = 3'b001,
        F3_MULHSU      = 3'b010,
        F3_MULHU       = 3'b011,
        F3_DIV_DIVW    = 3'b100,
        F3_DIVU_DIVUW  = 3'b101,
        F3_REM_REMW    = 3'b110,
        F3_REMU_REMUW  = 3'b111
    } m_funct3;

    typedef enum logic[NB_FUNCT7 - 1 : 0]{
        F7_M    = 7'b0000001
    } m_funct7;

    typedef enum logic[NB_FUNCT3 - 1 : 0]{
        F3_A32  = 3'b010,
        F3_A64  = 3'b011
    } a_funct3;

    typedef enum logic[NB_FUNCT5 - 1 : 0]{
        F5_LR       = 5'b00010,
        F5_SC       = 5'b00011,
        F5_AMOSWAP  = 5'b00001,
        F5_AMOADD   = 5'b00000,
        F5_AMOXOR   = 5'b00100,
        F5_AMOAND   = 5'b01100,
        F5_AMOOR    = 5'b01000,
        F5_AMOMIN   = 5'b10000,
        F5_AMOMAX   = 5'b10100,
        F5_AMOMINU  = 5'b11000,
        F5_AMOMAXU  = 5'b11100
    } m_funct5;

    typedef enum logic[NB_FUNCT3 - 1 : 0]{
        F3_FENCE    = 3'b000,
        F3_FENCEI   = 3'b001
    } mism_mem_funct3;

    typedef enum logic[NB_FUNCT3 - 1 : 0]{
        F3_CSRRW        = 3'b001,
        F3_CSRRS        = 3'b010,
        F3_CSRRC        = 3'b011,
        F3_CSRRWI       = 3'b101,
        F3_CSRRSI       = 3'b110,
        F3_CSRRCI       = 3'b111,
        F3_ECALL_EBREAK = 3'b000
    } csr_funct3;

    typedef enum logic[NB_F_FMT - 1 : 0]{
        FMT_S   = 2'b00,
        FMT_D   = 2'b01
    } f_fmt;

    typedef enum logic[NB_F_WIDTH - 1 : 0]{
        WIDTH_WORD    = 3'b010,
        WIDTH_DWORD   = 3'b011
    } f_width;

    typedef enum logic[NB_F_RM - 1 : 0]{
        F_RM_RNE   = 3'b000,
        F_RM_RTZ   = 3'b001,
        F_RM_RDN   = 3'b010,
        F_RM_RUP   = 3'b011,
        F_RM_RMM   = 3'b100,
        F_RM_DYN   = 3'b111
    } f_rm;

    typedef enum logic[NB_F_RM - 1 : 0]{
        F_RM_MIN   = 3'b000,
        F_RM_MAX   = 3'b001
    } f_rm_minmax;

    typedef enum logic[NB_F_RM - 1 : 0]{
        F_RM_EQ    = 3'b010,
        F_RM_LT    = 3'b001,
        F_RM_LE    = 3'b000
    } f_rm_cmp;

    typedef enum logic[NB_F_RM - 1 : 0]{
        F_RM_J     = 3'b000,
        F_RM_JN    = 3'b001,
        F_RM_JX    = 3'b010
    } f_rm_sgn;

    typedef enum logic[NB_OPERAND - 1 : 0]{
        FCVT    = 5'b00000,
        FCVT_U  = 5'b00001,
        FCVTL   = 5'b00010,
        FCVTL_U = 5'b00011
    } f_rs2_fcvt;

    typedef enum logic[NB_FUNCT5 - 1 : 0]{
        F5_FADD       = 5'b00000,
        F5_FSUB       = 5'b00001,
        F5_FMUL       = 5'b00010,
        F5_FDIV       = 5'b00011,
        F5_FSQRT      = 5'b01011,
        F5_FSGNJ      = 5'b00100,
        F5_FMINMAX    = 5'b00101,
        F5_FCVT_W_S   = 5'b11000,
        F5_FCVT_S_W   = 5'b11010,
        F5_FCVT_S_D   = 5'b01000,
        F5_FMV_W_X    = 5'b11110,    // same for FMV_D_X
        F5_FCMP       = 5'b10100,
        F5_FCLASS     = 5'b11100     // same for FMV_X_W and FMV_X_D
    } f_funct5;


    typedef enum logic[NB_OPCODE - 1 : 0]{
        LUI         = 7'b0110111,
        AUIPC       = 7'b0010111,
        JAL         = 7'b1101111,
        JALR        = 7'b1100111,
        BRANCH      = 7'b1100011,
        LOAD        = 7'b0000011,
        STORE       = 7'b0100011,
        OP_IMM      = 7'b0010011,
        OP          = 7'b0110011,
        OP_IMM_32   = 7'b0011011,
        OP_32       = 7'b0111011,
        AMO         = 7'b0101111,
        MISC_MEM    = 7'b0001111,
        SYSTEM      = 7'b1110011,
        LOAD_FP     = 7'b0000111,
        STORE_FP    = 7'b0100111,
        FMADD       = 7'b1000011,
        FMSUB       = 7'b1000111,
        FNMADD      = 7'b1001011,
        FNMSUB      = 7'b1001111,
        OP_FP       = 7'b1010011

    } opcodes;

    typedef enum logic[NB_C_OPCODE - 1 : 0]{
        C0       = 2'b00,
        C1       = 2'b01,
        C2       = 2'b10
    } c_opcodes;

    typedef enum logic[NB_CSR   - 1 : 0]{
        ECALL       = 12'b000000000000,
        EBREAK      = 12'b000000000001
    } system_csr;


    typedef enum logic[NB_C_FUNCT3 - 1 : 0]{
        // C_ILLEGAL_FUNCT3   = 3'b000,
        C_ADDI4SPN_FUNCT3  = 3'b000,
        C_FLD_FUNCT3       = 3'b001,
        C_LW_FUNCT3        = 3'b010,
        C_LD_FUNCT3        = 3'b011,
        C_FSD_FUNCT3       = 3'b101,
        C_SW_FUNCT3        = 3'b110,
        C_SD_FUNCT3        = 3'b111
    } c_quad0_funct3;

    typedef enum logic[NB_C_FUNCT3 - 1 : 0]{
        // C_NOP_FUNCT3         = 3'b000,
        C_ADDI_FUNCT3        = 3'b000,
        C_ADDIW_FUNCT3       = 3'b001,
        C_LI_FUNCT3          = 3'b010,
        C_ADDI16SP_LUI_FUNCT3 = 3'b011,
        // C_LUI_FUNCT3         = 3'b011,
        // C_SRLI_FUNCT3        = 3'b100,
        // C_SRAI_FUNCT3        = 3'b100,
        // C_ANDI_FUNCT3        = 3'b100,
        C_COMMON_Q1_FUNCT3   = 3'b100,  // common define
        C_J_FUNCT3           = 3'b101,
        C_BEQZ_FUNCT3        = 3'b110,
        C_BNEZ_FUNCT3        = 3'b111
    } c_quad1_funct3;

    typedef enum logic[NB_C_FUNCT3 - 1 : 0]{
        C_SLLI_FUNCT3      = 3'b000,
        C_FLDSP_FUNCT3     = 3'b001,
        C_LWSP_FUNCT3      = 3'b010,
        C_LDSP_FUNCT3      = 3'b011,
        // C_FUNCT4 = 3'b100, 
        C_FSDSP_FUNCT3     = 3'b101,
        C_SWSP_FUNCT3      = 3'b110,
        C_SDSP_FUNCT3      = 3'b111
    } c_quad2_funct3;


    typedef enum logic[NB_C_FUNCT4 - 1 : 0]{
        C_MV_JR_FUNCT4      = 4'b1000,
        // C_ADD_FUNCT4     = 4'b1001,
        // C_EBREAK_FUNCT4  = 4'b1001,
        // C_JALR_FUNCT4    = 4'b1001
        C_ADD_EB_JALR_FUNCT4 =  4'b1001
    } c_type_funct4;

    typedef enum logic[NB_C_FUNCT2 - 1 : 0]{
        C_SUB_SUBW_FUNCT2  = 2'b00,
        C_XOR_ADDW_FUNCT2  = 2'b01,
        C_OR_FUNCT2        = 2'b10,
        C_AND_FUNCT2       = 2'b11
        // C_SUBW_FUNCT2      = 2'b00,
        // C_ADDW_FUNCT2      = 2'b01
    } c_type_funct2;

    typedef enum logic[NB_C_FUNCT6 - 1 : 0]{
        // C_SUB_FUNCT6      = 6'b100011,
        // C_XOR_FUNCT6      = 6'b100011,
        // C_OR_FUNCT6       = 6'b100011,
        // C_AND_FUNCT6      = 6'b100011,
        C_ARITH1_FUNCT6   = 6'b100011,
        // C_SUBW_FUNCT6     = 6'b100111,
        // C_ADDW_FUNCT6     = 6'b100111
        C_ARITH2_FUNCT6   = 6'b100111
    } c_type_funct6;

endpackage