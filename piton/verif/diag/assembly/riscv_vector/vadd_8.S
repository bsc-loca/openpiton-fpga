#define __riscv_xlen 8
#include "test_macros.h"

.globl _start
.section .text

INIT_TEST(e64, 8)

#-------------------------------------------------------------
# Arithmetic tests
#-------------------------------------------------------------

TEST_RR_OP( 1, vadd.vv, v1, 0x00, 0x00)
TEST_RR_OP( 2, vadd.vv, v2, 0x01, 0x01)
TEST_RR_OP( 3, vadd.vv, v3, 0x03, 0x07)

TEST_RR_OP( 5, vadd.vv, v4, 0x00, 0xf8 )
TEST_RR_OP( 6, vadd.vv, v5, 0xf8, 0x00 )
TEST_RR_OP( 7, vadd.vv, v6, 0xf8, 0xf8 )

TEST_RR_OP( 8,  vadd.vv, v7, 0x00, 0x7f )
TEST_RR_OP( 9,  vadd.vv, v8, 0x7f, 0x00 )
TEST_RR_OP( 10, vadd.vv, v9, 0x7f, 0x07 )

TEST_RR_OP( 11, vadd.vv, v10, 0x80, 0x07 )
TEST_RR_OP( 12, vadd.vv, v11, 0x7f, 0x80 )

TEST_RR_OP( 13, vadd.vv, v12, 0x00, 0xff )
TEST_RR_OP( 14, vadd.vv, v13, 0xff, 0x01 )
TEST_RR_OP( 15, vadd.vv, v14, 0xff, 0xff )

TEST_RR_OP( 16, vadd.vv, v15, 0x01, 0x7f )

#-------------------------------------------------------------
# Source/Destination tests
#-------------------------------------------------------------

TEST_RR_SRC1_EQ_DEST( 17, vadd.vv, v16, 13, 11 )
TEST_RR_SRC2_EQ_DEST( 18, vadd.vv, v17, 14, 11 )
TEST_RR_SRC12_EQ_DEST( 19, vadd.vv, v18, 13 )

#-------------------------------------------------------------
# Zero
#-------------------------------------------------------------

TEST_RR_ZERO_SRC1( 35, vadd.vv, v19, 15 )
TEST_RR_ZERO_SRC2( 36, vadd.vv, v20, 32 )
TEST_RR_ZERO_SRC12( 37, vadd.vv, v21 )

#-------------------------------------------------------------
# VX
#-------------------------------------------------------------
TEST_RX_OP( 38, vadd.vx, v22, 13, 11 )

#-------------------------------------------------------------
# IMM
#-------------------------------------------------------------
TEST_IMM_OP( 39, vadd.vi, v23, 13, 11 )

END_TEST

RVTEST_DATA ()
