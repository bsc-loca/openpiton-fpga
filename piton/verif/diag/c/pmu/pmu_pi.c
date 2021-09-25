// Title      : PMU PI demo
// Project    : MEEP
// License    : <License type>
/*****************************************************************************/
// File        : pmu_pi.c
// Author      : Pablo Criado Albillos; pablo.criado@bsc.es
// Company     : Barcelona Supercomputing Center (BSC)
// Created     : 10/08/2021
// Last update : 10/08/2021
/*****************************************************************************/
// Description: PMU Demo to demonstrate the usage of the library with a complex algorithm
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

// Random computationally-intensive algorithm
void pi(int n)
{
    int r[n + 1];
    int i, k;
    int b, d;
    int c = 0;

    for (i = 0; i < n; i++)
    {
        r[i] = 2000;
    }

    for (k = n; k > 0; k -= 14)
    {
        d = 0;

        i = k;
        for (;;)
        {
            d += r[i] * 10000;
            b = 2 * i - 1;

            r[i] = d % b;
            d /= b;
            i--;
            if (i == 0)
                break;
            d *= i;
        }
        printf("%.4d", c + d / 10000);
        c = d % 10000;
    }

    printf("\n");
}

int main(int argc, char **argv)
{
    printf("PMU PI demo\n");
    // Get Tile ID
    char cid = argv[0][0];
    // Initialize profiling
    init_profiling(cid);

    // Do calculations
    pi(100);

    // Stop profiling
    stop_profiling(cid);
    // Print summary for last iteration
    print_summary(cid);

    return 0;
}