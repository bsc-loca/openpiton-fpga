/* -----------------------------------------------
 * Project Name   : OpenPiton + Lagarto
 * File           : all_stats.h
 * Organization   : Barcelona Supercomputing Center
 * Author(s)      : Noelia Oliete Escuin
 * Email(s)       : noelia.oliete@bsc.es
 * -----------------------------------------------*/
#ifndef __ALL_STATS_H
#define __ALL_STATS_H
#include "cache_metrics.h"
#include "util.h"

#define all_stats(code, iter) do { \
    volatile static uint32_t _amo_cnt = 0; \
    reset_L2_metrics(cid); \
    unsigned long _c = -read_csr(mcycle), _i = -read_csr(minstret); init_L2_metrics(cid); \
    code; \
    stop_L2_metrics(cid); \
    _c += read_csr(mcycle), _i += read_csr(minstret); \
    unsigned long _access = read_L2_access(cid), _miss = read_L2_misses(cid); \
    if(argv[0][0] == 0){ \
    	printf("\n%s: \n", stringify(code)); \
    	printf("--Stats---\nCID, cycles, cycles/iter, CPI, L2_access, L2_mis\n");\
    }\
    while(argv[0][0] != _amo_cnt); \
    printf("%d, %ld,  %ld.%ld, %ld.%ld, %ld, %ld\n",cid, _c, _c/iter, 10*_c/iter%10, _c/_i, 10*_c/_i%10, _access,_miss );\
    ATOMIC_OP(_amo_cnt, 1, add, w); \
    if(argv[0][0] == nc-1) printf("--Stats---\n"); \
  } while(0)

#endif   //__ALL_STATS_H


