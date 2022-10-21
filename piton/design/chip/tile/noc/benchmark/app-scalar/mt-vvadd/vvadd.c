// See LICENSE for license details.

#include "stdlib.h"
#include "dataset.h"

//--------------------------------------------------------------------------
// vvadd function

void __attribute__((noinline)) vvadd(int coreid, int ncores, size_t lda, const data_t* x, const data_t* y, data_t* z)
{
  
  size_t i, k, block, start, end;
      
      block = lda / ncores;
    if ((block*ncores) != lda) block++;
    start = block * coreid;
    end   = start + block;
     if (end > lda) end = lda;
     
       for (i = start; i < end; i++) {
      z[i] = x[i] + y[i];
   }
}
