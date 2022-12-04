#!/usr/bin/perl -w
#==========================================================================
# somier_gendata.pl
#
# Author : Alireza Monemi
#

(our $usageMsg = <<'ENDMSG') =~ s/^\#//gm;
#
# Simple script which creates an input data set and the reference data
# for the somier benchmark.
#
ENDMSG

use strict "vars";
use warnings;
no  warnings("once");
use Getopt::Long;

#--------------------------------------------------------------------------
# Command line processing
#--------------------------------------------------------------------------

our %opts;

sub usage()
{

  print "\n";
  print " Usage: somier_gendata.pl [options] \n";
  print "\n";
  print " Options:\n";
  print "  --help  print this message\n";
  print "  --size  size of input data [32][32][32]\n";
  print "  --seed  random seed [1]\n";
  print "$usageMsg";

  exit();
}

sub processCommandLine()
{

  $opts{"help"} = 0;
  $opts{"size"} = 32;
  $opts{"seed"} = 1;
  Getopt::Long::GetOptions( \%opts, 'help|?', 'size:i', 'seed:i' ) or usage();
  $opts{"help"} and usage();

}

#--------------------------------------------------------------------------
# Helper Functions
#--------------------------------------------------------------------------
sub range { 0 .. ($_[0] - 1) }


sub printArray
{
  my $arrayName = $_[0];
  my $arrayRef  = $_[1];
  my $type = $_[2];
  my $size = $_[3];
  my $N = $_[4];

  my $numCols = 20;
  my $arrayLen = scalar(@{$arrayRef});


  print "static ".$type." ".$arrayName."[".$size."] __attribute__((aligned (1024))) = \n";
  print "{\n";

  for my $a (range(3)){
    for my $i (range($N)){
      for my $j (range($N)){
        for my $k (range($N)){
            print "  ";
            print sprintf("%3d",$arrayRef->[$a][$i][$j][$k]);
            if($i ne $N-1 or $j ne $N-1 or $k ne $N-1 or $a ne 2)
            {
                print ","
            }
        }
      }
    }
  }

  print  "};\n\n";
}



sub printArray_4D
{
  my $arrayName = $_[0];
  my $arrayRef  = $_[1];
  my $type = $_[2];
  my $size = $_[3];
  my $N = $_[4];

  my $numCols = 20;
  my $arrayLen = scalar(@{$arrayRef});


  print "static ".$type." ".$arrayName."[3][N][N][N] ". "__attribute__((aligned (1024))) = \n";
  print "\{\n";

  for my $a (range(3)){
   print "\{";
    for my $i (range($N)){
      print "\{";
      for my $j (range($N)){
        print "\{";
        for my $k (range($N)){
            print "  ";
            print sprintf("%3d",$arrayRef->[$a][$i][$j][$k]);
            print "," if($k ne $N-1)  ;          
        } #k
        print "\}";
        print "," if($j ne $N-1)  ; 
        print "\n" if($j eq $N-1) ;   
      }#j
       print "\}"; 
       print "," if($i ne $N-1)  ;  
       print "\n" if($i eq $N-1) ; 
    } 
    print "\}";
    print "," if($a ne 2)  ;   
  }

  print  "\};\n\n";
}









#--------------------------------------------------------------------------
# somier scalar
#--------------------------------------------------------------------------



sub acceleration{
	my($n, $A, $F, $M)=@_;
   my ($i, $j, $k);
#dear compiler: please fuse next two loops if you can 
   for ($i = 0; $i<$n; $i++){
      for ($j = 0; $j<$n; $j++){
         for ($k = 0; $k<$n; $k++) {
            $A->[0][$i][$j][$k]= $F->[0][$i][$j][$k] / $M;
            $A->[1][$i][$j][$k]= $F->[1][$i][$j][$k] / $M;
            $A->[2][$i][$j][$k]= $F->[2][$i][$j][$k] / $M;
           
     }}}

}


sub velocities {
   my ($n, $V,$A,$dt)=@_;
   my ( $i, $j, $k);
   #dear compiler: please fuse next two loops if you can 
   for ($i = 0; $i<$n; $i++){
   #pragma omp task
   #pragma omp unroll
      for ($j = 0; $j<$n; $j++) {
     #pragma omp simd
         for ($k = 0; $k<$n; $k++) {
               $V->[0][$i][$j][$k] += $A->[0][$i][$j][$k]*$dt;
               $V->[1][$i][$j][$k] += $A->[1][$i][$j][$k]*$dt;
               $V->[2][$i][$j][$k] += $A->[2][$i][$j][$k]*$dt;
            }
     }
    }
}


sub positions {
	my ($n, $X, $V, $dt)=@_;
    my ($i, $j, $k);
#dear compiler: please fuse next two loops if you can 
   for ($i = 0; $i<$n; $i++){
      for ($j = 0; $j<$n; $j++){
         for ($k = 0; $k<$n; $k++) {
               $X->[0][$i][$j][$k] += $V->[0][$i][$j][$k]*$dt;
               $X->[1][$i][$j][$k] += $V->[1][$i][$j][$k]*$dt;
               $X->[2][$i][$j][$k] += $V->[2][$i][$j][$k]*$dt;
            }}}
}

sub compute_stats {
	my ($n, $X, $Xcenter)=@_;

   for (my $i = 0; $i<$n; $i++) {
      for (my $j = 0; $j<$n; $j++) {
         for (my $k = 0; $k<$n; $k++) {
             $Xcenter->[0] += $X->[0][$i][$j][$k];
             $Xcenter->[1] += $X->[1][$i][$j][$k];
             $Xcenter->[2] += $X->[2][$i][$j][$k];
         }
      }
   }
   $Xcenter->[0] /= ($n*$n*$n);
   $Xcenter->[1] /= ($n*$n*$n);
   $Xcenter->[2] /= ($n*$n*$n);
}




