#define __riscv_xlen 16
#include "test_macros.h"

.globl _start
.section .text


INIT_TEST(e16, 1024)

#-------------------------------------------------------------
# Arithmetic tests
#-------------------------------------------------------------

TEST_RR_OP( 1, vand.vv, v1, 0xff00, 0x0f0f )
TEST_RR_OP( 2, vand.vv, v2, 0x0ff0, 0xf0f0 )
TEST_RR_OP( 3, vand.vv, v3, 0xf00f, 0xf0f0 )

#-------------------------------------------------------------
# Source/Destination tests
#-------------------------------------------------------------

TEST_RR_SRC1_EQ_DEST( 17, vand.vv, v16, 0xff00, 0x0f0f )
TEST_RR_SRC2_EQ_DEST( 18, vand.vv, v17, 0x0ff0, 0xf0f0 )
TEST_RR_SRC12_EQ_DEST( 19, vand.vv, v18, 0xff00 )

#-------------------------------------------------------------
# Zero
#-------------------------------------------------------------

TEST_RR_ZERO_SRC1( 35, vand.vv, v19, 0xff00 )
TEST_RR_ZERO_SRC2( 36, vand.vv, v20, 0x00ff )
TEST_RR_ZERO_SRC12( 37, vand.vv, v21 )

#-------------------------------------------------------------
# VX
#-------------------------------------------------------------
TEST_RX_OP( 38, vand.vx, v22, 0xff00, 0x0f0f )

#-------------------------------------------------------------
# IMM
#-------------------------------------------------------------
TEST_IMM_OP( 39, vand.vi, v23, 0xff00, 0xf )

END_TEST

RVTEST_DATA ()
