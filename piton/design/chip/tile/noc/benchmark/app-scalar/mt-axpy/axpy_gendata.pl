#!/usr/bin/perl -w
#==========================================================================
# matmul_gendata.pl
#
# Author : Christopher Batten (cbatten@mit.edu)
# Date   : April 29, 2005
#
(our $usageMsg = <<'ENDMSG') =~ s/^\#//gm;
#
# Simple script which creates an input data set and the reference data
# for the axpy benchmark.
#
ENDMSG

use strict "vars";
use warnings;
no  warnings("once");
use Getopt::Long;

#--------------------------------------------------------------------------
# Command line processing
#--------------------------------------------------------------------------
open my $fh, '>', 'dataset.h';
our %opts;

sub usage()
{

  print "\n";
  print " Usage: matmul_gendata.pl [options] \n";
  print "\n";
  print " Options:\n";
  print "  --help  print this message\n";
  print "  --size  size of input data [1000]\n";
  print "  --seed  random seed [1]\n";
  print "$usageMsg";

  exit();
}

sub processCommandLine()
{

  $opts{"help"} = 0;
  $opts{"size"} = 1000;
  $opts{"seed"} = 1;
  Getopt::Long::GetOptions( \%opts, 'help|?', 'size:i', 'seed:i' ) or usage();
  $opts{"help"} and usage();

}

#--------------------------------------------------------------------------
# Helper Functions
#--------------------------------------------------------------------------

sub printArray
{
  my $arrayName = $_[0];
  my $arrayRef  = $_[1];

  my $numCols = 20;
  my $arrayLen = scalar(@{$arrayRef});

  print $fh "static data_t ".$arrayName."[ARRAY_SIZE] = \n";
  print $fh "{\n";

  if ( $arrayLen <= $numCols ) {
    print $fh "  ";
    for ( my $i = 0; $i < $arrayLen; $i++ ) {
      print $fh sprintf("%g",$arrayRef->[$i]);
      if ( $i != $arrayLen-1 ) {
        print $fh ", ";
      }
    }
    print $fh "\n";
  }

  else {
    my $numRows = int($arrayLen/$numCols);
    for ( my $j = 0; $j < $numRows; $j++ ) {
      print $fh "  ";
      for ( my $i = 0; $i < $numCols; $i++ ) {
        my $index = $j*$numCols + $i;
        print $fh sprintf("%g",$arrayRef->[$index]);
        if ( $index != $arrayLen-1 ) {
          print $fh ", ";
        }
      }
      print $fh "\n";
    }

    if ( $arrayLen > ($numRows*$numCols) ) {
      print $fh "  ";
      for ( my $i = 0; $i < ($arrayLen-($numRows*$numCols)); $i++ ) {
        my $index = $numCols*$numRows + $i;
        print $fh sprintf("%g",$arrayRef->[$index]);
        if ( $index != $arrayLen-1 ) {
          print $fh ", ";
        }
      }
      print $fh "\n";
    }

  }

  print  $fh "};\n\n";
}




#------------------------------------------------------------------------
#	Axpy
#------------------------------------------------------------------------


sub axpy_block {
	my ( $x, $y , $alpha, $N) =@_;
	my $r;
	for (my $i=0; $i < $N; $i++) {
	         $r->[$i] = $x->[$i];
             $r->[$i] += $alpha * $y->[$i];
     }
     return $r;
}





#--------------------------------------------------------------------------
# Main
#--------------------------------------------------------------------------

sub main()
{

  my $Alfa=0.1;
  my $in_max =500; #should be int
  processCommandLine();
  srand($opts{"seed"});


  my @X;
  my @Y;
  my @R;

  # create random input arrays
  my $x;
  my $y;
  for ( my $i = 0; $i < $opts{"size"}; $i++ ) {   
      $x->[$i] = int(rand($in_max));
      $y->[$i] = int(rand($in_max));  
      push( @X, $x->[$i] );
      push( @Y, $y->[$i] );  
  }
	
  
   my $r = axpy_block ($x, $y , $Alfa, $opts{"size"});


 for ( my $i = 0; $i < $opts{"size"}; $i++ ) {      
      push( @R, $r->[$i] );
  }

  

  print $fh "\n#ifndef __DATASET_H";
  print $fh "\n#define __DATASET_H";
  print $fh "\n\#define ARRAY_SIZE ".($opts{"size"})." \n";
  print $fh "\n\#define Alfa  $Alfa\n\n";
  print $fh "\ntypedef double data_t;\n";


  printArray( "input1_data", \@X );
  printArray( "input2_data", \@Y );
  printArray( "verify_data", \@R);

  print $fh "\n#endif //__DATASET_H";
 
}

main();

