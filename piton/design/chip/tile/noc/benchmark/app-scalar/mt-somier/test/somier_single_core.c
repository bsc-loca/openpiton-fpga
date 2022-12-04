#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <inttypes.h>
#include <errno.h>
#include <assert.h>
#include "somier_single_core.h"
#include "../dataset.h"


void init_X_single (int n, double (*X)[n][n][n])
{
   int i, j, k;

   Xcenter[0]=0, Xcenter[1]=0; Xcenter[2]=0;

   for (i = 0; i<n; i++)
      for (j = 0; j<n; j++)
         for (k = 0; k<n; k++) {
           X[0][i][j][k] = i;
           X[1][i][j][k] = j;
           X[2][i][j][k] = k; 

       Xcenter[0] += X[0][i][j][k];
           Xcenter[1] += X[1][i][j][k];
           Xcenter[2] += X[2][i][j][k];
       }

    Xcenter[0] /= (n*n*n);
    Xcenter[1] /= (n*n*n);
    Xcenter[2] /= (n*n*n);



//   X[n/2][n/2][n/2][0] += 0.5; X[n/2][n/2][n/2][1] += 0.5; X[n/2][n/2][n/2][2] += 0.5; 
//   X[n/2][n/2][n/2][0] += 0.5; X[n/2][n/2][n/2][1] += 0.5; 
//   X[n/2][n/2][n/2][0] += 0.5;  
}

//make sure the boundary nodes are fixed

void boundary_single(int n, double (*X)[n][n][n], double (*V)[n][n][n])
{
   int i, j, k;
   i = 0;
   for (j = 0; j<n; j++) {
      for (k = 0; k<n; k++) {
         X[0][i][j][k] = i;   X[1][i][j][k] = j;   X[2][i][j][k] = k; 
         V[0][i][j][k] = 0.0; V[1][i][j][k] = 0.0; V[2][i][j][k] = 0.0; 
      }
   }
   j = 0;
   for (i = 0; i<n; i++) {
      for (k = 0; k<n; k++) {
         X[0][i][j][k] = i;   X[1][i][j][k] = j;   X[2][i][j][k] = k; 
         V[0][i][j][k] = 0.0; V[1][i][j][k] = 0.0; V[2][i][j][k] = 0.0; 
      }
   }
   k = 0;
   for (i = 0; i<n; i++) {
      for (j = 0; j<n; j++) {
         X[0][i][j][k] = i;   X[1][i][j][k] = j;   X[2][i][j][k] = k; 
         V[0][i][j][k] = 0.0; V[1][i][j][k] = 0.0; V[2][i][j][k] = 0.0; 
      }
   }
   k = n-1;
   for (i = 0; i<n; i++) {
      for (j = 0; j<n; j++) {
         X[0][i][j][k] = i;   X[1][i][j][k] = j;   X[2][i][j][k] = k; 
         V[0][i][j][k] = 0.0; V[1][i][j][k] = 0.0; V[2][i][j][k] = 0.0; 
      }
   }
   i = n-1;
   for (j = 0; j<n; j++) {
      for (k = 0; k<n; k++) {
         X[0][i][j][k] = i;   X[1][i][j][k] = j;   X[2][i][j][k] = k; 
         V[0][i][j][k] = 0.0; V[1][i][j][k] = 0.0; V[2][i][j][k] = 0.0; 
      }
   }
   j = n-1;
   for (i = 0; i<n; i++) {
      for (k = 0; k<n; k++) {
         X[0][i][j][k] = i;   X[1][i][j][k] = j;   X[2][i][j][k] = k; 
         V[0][i][j][k] = 0.0; V[1][i][j][k] = 0.0; V[2][i][j][k] = 0.0; 
      }
   }
}


inline void acceleration_single(int n, double (*A)[n][n][n], double (*F)[n][n][n], double M)
{
   int i, j, k;
//#dear compiler: please fuse next two loops if you can 
   for (i = 0; i<n; i++)
      for (j = 0; j<n; j++)
         for (k = 0; k<n; k++) {
            A[0][i][j][k]= F[0][i][j][k]/M;
            A[1][i][j][k]= F[1][i][j][k]/M;
            A[2][i][j][k]= F[2][i][j][k]/M;
     }

}


inline void velocities_single(int n, double (*V)[n][n][n], double (*A)[n][n][n], double dt)
{
   int i, j, k;
//#dear compiler: please fuse next two loops if you can 
   for (i = 0; i<n; i++)
//      #pragma omp task
//      #pragma omp unroll
      for (j = 0; j<n; j++) {
     #pragma omp simd
         for (k = 0; k<n; k++) {
               V[0][i][j][k] += A[0][i][j][k]*dt;
               V[1][i][j][k] += A[1][i][j][k]*dt;
               V[2][i][j][k] += A[2][i][j][k]*dt;
            }
     }
}

void positions_single(int n, double (*X)[n][n][n], double (*V)[n][n][n], double dt)
{
   int i, j, k;
//#dear compiler: please fuse next two loops if you can 
   for (i = 0; i<n; i++)
      for (j = 0; j<n; j++)
         for (k = 0; k<n; k++) {
               X[0][i][j][k] += V[0][i][j][k]*dt;
               X[1][i][j][k] += V[1][i][j][k]*dt;
               X[2][i][j][k] += V[2][i][j][k]*dt;
            }
}

void compute_stats_single(int n, double (*X)[n][n][n], double Xcenter[3])
{
   for (int i = 0; i<n; i++) {
      for (int j = 0; j<n; j++) {
         for (int k = 0; k<n; k++) {
             Xcenter[0] += X[0][i][j][k];
             Xcenter[1] += X[1][i][j][k];
             Xcenter[2] += X[2][i][j][k];
         }
      }
   }
   Xcenter[0] /= (n*n*n);
   Xcenter[1] /= (n*n*n);
   Xcenter[2] /= (n*n*n);
}




void force_contribution_single(int n, double (*X)[n][n][n], double (*F)[n][n][n],
                   int i, int j, int k, int neig_i, int neig_j, int neig_k)
{
   double dx, dy, dz, dl, spring_F, FX, FY,FZ;

   assert (i >= 1); assert (j >= 1); assert (k >= 1);
   assert (i <  n-1); assert (j <  n-1); assert (k <  n-1);
   assert (neig_i >= 0); assert (neig_j >= 0); assert (neig_k >= 0);
   assert (neig_i <  n); assert (neig_j <  n); assert (neig_k <  n);

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

void compute_forces_single(int n, double (*X)[n][n][n], double (*F)[n][n][n])
{
   for (int i=1; i<n-1; i++) {
      for (int j=1; j<n-1; j++) {
         for (int k=1; k<n-1; k++) {
            force_contribution_single (n, X, F, i, j, k, i-1, j,   k);
            force_contribution_single (n, X, F, i, j, k, i+1, j,   k);
            force_contribution_single (n, X, F, i, j, k, i,   j-1, k);
            force_contribution_single (n, X, F, i, j, k, i,   j+1, k);
            force_contribution_single (n, X, F, i, j, k, i,   j,   k-1);
            force_contribution_single (n, X, F, i, j, k, i,   j,   k+1);
         }
      }
   }
}





