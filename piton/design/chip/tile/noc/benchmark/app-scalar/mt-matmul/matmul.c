// See LICENSE for license details.

#include "dataset.h"
#include "util.h"
#include <stddef.h>

//#pragma GCC optimize ("unroll-loops")

void matmul(const size_t coreid, const size_t ncores, const size_t lda,  const data_t A[], const data_t B[], data_t C[])
{
   size_t i, j, k;
   size_t  block, start, end;
      
   block = lda / ncores;
   if ((block*ncores) != lda) block++;
   start = block * coreid;
   end   = start + block;
   if (end > lda) end = lda;
  
 
   for ( j = start; j < end; j++ ) {
      for ( k = 0; k < lda; k++ )  {
         for ( i = 0; i < lda; i++ ) {
            C[i + j*lda] += A[j*lda + k] * B[k*lda + i];
         }
      }
   }
}
