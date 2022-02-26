#!/bin/bash
#TOOLS=/home/tools/drac/bin
#TOOLS=/home/fcano/tools/drac/bin
TOOLS=/home/ivan/tools/drac_fp2/bin

echo "make sure that you source this script in a bash shell in the root folder of OpenPiton"

if [ "$0" !=  "bash" ] && [ "$0" != "-bash" ]
then
  echo "not in bash ($0), aborting"
  return

fi

SCRIPTNAME=lagarto_run_torture.sh

TEST=`pwd`/ci/
if [[ $(readlink -e "${TEST}/${SCRIPTNAME}") == "" ]]
then
  echo "aborting"
  return
fi

export PITON_ROOT=`pwd`/..

# Color variables
red='\033[0;31m'
green='\033[0;32m'
# Clear the color after that
clear='\033[0m'

VAS_TILE_CORE_PATH=${PITON_ROOT}/piton/design/chip/tile/vas_tile_core
TORTURE_TEST_MODULE_PATH=${VAS_TILE_CORE_PATH}/modules/riscv-torture
BUILD_TMP_PATH=${VAS_TILE_CORE_PATH}/tmp

COUNTER_PASS_TEST=0

TORTURE_CONFIG=$1 
TORTURE_SIZE=$2

sims clean
rm -rf manycore/
rm signature.txt 

sims -sys=manycore -x_tiles=1 -y_tiles=1 -msm_build -lagarto -config_rtl=BSC_RTL_SRAMS -config_rtl=OPENPITON_LAGARTO_COMMIT_LOG > compilation.log

echo -e "${green}**********************************************${clear}"
echo -e "${green}*           Running Torture Tests            *${clear}"
echo -e "${green}**********************************************${clear}"

for i in $( seq 1 $TORTURE_SIZE )
do
  timeout 1m sims -sys=manycore -msm_run -x_tiles=1 -y_tiles=1 $TORTURE_CONFIG-$i.riscv -lagarto -precompiled > simulation.log 

  $TOOLS/spike -l ${BUILD_TMP_PATH}/riscv-torture/artifacts/torture/$TORTURE_CONFIG-$i.riscv 2> $TORTURE_CONFIG-$i.sig

  cat signature.txt |  $TOOLS/spike-dasm > lagarto-$TORTURE_CONFIG-$i.sig
  rm signature.txt 

  # Remove boot lines 
  sed '1,12d' lagarto-$TORTURE_CONFIG-$i.sig > lagartotmp
  sed '1,10d' $TORTURE_CONFIG-$i.sig > spiketmp

  # Remove the tohost lines
  head -n-1 lagartotmp > lagarto-$TORTURE_CONFIG-$i.sig 
  head -n-13 spiketmp > $TORTURE_CONFIG-$i.sig

  rm lagartotmp spiketmp

  result=$(diff lagarto-$TORTURE_CONFIG-$i.sig $TORTURE_CONFIG-$i.sig)

  if [ $? -eq 0 ]
  then
    echo -e "${green}[pass]${clear} $TORTURE_CONFIG-$i"
    let COUNTER_PASS_TEST++
  else
    echo -e "${red}[fail]${clear} $TORTURE_CONFIG-$i"
  fi

done

echo -e "${green}==================================================${clear})"
echo -e "test cases: $TORTURE_SIZE total (${green} $COUNTER_PASS_TEST passed${clear})"

  if [ $COUNTER_PASS_TEST -eq $TORTURE_SIZE ]
  then
    echo -e "${green}TEST PASSED${clear}"
  else
    echo -e "${red}TEST FAILS${clear}"
  fi
