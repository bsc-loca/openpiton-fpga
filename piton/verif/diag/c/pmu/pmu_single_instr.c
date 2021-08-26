// Title      : PMU single instruction demo
// Project    : MEEP
// License    : <License type>
/*****************************************************************************/
// File        : pmu_single_instr.c
// Author      : Pablo Criado Albillos; pablo.criado@bsc.es
// Company     : Barcelona Supercomputing Center (BSC)
// Created     : 10/08/2021
// Last update : 10/08/2021
/*****************************************************************************/
// Description: Simple PMU Demo to demonstrate the usage of the library with a single instruction algorithm
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

#include <stdio.h>
#include "pmu.h"

int single_instr(void)
{
    __asm__("addi t0, x0, 0 \n");
}

int main(int argc, char **argv)
{
    printf("PMU single instruction demo\n");
    // Get Tile ID
    char cid = argv[0][0];

    // Initialize profiling
    init_profiling(cid);

    // Your code to be profiled goes here
    single_instr();

    // Stop profiling and print results
    stop_profiling(cid);
    print_summary(cid);

    return 0;
}