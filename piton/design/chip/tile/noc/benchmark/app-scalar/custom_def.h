#ifndef __CUSTOM_DEF_H
#define __CUSTOM_DEF_H

     #ifdef ARIANE_TILE

          #define BARRIER()   barrier(nc)
          #define MAIN()      main(int argc, char** argv)  
             #define INIT_CID()      uint32_t cid, nc; \
                  cid = argv[0][0]; \
                  nc = argv[0][1]; \
          
     #else //coyote

         #ifdef LAGARTO_TILE
            #define BARRIER()   barrier(nc)
              #define MAIN()      main(int argc, char** argv)  
            #define INIT_CID()      uint32_t cid, nc; \
                 cid = argv[0][0]; \
                 nc = argv[0][1]; \
        
        
         #else
         
          #define BARRIER()   simfence()
          #define MAIN()      thread_entry(int cid, int nc) 
          #define INIT_CID()
          
        #endif
          
     #endif
     
#endif

