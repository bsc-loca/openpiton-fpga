#define __riscv_xlen 32
#include "test_macros.h"

.globl _start
.section .text


INIT_TEST(e32, 512)

#-------------------------------------------------------------
# Arithmetic tests
#-------------------------------------------------------------
TEST_RR_OP( 2,  vmslt.vv, v0, 0x00000000, 0x00000000 );
TEST_RR_OP( 3,  vmslt.vv, v1, 0x00000001, 0x00000001 );
TEST_RR_OP( 4,  vmslt.vv, v2, 0x00000003, 0x00000007 );
TEST_RR_OP( 5,  vmslt.vv, v3, 0x00000007, 0x00000003 );

TEST_RR_OP( 6,  vmslt.vv, v4, 0x00000000, 0xffff8000 );
TEST_RR_OP( 7,  vmslt.vv, v5, 0xfffffff8, 0x00000000 );
TEST_RR_OP( 8,  vmslt.vv, v6, 0xffff8000, 0xffffff80 );

TEST_RR_OP( 9,  vmslt.vv, v7, 0x00000000, 0x00007fff );
TEST_RR_OP( 10, vmslt.vv, v8, 0x7fffffff, 0x00000000 );
TEST_RR_OP( 11, vmslt.vv, v9, 0x7fffffff, 0x00007fff );

TEST_RR_OP( 12, vmslt.vv, v10, 0xffffff8, 0x00007fff );
TEST_RR_OP( 13, vmslt.vv, v11, 0x7ffffff, 0xffff8000 );

TEST_RR_OP( 14, vmslt.vv, v12, 0x00000000, 0xffffffff );
TEST_RR_OP( 15, vmslt.vv, v13, 0xffffffff, 0x00000001 );
TEST_RR_OP( 16, vmslt.vv, v14, 0xffffffff, 0xffffffff );

#-------------------------------------------------------------
# Source/Destination tests
#-------------------------------------------------------------

TEST_RR_SRC1_EQ_DEST( 17, vmslt.vv, v16, 14, 13 )
TEST_RR_SRC2_EQ_DEST( 18, vmslt.vv, v17, 11, 13)
TEST_RR_SRC12_EQ_DEST( 19, vmslt.vv, v18, 13 )

#-------------------------------------------------------------
# Zero
#-------------------------------------------------------------

TEST_RR_ZERO_SRC1( 35, vmslt.vv, v19, -1 )
TEST_RR_ZERO_SRC2( 36, vmslt.vv, v20, -1 )
TEST_RR_ZERO_SRC12( 37, vmslt.vv, v21 )

#-------------------------------------------------------------
# VX
#-------------------------------------------------------------
TEST_RX_OP( 38, vmslt.vx, v22, 13, 12)

#-------------------------------------------------------------
# IMM
#-------------------------------------------------------------
//TEST_IMM_OP( 39, vmslt.vi, v23, 3, 14 )

END_TEST

RVTEST_DATA ()
