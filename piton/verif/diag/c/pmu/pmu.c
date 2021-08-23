// Title      : pmu library code
// Project    : MEEP
// License    : <License type>
/*****************************************************************************/
// File        : pmu.c
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

#include "pmu.h"
#include <stdint.h>

volatile uint64_t *get_pointer(uint8_t tile_id, uint8_t reg)
{
    return (volatile uint64_t *)(BASE_ADDRESS | (tile_id << 9) | reg);
}

void start_counters(uint8_t tile_id)
{
    *get_pointer(tile_id, REG_CONFIG) |= 0x1;
}

void stop_counters(uint8_t tile_id)
{
    *get_pointer(tile_id, REG_CONFIG) &= 0xfffffffffffffffe;
}

void reset_counters(uint8_t tile_id)
{
    // Set reset bit to 1
    *get_pointer(tile_id, REG_CONFIG) |= 0x2;
    // Set reset bit to 0
    *get_pointer(tile_id, REG_CONFIG) &= 0xfffffffffffffffd;
}

void init_profiling(uint8_t tile_id)
{
    // Stop and reset counters
    *get_pointer(tile_id, REG_CONFIG) = 0x2;
    // Start counters and remove reset bit
    *get_pointer(tile_id, REG_CONFIG) = 0x1;
    // Read register to ensure data has been written before continuing execution
    uint64_t sink = *get_pointer(tile_id, REG_CONFIG);
}

void stop_profiling(uint8_t tile_id)
{
    // Stop counters, ignoring reset bit, which avoid unnecesary I/O read thus profiler overhead
    *get_pointer(tile_id, REG_CONFIG) = 0x0;
    // Read register to ensure data has been written before continuing execution
    uint64_t sink = *get_pointer(tile_id, REG_CONFIG);
}

uint64_t read_register(uint8_t tile_id, uint8_t reg)
{
    return *get_pointer(tile_id, reg);
}

