#include <errno.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <inttypes.h>

//#include <assert.h>
#include "dataset.h"

#include "somier.h"


int * __errno (void ){
    return &errno;
}


#define FOR_BLOCK_PER_CORE if(cid>=nc) return; \
    size_t i,j,k; \
    i=start_i [cid]; \
    j=start_j [cid]; \
    k=start_k [cid]; \
    for (int m = start [cid]; m < end[cid]; m++) 

#define UPDATE_IJK(n) k++; if(k==n) {k=0;  j++; if (j==n){ j=0; i++;}}



static size_t start   [PITON_NUMTILES];
static size_t end     [PITON_NUMTILES];
static size_t start_i [PITON_NUMTILES];
static size_t start_j [PITON_NUMTILES];
static size_t start_k [PITON_NUMTILES];    


void init_forloop_boundries (int cid,int nc, int dim ){
    
    size_t total, block;

    
    total = dim*dim*dim;
    block = (total/nc);
    if ((block*nc) != total) block++;
    start [cid] = block * cid; 
    end   [cid] = start [cid] + block; 
     if (end [cid] > total) end [cid] = total; 
    start_i [cid] = start [cid] / (dim*dim);
    start_j [cid] = (start [cid] % (dim*dim))/dim;
    start_k [cid] = start [cid] % dim;
        
    
//    printf("boundry for cid=%u:\n\ttotal=%lu\n,\t block=%lu\n,\tstart=%lu\n,\tend=%lu\n,\tstart_i=%lu\n,\tstart_j=%lu\n,\tstart_k=%lu\n",cid,total, block,start[cid],end[cid],start_i[cid],start_j[cid], start_k[cid]);        
    

}




inline void acceleration(int cid, int nc, int n, double (*A)[n][n][n], double (*F)[n][n][n], double M)
{
  // int i, j, k;
//#dear compiler: please fuse next two loops if you can 
  // for (i = 0; i<n; i++)
  //     for (j = 0; j<n; j++)
  //       for (k = 0; k<n; k++) {
  FOR_BLOCK_PER_CORE {
            A[0][i][j][k]= F[0][i][j][k]/M;
            A[1][i][j][k]= F[1][i][j][k]/M;
            A[2][i][j][k]= F[2][i][j][k]/M;
              UPDATE_IJK(n)
  }

}


inline void velocities(int cid, int nc, int n, double (*V)[n][n][n], double (*A)[n][n][n], double dt)
{
  // int i, j, k;
//#dear compiler: please fuse next two loops if you can 
//  for (i = 0; i<n; i++)
//      #pragma omp task
//      #pragma omp unroll
//      for (j = 0; j<n; j++) {
//     #pragma omp simd
//         for (k = 0; k<n; k++) {
    FOR_BLOCK_PER_CORE {

               V[0][i][j][k] += A[0][i][j][k]*dt;
               V[1][i][j][k] += A[1][i][j][k]*dt;
               V[2][i][j][k] += A[2][i][j][k]*dt;
               UPDATE_IJK(n)
//            }
     }
}

void positions(int cid, int nc, int n, double (*X)[n][n][n], double (*V)[n][n][n], double dt)
{
   //int i, j, k;
//#dear compiler: please fuse next two loops if you can 
  // for (i = 0; i<n; i++)
  //    for (j = 0; j<n; j++)
  //       for (k = 0; k<n; k++) {
   FOR_BLOCK_PER_CORE {
               X[0][i][j][k] += V[0][i][j][k]*dt;
               X[1][i][j][k] += V[1][i][j][k]*dt;
               X[2][i][j][k] += V[2][i][j][k]*dt;
               UPDATE_IJK(n)
            }
}

void compute_stats_pre(int cid, int nc, int n, double (*X)[n][n][n])
{
   //for (int i = 0; i<n; i++) {
   //   for (int j = 0; j<n; j++) {
   //      for (int k = 0; k<n; k++) {   
   Xcenter_sub0[cid] = 0;
   Xcenter_sub1[cid] = 0;
   Xcenter_sub2[cid] = 0;       
  
  
   FOR_BLOCK_PER_CORE {
             Xcenter_sub0[cid] += X[0][i][j][k];
             Xcenter_sub1[cid] += X[1][i][j][k];
             Xcenter_sub2[cid] += X[2][i][j][k];   
             UPDATE_IJK(n)     
  //       }
  //    }
   }
  // Xcenter[0] /= (n*n*n);
  // Xcenter[1] /= (n*n*n);
  // Xcenter[2] /= (n*n*n);
}

void compute_stats(int cid, int nc, int n, double (*X)[n][n][n], double Xcenter[3])
{
    
   if(cid == 0){
       for (int i = 0; i<nc; i++) {
           Xcenter[0] += Xcenter_sub0[i];
           Xcenter[1] += Xcenter_sub1[i];
           Xcenter[2] += Xcenter_sub2[i];       
       }
       Xcenter[0] /= (n*n*n);
       Xcenter[1] /= (n*n*n);
       Xcenter[2] /= (n*n*n);
   }
}




void force_contribution(int cid, int nc, int n, double (*X)[n][n][n], double (*F)[n][n][n],
                   int i, int j, int k, int neig_i, int neig_j, int neig_k)
{
   double dx, dy, dz, dl, spring_F, FX, FY,FZ;

 //   assert (i >= 1); assert (j >= 1); assert (k >= 1);
 //   assert (i <  n-1); assert (j <  n-1); assert (k <  n-1);
 //   assert (neig_i >= 0); assert (neig_j >= 0); assert (neig_k >= 0);
 //  assert (neig_i <  n); assert (neig_j <  n); assert (neig_k <  n);

   dx=X[0][neig_i][neig_j][neig_k]-X[0][i][j][k];
   dy=X[1][neig_i][neig_j][neig_k]-X[1][i][j][k];
   dz=X[2][neig_i][neig_j][neig_k]-X[2][i][j][k];
   dl = sqrt(dx*dx + dy*dy + dz*dz);
   spring_F = 0.25 * spring_K*(dl-1);
   FX = spring_F * dx/dl; 
   FY = spring_F * dy/dl;
   FZ = spring_F * dz/dl; 
   F[0][i][j][k] += FX;
   F[1][i][j][k] += FY;
   F[2][i][j][k] += FZ;
}

void compute_forces(int cid, int nc, int n, double (*X)[n][n][n], double (*F)[n][n][n])
{
  // for (int i=1; i<n-1; i++) {&&  j!=0 && k!=0
  //   for (int j=1; j<n-1; j++) {
  //     for (int k=1; k<n-1; k++) {
  FOR_BLOCK_PER_CORE {
    if(i!=0 &&  j!=0 && k!=0 && i!=n-1 &&  j!=n-1 && k!=n-1 ) {
        //printf("i=%u,j=%u,k=%u\n",i,j,k);
            force_contribution (cid, nc, n, X, F, i, j, k, i-1, j,   k);
            force_contribution (cid, nc, n, X, F, i, j, k, i+1, j,   k);
            force_contribution (cid, nc, n, X, F, i, j, k, i,   j-1, k);
            force_contribution (cid, nc, n, X, F, i, j, k, i,   j+1, k);
            force_contribution (cid, nc, n, X, F, i, j, k, i,   j,   k-1);
            force_contribution (cid, nc, n, X, F, i, j, k, i,   j,   k+1);
         }
         UPDATE_IJK(n)
        // }
     // }
   }
}




