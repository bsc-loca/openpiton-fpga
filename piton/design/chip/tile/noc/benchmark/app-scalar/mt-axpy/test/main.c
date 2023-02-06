#include <stdio.h>
#include <stdlib.h>
#include "../axpy.c"
#include "double_cmp.h"




#define ncores 4

int main (){
    for (int coreid=0; coreid < ncores; coreid++){
        axpy(coreid,ncores,ARRAY_SIZE,input1_data,input2_data,Alfa);
    }
    int r= verify_Double(ARRAY_SIZE,  input1_data, verify_data );
    if (r!=0) printf("failed!\n");
    else printf("passed!\n");
    exit (r);
}
