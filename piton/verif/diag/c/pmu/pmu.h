// Title      : pmu library header
// Project    : MEEP
// License    : <License type>
/*****************************************************************************/
// File        : pmu.h
// Author      : Pablo Criado Albillos; pablo.criado@bsc.es
// Company     : Barcelona Supercomputing Center (BSC)
// Created     : 10/08/2021
// Last update : 10/08/2021
/*****************************************************************************/
// Description: PMU library
//
// Comments    : https://wiki.meep-project.eu/index.php/Lagarto_PMU_openpiton
/*****************************************************************************/
// Copyright (c) 2021 BSC
/*****************************************************************************/
// Revisions  :
// Date/Time                Version               Engineer
// 28/07/2021               1.0                   pablo.criado@bsc.es
// Comments   : Initial implementation
/*****************************************************************************/

#ifndef PMU_HEADER
#define PMU_HEADER

#include <stdint.h>

#define BASE_ADDRESS 0xfff5100000
// Number of registers, excluding config one
#define REG_COUNT 20
#define REG_LENGTH REG_COUNT*8

#define REG_CONFIG 0x00
#define REG_CLOCK 0x08
#define REG_NEW_INST 0x10
#define REG_IS_BRANCH 0x18
#define REG_BRANCH_TAKEN 0x20
#define REG_BRANCH_MISS 0x28
#define REG_STALL_IF 0x30
#define REG_STALL_ID 0x38
#define REG_STALL_RR 0x40
#define REG_STALL_EXE 0x48
#define REG_STALL_WB 0x50
#define REG_EXE_STORE 0x58
#define REG_EXE_LOAD 0x60
#define REG_DCACHE_ACCESS 0x68
#define REG_DCACHE_MISS 0x70
#define REG_DCACHE_MISS_L2_HIT 0x78
#define REG_ICACHE_ACCESS 0x80
#define REG_ICACHE_MISS 0x88
#define REG_ICACHE_MISS_L2_HIT 0x90
#define REG_DTLB_MISS 0x98
#define REG_ITLB_MISS 0xA0

#define REG_NAMES "clk,new_ins,is_br,br_taken,br_miss,stall_if,stall_id,stall_rr,stall_exe,stall_wb,ex_store,ex_load,dc_access,dc_miss,dc_l2hit,ic_access,ic_miss,ic_l2hit,dtlb_miss,itlb_miss"

void start_counters(uint8_t tile_id);
void stop_counters(uint8_t tile_id);
void reset_counters(uint8_t tile_id);
void init_profiling(uint8_t tile_id);
void end_profiling(uint8_t tile_id);

uint64_t read_register(uint8_t tile_id, uint8_t reg);

void print_summary(uint8_t tile_id);

void dump_registers(uint8_t tile_id, uint64_t *dest);
void print_csv(uint64_t **src, size_t size);

#include "pmu.c"

#endif