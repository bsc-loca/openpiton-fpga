#ifndef PMU_HEADER
#define PMU_HEADER

#include <stdint.h>

#define BASE_ADDRESS 0xfff5100000

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

void start_counters(uint8_t tile_id);
void stop_counters(uint8_t tile_id);
void reset_counters(uint8_t tile_id);

uint64_t read_register(uint8_t tile_id, uint8_t reg);

void print_summary(uint8_t tile_id);

#include "pmu.c"

#endif