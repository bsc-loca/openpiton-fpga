#define INIT_TEST(vsew, vlen) \
    _start: \
    li x19, 0x800000000024112d; \
    csrw misa, x19; \
    _init: \
    _init_mem: \
        la x17, work_region; \
        la x16, init_region; \
        beq x17, x16, _finish_loop_init_mem; \
        sub x15, x17, x16; \
    _loop_init_mem: \
        ld x14, 0(x16); \
        sd x14, 0(x17); \
        addi x16, x16, 8; \
        addi x17, x17, 8; \
        addi x18, x18, 8; \
        addi x15, x15, -1; \
        bne x15, zero, _loop_init_mem; \
    _finish_loop_init_mem: \
        li x7, 0xa01883e00; \
        csrw 0x300, x7; \
        li x7, 0x0; \
        csrw 0x304, x7; \
        li x24, vlen; \
        vsetvli x19, x24, vsew; \

#define END_TEST \
    test_done: \
        li t0, 1; \
    _exit: \
        csrrw t0, 0x9f0, t0; \
        j _exit; \
.pushsection .tohost,"aw",@progbits; \
.align 6; .global tohost; tohost: .dword 0; \
.align 6; .global fromhost; fromhost: .dword 0; \
.popsection; \
.align 4; \
.pushsection .user_stack,"aw",@progbits; \

#define RVTEST_DATA(data_allocation...) \
    .data; \
    .align 8; \
    init_region: \
        data_allocation; \
    work_region: \
        data_allocation

#define MASK_XLEN(x) ((x) & ((1 << (__riscv_xlen - 1) << 1) - 1))

#define TEST_RR_OP(testnum, inst, vd, val1, val2) \
    test_ ## testnum: \
    li x8, MASK_XLEN(val1); \
    li x9, MASK_XLEN(val2); \
    vmv.v.x v3, x8; \
    vmv.v.x v4, x9; \
    inst vd, v3, v4;

#define TEST_RR_OP_MASKED(testnum, inst, vd, val1, val2) \
    test_ ## testnum: \
    li x8, MASK_XLEN(val1); \
    li x9, MASK_XLEN(val2); \
    vmv.v.x v3, x8; \
    vmv.v.x v4, x9; \
    inst vd, v3, v4, v0.t;

#define TEST_RR_SRC1_EQ_DEST(testnum, inst, vd, val1, val2) \
    test_ ## testnum: \
    li x8, MASK_XLEN(val1); \
    li x9, MASK_XLEN(val2); \
    vmv.v.x vd, x8; \
    vmv.v.x v4, x9; \
    inst vd, vd, v4;

#define TEST_RR_SRC2_EQ_DEST(testnum, inst, vd, val1, val2) \
    test_ ## testnum: \
    li x8, MASK_XLEN(val1); \
    li x9, MASK_XLEN(val2); \
    vmv.v.x v3, x8; \
    vmv.v.x vd, x9; \
    inst vd, v3, vd;

#define TEST_RR_SRC12_EQ_DEST(testnum, inst, vd, val1) \
    test_ ## testnum: \
    li x8, MASK_XLEN(val1); \
    vmv.v.x vd, x8; \
    inst vd, vd, vd;

#define TEST_RR_ZERO_SRC1(testnum, inst, vd, val2) \
    test_ ## testnum: \
    li x8, MASK_XLEN(val2); \
    vmv.v.x vd, x8; \
    vmv.v.x v31, zero; \
    inst vd, v31, vd;

#define TEST_RR_ZERO_SRC2(testnum, inst, vd, val1) \
    test_ ## testnum: \
    li x8, MASK_XLEN(val1); \
    vmv.v.x vd, x8; \
    vmv.v.x v31, zero; \
    inst vd, vd, v31;

#define TEST_RR_ZERO_SRC12(testnum, inst, vd) \
    test_ ## testnum: \
    vmv.v.x v31, zero; \
    inst vd, v31, v31;

#define TEST_RX_OP(testnum, inst, vd, val1, val2) \
    test_ ## testnum: \
    li x8, MASK_XLEN(val1); \
    li x9, MASK_XLEN(val2); \
    vmv.v.x v3, x8; \
    inst vd, v3, x9;

#define TEST_IMM_OP(testnum, inst, vd, val1, imm) \
    test_ ## testnum: \
    li x8, MASK_XLEN(val1); \
    vmv.v.x v3, x8; \
    inst vd, v3, MASK_XLEN(imm);

#define TEST_MEM_US_OP(testnum, inst, vd_vs3, base, masked) TEST_MEM_US_OP_##masked (testnum, inst, vd_vs3, base)

#define TEST_MEM_US_OP_NOTMASKED(testnum, inst, vd_vs3, base) \
    test_ ## testnum: \
    la x1, base; \
    inst vd_vs3, (x1);

#define TEST_MEM_US_OP_MASKED(testnum, inst, vd_vs3, base) \
    test_ ## testnum: \
    la x1, base; \
    inst vd_vs3, (x1), v0.t;

#define TEST_MEM_STR_OP(testnum, inst, vd_vs3, rs2, base, masked) TEST_MEM_STR_OP_## masked (testnum, inst, vd_vs3, rs2, base)

#define TEST_MEM_STR_OP_NOTMASKED(testnum, inst, vd_vs3, rs2, base) \
    test_ ## testnum: \
    la x1, base; \
    li x8, rs2; \
    inst vd_vs3, (x1), x8;

#define TEST_MEM_STR_OP_MASKED(testnum, inst, vd_vs3, rs2, base) \
    test_ ## testnum: \
    la x1, base; \
    li x8, rs2; \
    inst vd_vs3, (x1), x8, v0.t;

#define TEST_MEM_IND_OP(testnum, inst, vd_vs3, vs2, base, masked) TEST_MEM_IND_OP_## masked (testnum, inst, vd_vs3, vs2, base)

#define TEST_MEM_IND_OP_NOTMASKED(testnum, inst, vd_vs3, vs2, base) \
    test_ ## testnum: \
    la x1, base; \
    inst vd_vs3, (x1), vs2;

#define TEST_MEM_IND_MASKED(testnum, inst, vd_vs3, vs2, base) \
    test_ ## testnum: \
    la x1, base; \
    inst vd_vs3, (x1), vs2, v0.t;


#define CHANGE_FRM(val) \
    frcsr x1; \
    li x2, 0xFFFFFFFFFFFFFFFF; \
    li x3, 7; \
    slli x3, x3, 5; \
    xor x2, x2, x3; \
    and x1, x1, x2; \
    li x2, val; \
    slli x2, x2, 5; \
    or x1, x1, x2; \
    fscsr x1, x1;
