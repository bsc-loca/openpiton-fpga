#include "dataset.h"
#include "util.h"
#include <stddef.h>



void SpMV(const size_t coreid, const size_t ncores,const size_t nrows, double *a, long *ia, long *ja, double *x, double *y  ) {
 
 
  size_t block, start, end;
  block = nrows / ncores;
  if ((block*ncores) != nrows) block++;
  start = block * coreid;
  end   = start + block;
  if (end > nrows) end = nrows;
 
 
  int row, idx;
  for (row = start; row < end; row++) {
    double sum = 0.0;
    for (idx = ia[row]; idx < ia[row + 1]; idx++) {
      sum += a[idx] * x[ja[idx]];
    }
    y[row] = sum;
  }
}



