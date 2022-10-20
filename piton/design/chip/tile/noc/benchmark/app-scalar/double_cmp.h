
#ifndef __DOUBLE_CMP_H
#define __DOUBLE_CMP_H

int compare_double(double f1, double f2)
 {
  double precision = 0.000001;
  if (((f1 - precision) < f2) &&  ((f1 + precision) > f2)) return 1;
  return 0;  
 }


int verify_Double(int n,   double* test,   double* verify)
{
  int i;
  for (i = 0; i < n; i++)
  {
    if( !compare_double(test[i],verify[i])){
      printf("Error: n=%u,%f!=%f\n",i,test[i],verify[i]);
      return i+1;
    }
  }
    return 0;
}


int mt_verify(const size_t coreid, const size_t ncores,const size_t lda , double* test,   double* verify ){

    size_t i, k, block, start, end;
      block = lda / ncores;
    if ((block*ncores) != lda) block++;
    start = block * coreid;
    end   = start + block;
     if (end > lda) end = lda;
    if (start> lda) return 0; 
    return verify_Double(end-start, test + start,  verify+ start);
}

#endif
