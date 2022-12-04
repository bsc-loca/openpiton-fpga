#ifndef __CUSTOM_DEF_H
#define __CUSTOM_DEF_H

	#define  VERYFY_RESULT
	#define  REPORT_L2_STATICS


     #ifdef ARIANE_TILE //Ariane
     	#include "all_stats.h"
     	
     	  #ifdef REPORT_L2_STATICS
     	  	#define STATS     all_stats
     	  #else 
     	  	#define STATS     stats
     	  #endif // REPORT_L2_STATICS
     

          #define BARRIER()   barrier(nc)
          #define MAIN()      main(int argc, char** argv)  
             #define INIT_CID()      uint32_t cid, nc; \
                  cid = argv[0][0]; \
                  nc = argv[0][1]; \
          
     #else 

         #ifdef LAGARTO_TILE //Lagarto
			#include "all_stats.h"
            #define BARRIER()   barrier(nc)
              #define MAIN()      main(int argc, char** argv)  
            #define INIT_CID()      uint32_t cid, nc; \
                 cid = argv[0][0]; \
                 nc = argv[0][1]; \
            
        	#ifdef REPORT_L2_STATICS
     	  		#define STATS     all_stats
     	  	#else 
     	  		#define STATS     stats
     	  	#endif // REPORT_L2_STATICS
         
         #else //coyote
         
          #define BARRIER()   simfence()
          #define MAIN()      thread_entry(int cid, int nc) 
          #define INIT_CID()
          #define STATS     stats
          
        #endif
          
     #endif
     
#endif