sub force_contribution {
	my ($n, $X, $F, $spring_K, $i, $j, $k, $neig_i, $neig_j, $neig_k)=@_;
	
	my ($dx, $dy, $dz, $dl, $spring_F, $FX, $FY, $FZ);
   

   $dx=$X->[0][$neig_i][$neig_j][$neig_k]-$X->[0][$i][$j][$k];
   $dy=$X->[1][$neig_i][$neig_j][$neig_k]-$X->[1][$i][$j][$k];
   $dz=$X->[2][$neig_i][$neig_j][$neig_k]-$X->[2][$i][$j][$k];
   $dl = sqrt($dx*$dx + $dy*$dy + $dz*$dz);
   $spring_F = 0.25 * $spring_K*($dl-1);
   $FX = $spring_F * $dx/$dl; 
   $FY = $spring_F * $dy/$dl;
   $FZ = $spring_F * $dz/$dl; 
   $F->[0][$i][$j][$k] += $FX;
   $F->[1][$i][$j][$k] += $FY;
   $F->[2][$i][$j][$k] += $FZ;
   return $F;
   
}

sub compute_forces {
	my ($n, $X, $F,$spring_K)=@_;

   for (my $i=1; $i<$n-1; $i++) {
      for (my $j=1; $j<$n-1; $j++) {
         for (my $k=1; $k<$n-1; $k++) {
            $F=force_contribution ($n, $X, $F, $spring_K, $i, $j, $k, $i-1, $j,   $k);
            $F=force_contribution ($n, $X, $F, $spring_K, $i, $j, $k, $i+1, $j,   $k);
            $F=force_contribution ($n, $X, $F, $spring_K, $i, $j, $k, $i,   $j-1, $k);
            $F=force_contribution ($n, $X, $F, $spring_K, $i, $j, $k, $i,   $j+1, $k);
            $F=force_contribution ($n, $X, $F, $spring_K, $i, $j, $k, $i,   $j,   $k-1);
            $F=force_contribution ($n, $X, $F, $spring_K, $i, $j, $k, $i,   $j,   $k+1);
         }
      }
   }
   return $F;
}




sub somier_scalar  {
	my($N ,$X,$F,$A,$V,$dt,$Xcenter, $M,$spring_K )=@_;
    compute_forces($N, $X, $F,$spring_K);
    acceleration($N, $A, $F, $M);
    velocities($N, $V, $A, $dt); 
    positions($N, $X, $V, $dt);
    compute_stats($N, $X, $Xcenter);    
}



#--------------------------------------------------------------------------
# Main
#--------------------------------------------------------------------------

sub main()
{

  processCommandLine();
  srand($opts{"seed"});

	my $dt=0.001;   # 0.1;
	my $spring_K=10.0;
	my $M=1.0;


  # create random input arrays

  my $N=$opts{"size"};
  my $X;
  my $V;
  my $A;
  my $F;
  
  my $Xcenter;
 
  $Xcenter->[0]=0;
  $Xcenter->[1]=0; 
  $Xcenter->[2]=0;

  for my $i (range($N)){
    for my $j (range($N)){
      for my $k (range($N)){
        $X->[0][$i][$j][$k] = int(rand($N));
        $X->[1][$i][$j][$k] = int(rand($N));
        $X->[2][$i][$j][$k] = int(rand($N));
        
	 #   $Xcenter->[0] += $X->[0][$i][$j][$k];
     #   $Xcenter->[1] += $X->[1][$i][$j][$k];
     #   $Xcenter->[2] += $X->[2][$i][$j][$k];

        $V->[0][$i][$j][$k] = int(rand($N));
        $V->[1][$i][$j][$k] = int(rand($N));
        $V->[2][$i][$j][$k] = int(rand($N));
        

        $A->[0][$i][$j][$k] = int(rand($N));
        $A->[1][$i][$j][$k] = int(rand($N));
        $A->[2][$i][$j][$k] = int(rand($N));

        $F->[0][$i][$j][$k] = int(rand($N));
        $F->[1][$i][$j][$k] = int(rand($N));
        $F->[2][$i][$j][$k] = int(rand($N));
      }
    }
  }
 # $Xcenter->[0] /= ($N*$N*$N);
 # $Xcenter->[1] /= ($N*$N*$N);
 # $Xcenter->[2] /= ($N*$N*$N);

  print "\n#ifndef __DATASET_H";
  print "\n#define __DATASET_H";
  print "\n\#define N ".$opts{"size"}." \n\n";
  
  
   print "
#ifndef PITON_NUMTILES
	#define PITON_NUMTILES 1
#endif

static double Xcenter_sub0 [PITON_NUMTILES];
static double Xcenter_sub1 [PITON_NUMTILES];
static double Xcenter_sub2 [PITON_NUMTILES];

static double dt=$dt;
static double spring_K=$spring_K;
static double M=$M;

";
  
   
 
  printArray_4D( "X", $X, "double", "N*N*N*3", $N);
  printArray_4D( "V", $V, "double", "N*N*N*3", $N);
  printArray_4D( "A", $A, "double", "N*N*N*3", $N);
  printArray_4D( "F", $F, "double", "N*N*N*3", $N);
  
  print "static double Xcenter[3] = {".$Xcenter->[0].", ".$Xcenter->[1].", ".$Xcenter->[2]."};\n\n";
  somier_scalar($N ,$X,$F,$A,$V,$dt,$Xcenter,$M,$spring_K );
  
  print "static double Xcenter_ref[3] = {".$Xcenter->[0].", ".$Xcenter->[1].", ".$Xcenter->[2]."};\n\n";
   
  
  print "\n#endif //__DATASET_H";
 
}



main();

