
#include "dataset.h"
#include "util.h"
#include <stddef.h>



/*
void axpy_block(double *x, double *y, double alpha, long N) {
     for (long i=0; i < N; ++i) {
             y[i] += alpha * x[i];
     }
}
*/


void axpy(const size_t coreid, const size_t ncores,const size_t lda , data_t A[], data_t B[], data_t alpha ){

    size_t i, k, block, start, end;
       
    block = lda / ncores;
    if ((block*ncores) != lda) block++;
    start = block * coreid;
    end   = start + block;
    if (end > lda) end = lda;
      
        for (i = start; i < end; i++) {
                 A[i] += alpha * B[i];
     }
}





