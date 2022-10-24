// See LICENSE for license details.

//**************************************************************************
// Vector-vector add benchmark
//--------------------------------------------------------------------------
// Author  : Andrew Waterman
// TA      : Christopher Celio
// Student : 
//
// This benchmark adds two vectors and writes the results to a
// third vector. The input data (and reference data) should be
// generated using the vvadd_gendata.pl perl script and dumped
// to a file named dataset.h 

//--------------------------------------------------------------------------
// Includes 

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "custom_def.h"

//--------------------------------------------------------------------------
// Input/Reference Data

#include "dataset.h"
 
  
//--------------------------------------------------------------------------
// Basic Utilities and Multi-thread Support

#include "util.h"
   
 
//--------------------------------------------------------------------------
// vvadd function

extern void __attribute__((noinline)) vvadd(int coreid, int ncores, size_t n, const data_t* x, const data_t* y, data_t* z);



#ifdef VERYFY_RESULT
    #include "double_cmp.h"
    extern int   mt_verify(const size_t coreid, const size_t ncores,const size_t lda , double* test,   double* verify );
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
    

   if(cid==0) {printf("We are %d cores.\n",nc);}


   // static allocates data in the binary, which is visible to both threads
   static data_t results_data[DATA_SIZE];
   
   // First do out-of-place vvadd
   BARRIER();
   STATS(vvadd(cid, nc, DATA_SIZE, input1_data, input2_data, results_data); BARRIER(), DATA_SIZE);
 
   #ifdef VERYFY_RESULT
   int res = mt_verify(cid,nc,DATA_SIZE , results_data, verify_data);
   if(res){
    printf("Verrification failed!\n");
    exit(res);  
    }
   #endif
   
   BARRIER();

   // Second do in-place vvadd
   // Copying input
   size_t i;
   if(cid == 0) {
     for (i = 0; i < DATA_SIZE; i++)
           results_data[i] = input1_data[i];
   }
   BARRIER();   
   STATS(vvadd(cid, nc, DATA_SIZE, results_data, input2_data, results_data); BARRIER(), DATA_SIZE);
 
   #ifdef VERYFY_RESULT
   res = mt_verify(cid,nc,DATA_SIZE , results_data, verify_data);
   if(res){
    printf("Verrification failed!\n");
    exit(res);  
    }
   #endif
   
   BARRIER();
   
  
   
   exit(0);
}
