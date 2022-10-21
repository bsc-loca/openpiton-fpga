// See LICENSE for license details.

//**************************************************************************
// Multi-threaded Matrix Multiply benchmark
//--------------------------------------------------------------------------
// TA     : Christopher Celio
// Student: 
//
//
// This benchmark multiplies two 2-D arrays together and writes the results to
// a third vector. The input data (and reference data) should be generated
// using the matmul_gendata.pl perl script and dumped to a file named
// dataset.h. 

//--------------------------------------------------------------------------
// Includes 

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stddef.h>
#include "custom_def.h"

#define PITON_TEST_GOOD_END 0x8100000000ULL
//--------------------------------------------------------------------------
// Input/Reference Data

#include "dataset.h"
 

//--------------------------------------------------------------------------
// Basic Utilities and Multi-thread Support

#include "util.h"

 #define  VERYFY_RESULT  
   
//--------------------------------------------------------------------------
// matmul function
 
extern void __attribute__((noinline)) matmul(const size_t coreid, const size_t ncores, const size_t lda,  const data_t A[], const data_t B[], data_t C[] );


//--------------------------------------------------------------------------
// Main
//
// all threads start executing thread_entry(). Use their "coreid" to
// differentiate between threads (each thread is running on a separate core).
  
//void thread_entry(int cid, int nc)
//{

//void thread_entry(int cid, int nc){
//int main(int argc, char** argv) {

//   uint32_t cid, nc;
  // cid = argv[0][0];
  // nc = argv[0][1];
  
int MAIN(){  
   INIT_CID();
  
   static data_t results_data[ARRAY_SIZE];   
   if(cid==0) {printf("We are %d cores.\n",nc);}   
   BARRIER();   
   stats(matmul(cid, nc, DIM_SIZE, input1_data, input2_data, results_data); BARRIER(), DIM_SIZE/DIM_SIZE/DIM_SIZE);
   BARRIER();
   #ifdef VERYFY_RESULT
   int res = verify(ARRAY_SIZE , results_data, verify_data);
   if(res) exit(res);  
   BARRIER();
   #endif   
   exit(0);   
}
