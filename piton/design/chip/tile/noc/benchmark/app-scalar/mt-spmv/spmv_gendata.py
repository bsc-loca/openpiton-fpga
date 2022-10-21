#!/usr/bin/env python

#pip install scipy

import sys
from scipy.sparse import rand
import re



def init_vector(n, value):
    vector_str="\t"
    c=0
    for i in range(n):
            vector_str+=str(value)+", "
            if(c==19):
                vector_str+="\n\t"
                c=0
            else:
                c=c+1
                
    print(vector_str[0:-2])

def print_csr_array(a):
    string="\t"
    print(type(a))
    for v in a:
        string=str(v)+", "

    print(string[:-1])

N_ROWS=int(sys.argv[1])
NON_ZERO_PER_ROW=int(sys.argv[2])

print("\n#ifndef __DATASET_H")
print("#define __DATASET_H\n")

print("#define N_ROWS "+str(N_ROWS))
print("#define NON_ZERO_PER_ROW "+str(NON_ZERO_PER_ROW))

d=float(NON_ZERO_PER_ROW)/float(N_ROWS) #Assuming square matrix

print("#define Density "+str(d))

matrix=rand(N_ROWS, N_ROWS, density=d, format='csr')

#print(matrix.todense())

print("#define N_NON_ZERO "+str(matrix.nnz)+"\n")

print("static long ia[N_ROWS+1]  = \n{")
print("\t"+str(matrix.indptr.tolist())[1:-1])
print("};\n")

print("static long ja[N_NON_ZERO]  = \n{")
print("\t"+str(matrix.indices.tolist())[1:-1])
print("};\n")

print("static double a[N_NON_ZERO]  = \n{")
print("\t"+str(matrix.data.tolist())[1:-1])
print("};\n")

print("static double x[N_ROWS] = \n{")
init_vector(int(N_ROWS),13)
print("};\n")

print("#endif //__DATASET_H")


