#!/bin/bash


echo
echo "----------------------------------------------------------------------"
echo "building Verilator toolchain "
echo "----------------------------------------------------------------------"
echo

dir=~/scratch/`whoami`/verilator_repo
instal_dir=~/scratch/`whoami`/verilator_4_104


mkdir $dir

cd $dir

[ -d verilator ] || git clone https://github.com/verilator/verilator

cd verilator

unset VERILATOR_ROOT # For bash


#git checkout stable # Use most recent stable release

git checkout v4.104

#git checkout v{version} # Switch to specified release version

autoconf

./configure --prefix $instal_dir

make -j 2

make install

cp -R $dir/verilator/*    $instal_dir/







 
  echo
  echo "----------------------------------------------------------------------"
  echo "build complete"
  echo "----------------------------------------------------------------------"
  echo


