// See LICENSE for license details.

//**************************************************************************
// Multi-threaded axpy benchmark
//--------------------------------------------------------------------------
// 
//  
//
//
// This benchmark This benchmark runs several AXPY operations in parallle. AXPY is a Level 1 operation in the
// Basic Linear Algebra Subprograms (BLAS) package, and is a common operation in
//computations with vector processors. AXPY is a combination of scalar
//multiplication and vector addition. The input data (and reference data) should be generated
// using the axpy_gendata.pl perl script 

//--------------------------------------------------------------------------
// Includes 

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stddef.h>
#include "custom_def.h"


//--------------------------------------------------------------------------
// Input/Reference Data

#include "dataset.h"
 

//--------------------------------------------------------------------------
// Basic Utilities and Multi-thread Support

#include "util.h"


//--------------------------------------------------------------------------
// axpy function
 
extern void __attribute__((noinline)) SpMV(const size_t coreid, const size_t ncores,const size_t nrows, double *a, long *ia, long *ja, double *x, double *y  );

#ifdef VERYFY_RESULT
    #include "double_cmp.h"
    extern int  __attribute__((noinline)) mt_verify(const size_t coreid, const size_t ncores,const size_t lda , double* test,   double* verify );
#endif





//--------------------------------------------------------------------------
// Main
//
// all threads start executing thread_entry(). Use their "coreid" to
// differentiate between threads (each thread is running on a separate core).
  
//void thread_entry(int cid, int nc){
//int main(int argc, char** argv) {

  // uint32_t cid, nc;
  // cid = argv[0][0];
  // nc = argv[0][1];
  
int MAIN(){  
   INIT_CID();  
  
   double y[N_ROWS];
   if(cid==0) {printf("We are %d cores.\n",nc);}   
   BARRIER();
   STATS(SpMV(cid,nc,N_ROWS,a,ia,ja,x,y);BARRIER(),N_ROWS);
   BARRIER();
   #ifdef VERYFY_RESULT
   int res = mt_verify(cid,nc,N_ROWS , y, y_ref);
   if(res) exit(res);  
   BARRIER();
   #endif
   
   exit(0);  
   
   
   
}
