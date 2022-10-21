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

 #define  VERYFY_RESULT  
//--------------------------------------------------------------------------
// axpy function
 
extern void __attribute__((noinline)) axpy(const size_t coreid, const size_t ncores,const size_t lda , data_t A[], data_t B[], data_t alpha );

#ifdef VERYFY_RESULT
    #include "double_cmp.h"
    extern int   mt_verify(const size_t coreid, const size_t ncores,const size_t lda , double* test,   double* verify );
#endif




//--------------------------------------------------------------------------
// Main
//
// all threads start executing thread_entry(). Use their "coreid" to
// differentiate between threads (each thread is running on a separate core).
  
//int thread_entry(int cid, int nc){
//int main(int argc, char** argv) {

//   uint32_t cid, nc;
//   cid = argv[0][0];
 //  nc = argv[0][1];


int MAIN(){
    INIT_CID();
  
  // if(cid >= nc) exit(0);  
   if(cid==0) {printf("We are %d cores.\n",nc);}  
  
   BARRIER();
  // barrier(nc);
   stats(axpy(cid,nc,ARRAY_SIZE,input1_data,input2_data,Alfa); BARRIER(),ARRAY_SIZE);
  // barrier(nc);
   BARRIER();
   #ifdef VERYFY_RESULT
   int res = mt_verify(cid,nc,ARRAY_SIZE , input1_data, verify_data);
   if(res){
    printf("Verrification failed!\n");
    exit(res);  
    }
  // barrier(nc);
   BARRIER();
   #endif
   
   
    
   
   
   exit(0);  
   
   
   
}