void print_summary(uint8_t tile_id)
{
    printf("==================== Execution stats for tile #%d ====================\n", tile_id);
    printf("=\n");

    uint64_t clock_cycles = read_register(tile_id, REG_CLOCK);
    uint64_t instructions = read_register(tile_id, REG_NEW_INST);
    printf("= Summary:\n");
    printf("=   *Clock cycles: %ld\n", clock_cycles);
    printf("=   *Executed instructions: %ld (%ld cycles per instruction)\n", instructions, clock_cycles / instructions);
    printf("=\n");

    uint64_t is_branch = read_register(tile_id, REG_IS_BRANCH);
    uint64_t is_branch_hit = read_register(tile_id, REG_IS_BRANCH_HIT);
    uint64_t is_branch_false_positive = read_register(tile_id, REG_IS_BRANCH_FALSE_POSITIVE);
    uint64_t taken_branches = read_register(tile_id, REG_BRANCH_TAKEN);
    uint64_t taken_branches_hit = read_register(tile_id, REG_BRANCH_TAKEN_HIT);
    uint64_t taken_branches_b_not_detected = read_register(tile_id, REG_BRANCH_TAKEN_B_NOT_DETECTED);
    uint64_t taken_branches_addr_miss = read_register(tile_id, REG_BRANCH_TAKEN_ADDR_MISS);
    uint64_t not_taken_branches_hit = read_register(tile_id, REG_BRANCH_NOT_TAKEN_HIT);
    uint64_t taken_branches_miss = taken_branches - taken_branches_hit;
    uint64_t not_taken_branches = is_branch - taken_branches;

    printf("= Branches:\n");
    printf("=   *Branch instructions: %ld (%ld hits - %d%%, %ld misses, %ld false-positives)\n", is_branch, is_branch_hit, 100 * is_branch_hit / is_branch, is_branch - is_branch_hit, is_branch_false_positive);
    printf("=     *Taken: %ld (%ld hits - %d%%, %ld misses)\n", taken_branches, taken_branches_hit, 100 * taken_branches_hit / taken_branches, taken_branches - taken_branches_hit);
    printf("=       *Missed: %ld (%ld branch not detected, %ld wrong decision, %ld wrong address)\n", taken_branches_miss, taken_branches_b_not_detected, taken_branches_miss - (taken_branches_b_not_detected + taken_branches_addr_miss), taken_branches_addr_miss);
    printf("=     *Not taken: %ld (%ld hits - %d%%, %ld misses)\n", not_taken_branches, not_taken_branches_hit, 100 * not_taken_branches_hit / not_taken_branches, not_taken_branches - not_taken_branches_hit);
    printf("=\n");

    uint64_t stall_if = read_register(tile_id, REG_STALL_IF);
    uint64_t stall_id = read_register(tile_id, REG_STALL_ID);
    uint64_t stall_rr = read_register(tile_id, REG_STALL_RR);
    uint64_t stall_exe = read_register(tile_id, REG_STALL_EXE);
    uint64_t stall_wb = read_register(tile_id, REG_STALL_WB);
    printf("= Pipeline stalls per stage:\n");
    printf("=   *Instruction fetch: %ld\n", stall_if);
    printf("=   *Instruction decode: %ld\n", stall_id);
    printf("=   *Read registers: %ld\n", stall_rr);
    printf("=   *Execution: %ld\n", stall_exe);
    printf("=   *Write back / commit: %ld\n", stall_wb);
    printf("=\n");

    uint64_t dcache_access = read_register(tile_id, REG_DCACHE_ACCESS);
    uint64_t dcache_miss = read_register(tile_id, REG_DCACHE_MISS);
    uint16_t dcache_miss_percent = 10000 * dcache_miss / dcache_access;
    uint64_t dcache_l2_miss = read_register(tile_id, REG_DCACHE_MISS_L2_MISS);
    uint16_t dcache_l2_miss_percent = 10000 * dcache_l2_miss / dcache_access;
    printf("= Cache accesses:\n");
    printf("=   *Data: Core ----%ld---> DCache ---%ld(%d.%02d%%)--> L2 ---%ld(%d.%02d%%)--> Memory / IO\n", dcache_access, dcache_miss, dcache_miss_percent / 100, dcache_miss_percent % 100, dcache_l2_miss, dcache_l2_miss_percent / 100, dcache_l2_miss_percent % 100);

    uint64_t icache_access = read_register(tile_id, REG_ICACHE_ACCESS);
    uint64_t icache_miss = read_register(tile_id, REG_ICACHE_MISS);
    uint16_t icache_miss_percent = 10000 * icache_miss / icache_access;
    uint64_t icache_l2_miss = read_register(tile_id, REG_ICACHE_MISS_L2_MISS);
    uint16_t icache_l2_miss_percent = 10000 * icache_l2_miss / icache_access;
    printf("=   *Instructions: Core ----%ld---> ICache ---%ld(%d.%02d%%)--> L2 ---%ld(%d.%02d%%)--> Memory / IO\n", icache_access, icache_miss, icache_miss_percent / 100, icache_miss_percent % 100, icache_l2_miss, icache_l2_miss_percent / 100, icache_l2_miss_percent % 100);
    printf("=\n");

    uint64_t exe_load = read_register(tile_id, REG_EXE_LOAD);
    uint64_t exe_store = read_register(tile_id, REG_EXE_STORE);
    printf("= Memory access cycles:\n");
    printf("=   *Load: %ld\n", exe_load);
    printf("=   *Store: %ld\n", exe_store);
    printf("=\n");

    uint64_t dtlb_miss = read_register(tile_id, REG_DTLB_MISS);
    uint64_t itlb_miss = read_register(tile_id, REG_ITLB_MISS);
    printf("= TLB misses:\n");
    printf("=   *Data: %ld\n", dtlb_miss);
    printf("=   *Instructions: %ld\n", itlb_miss);
    printf("=\n");

    printf("====================== End of execution stats =======================\n");
}

void dump_registers(uint8_t tile_id, uint64_t *dest)
{
    for (volatile uint64_t *ptr = get_pointer(tile_id, REG_CLOCK); ptr <= get_pointer(tile_id, REG_ITLB_MISS); ptr += 1)
    {
        *dest = *ptr;
        dest += 1;
    }
}

void print_csv(uint64_t **src, size_t size)
{
    printf("num,");
    printf(REG_NAMES);
    printf("\n");
    for (size_t i = 0; i < size; i++)
    {
        printf("%d", i);
        for (size_t j = 0; j < REG_COUNT; j++)
            printf(",%ld", src[i][j]);
        printf("\n");
    }
}