#include <stdio.h>
#include <stdlib.h>
#include "../spmv.c"
#include "../../double_cmp.h"




#define ncores 64

int main (){
    double y[N_ROWS];
    for (int coreid=0; coreid < ncores; coreid++){
        SpMV(coreid, ncores, N_ROWS, a, ia, ja, x, y  );
    }
    int r= verify_Double(N_ROWS,   y,   y_ref);
    if (r!=0) printf("failed!\n");
    else printf("passed!\n");
    exit (r);
}
