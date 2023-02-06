#include "math.h"
#include <stdio.h>
#include <stdlib.h>
#include "double_cmp.h"



int err;


void print_duble (double f,char * u){
    int t =  f;
    float t2 = (f*1000)-(t*1000);    
    int t1 = t2;
    printf("%u.%u%s",t,t1,u);    
}


#define PITON_NUMTILES 64

#include "../dataset.h"
#include "somier_single_core.c"
#include "../somier.c"



#define ncores PITON_NUMTILES


void print_array ( int n, double (*F)[n][n][n]){
 	for (int i = 0; i<n; i++)
		for (int j = 0; j<n; j++)
           for (int k = 0; k<n; k++) 
           	   print_duble(F[0][i][j][k],",");   	
	
}


void somier_scalar_single (void) {
    compute_forces_single(N, X, F);
    
   // print_array(N,F);
    
    acceleration_single(N, A, F, M);
    
    // print_array(N,F);
    
    velocities_single(N, V, A, dt); 
      
   // print_array(N,V);
     
    positions_single(N, X, V, dt);
    
 //      print_array(N,X);
    
    compute_stats_single(N, X, Xcenter);    
}



void somier_scalar ( int nc) {    
   for(int cid=0;cid<ncores;cid++)   compute_forces(cid, nc, N, X, F);
   
  // print_array(N,F);
   
   for(int cid=0;cid<ncores;cid++)   acceleration(cid, nc, N, A, F, M);
   
 //    print_array(N,F);
   
   for(int cid=0;cid<ncores;cid++)   velocities(cid, nc, N, V, A, dt);
   
  //  print_array(N,V);
   
   for(int cid=0;cid<ncores;cid++)   positions(cid, nc, N, X, V, dt);
   
  //  print_array(N,X);
   
   for(int cid=0;cid<ncores;cid++)   compute_stats_pre(cid, nc, N, X);
   for(int cid=0;cid<ncores;cid++)   compute_stats(cid, nc, N, X, Xcenter);
}





int main (){
    // run somier single core
    Xcenter[0] = 0;
    Xcenter[1] = 0;
    Xcenter[2] = 0;
    
    
    
   // somier_scalar_single();
    
    printf ("\tXcenter=");
    print_duble(Xcenter[0],","),print_duble(Xcenter[1],","),print_duble(Xcenter[2],"\n");     
    
    
    printf ("\tV=");
    print_duble(V[0][N/2][N/2][N/2],","),print_duble(V[1][N/2][N/2][N/2],","),print_duble(V[2][N/2][N/2][N/2],"\t\t X= "), 
            print_duble(X[0][N/2][N/2][N/2],","), print_duble(X[1][N/2][N/2][N/2],","), print_duble(X[2][N/2][N/2][N/2],"\n");   
            
    Xcenter[0] = 0;
    Xcenter[1] = 0;
    Xcenter[2] = 0;        
      
      
    for(int cid=0;cid<ncores;cid++) init_forloop_boundries (cid,ncores, N);
    somier_scalar(ncores);        
            
    //printf ("\tV= %f, %f, %f\t\t X= %f, %f, %f\n",
    //    V[0][N/2][N/2][N/2], V[1][N/2][N/2][N/2], V[2][N/2][N/2][N/2], 
     //       X[0][N/2][N/2][N/2], X[1][N/2][N/2][N/2], X[2][N/2][N/2][N/2]);
    printf ("\tV=");
    print_duble(V[0][N/2][N/2][N/2],","),print_duble(V[1][N/2][N/2][N/2],","),print_duble(V[2][N/2][N/2][N/2],"\t\t X= "), 
            print_duble(X[0][N/2][N/2][N/2],","), print_duble(X[1][N/2][N/2][N/2],","), print_duble(X[2][N/2][N/2][N/2],"\n");     
            
    printf ("\tXcenter=");
    print_duble(Xcenter[0],","),print_duble(Xcenter[1],","),print_duble(Xcenter[2],"\n");            
                    
            
}

