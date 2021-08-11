// Title      : PMU multicore demo
// Project    : MEEP
// License    : <License type>
/*****************************************************************************/
// File        : pmu_multicore.c
// Author      : Pablo Criado Albillos; pablo.criado@bsc.es
// Company     : Barcelona Supercomputing Center (BSC)
// Created     : 10/08/2021
// Last update : 10/08/2021
/*****************************************************************************/
// Description: PMU Demo to demonstrate the usage of the library and CSV export
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

#include <stdint.h>
#include <stdio.h>
#include "util.h"
#include "pmu.h"

int main(int argc, char **argv)
{
    // Get Tile ID
    char cid = argv[0][0];
    char tile_count = argv[0][1];

    if (cid == 0)
        printf("PMU multicore demo\n");

    // Initialize profiling
    init_profiling(cid);

    // synchronization variable
    volatile static uint32_t amo_cnt = 0;

    // synchronize with other cores and wait until it is this core's turn
    while (cid != amo_cnt)
        ;

    // assemble number and print
    printf("Hello world, this is hart %d of %d harts!\n", cid, tile_count);

    // increment atomic counter
    ATOMIC_OP(amo_cnt, 1, add, w);

    // Stop profiling
    stop_profiling(cid);

    // Only master tile (#0) will continue to print the results for all the tiles
    if (cid != 0)
        return 0;

    // For master tile, wait for the last core and print each summary
    while (amo_cnt != tile_count)
        ;
    for (uint8_t print_cid = 0; print_cid < tile_count; print_cid++)
        print_summary(print_cid);

    return 0;
}