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

uint64_t read_register(uint8_t tile_id, uint8_t reg)
{
    return *get_pointer(tile_id, reg);
}

void print_summary(uint8_t tile_id)
{
    printf("==================== Execution stats ====================\n");
    printf("=\n");

    uint64_t clock_cycles = read_register(tile_id, REG_CLOCK);
    uint64_t instructions = read_register(tile_id, REG_NEW_INST);
    printf("= Summary:\n");
    printf("= *Clock cycles: %ld\n", clock_cycles);
    printf("= *Executed instructions: %ld (%ld cycles per instruction)\n", instructions, clock_cycles / instructions);
    printf("=\n");

    uint64_t branches = read_register(tile_id, REG_IS_BRANCH);
    uint64_t taken_branches = read_register(tile_id, REG_BRANCH_TAKEN);
    uint64_t missed_branches = read_register(tile_id, REG_BRANCH_MISS);
    printf("= Branches:\n");
    printf("= *Total branches: %ld\n", branches);
    printf("= *Taken branches: %ld\n", taken_branches);
    printf("= *Missed branches: %ld\n", missed_branches);
    printf("=\n");

    uint64_t stall_if = read_register(tile_id, REG_STALL_IF);
    uint64_t stall_id = read_register(tile_id, REG_STALL_ID);
    uint64_t stall_rr = read_register(tile_id, REG_STALL_RR);
    uint64_t stall_exe = read_register(tile_id, REG_STALL_EXE);
    uint64_t stall_wb = read_register(tile_id, REG_STALL_WB);
    printf("= Pipeline stalls produced by each stage:\n");
    printf("= *Instruction fetch: %ld\n", stall_if);
    printf("= *Instruction decode: %ld\n", stall_id);
    printf("= *Read registers: %ld\n", stall_rr);
    printf("= *Execution: %ld\n", stall_exe);
    printf("= *Write back / commit: %ld\n", stall_wb);
    printf("=\n");

    uint64_t exe_load = read_register(tile_id, REG_EXE_LOAD);
    uint64_t exe_store = read_register(tile_id, REG_EXE_STORE);
    printf("= Memory access:\n");
    printf("= *Load executions: %ld\n", exe_load);
    printf("= *Store executions: %ld\n", exe_store);
    printf("=\n");

    printf("==================== End of execution stats ====================\n");
}
