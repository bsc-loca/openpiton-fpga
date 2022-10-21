// See LICENSE for license details.

//**************************************************************************
// Multi-threaded somier benchmark
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
// Includes 

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stddef.h>
#include "custom_def.h"


//--------------------------------------------------------------------------
// Input/Reference Data

int err;




#include "dataset.h"
#include "somier.h"

//--------------------------------------------------------------------------
// Basic Utilities and Multi-thread Support

#include "util.h"

 //#define  VERYFY_RESULT  
//--------------------------------------------------------------------------
// axpy function
 
#define VERYFY_RESULT


#ifdef VERYFY_RESULT
    #include "double_cmp.h"
    extern int  __attribute__((noinline)) mt_verify(const size_t coreid, const size_t ncores,const size_t lda , double* test,   double* verify );
#endif



void somier_scalar (int cid, int nc) {
    
    compute_forces(cid, nc, N, X, F);
    BARRIER();
 
    acceleration(cid, nc, N, A, F, M);
    BARRIER();
    
    velocities(cid, nc, N, V, A, dt);
    BARRIER();
    
    positions(cid, nc, N, X, V, dt);
    BARRIER();
    
    compute_stats_pre(cid, nc, N, X);
    BARRIER();
    
    compute_stats(cid, nc, N, X, Xcenter);
    BARRIER();
}



void print_duble (double f,char * u){
    int t =  f;
    float t2 = (f*1000)-(t*1000);    
    int t1 = t2;
    printf("%u.%u%s",t,t1,u);    
}


  
int MAIN(){  
   INIT_CID();
     
   if(nc> PITON_NUMTILES)    nc =  PITON_NUMTILES;  
       
   
   if(cid<nc) init_forloop_boundries (cid,nc, N);   
   
   if(cid==0) {
       printf("We are %d cores.\n",nc);
       Xcenter[0]=0, Xcenter[1]=0; Xcenter[2]=0;      
       
   }   
   BARRIER();
   stats(somier_scalar(cid,nc);BARRIER(),N);
   BARRIER();
 
#ifdef VERYFY_RESULT   
	if(cid==0) { 
		int res =	verify_Double(3,   Xcenter,   Xcenter_ref);
		if(res){
		    printf("Verrification failed!\n");
    		exit(res);  
    	}	
	}
	BARRIER();
#endif            
    
    
   exit(0);    
   
   
}
