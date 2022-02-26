#!/bin/bash

###  Lagarto Build Torture test
###

echo "make sure that you source this script in a bash shell in the root folder of OpenPiton"

if [ "$0" !=  "bash" ] && [ "$0" != "-bash" ]
then
  echo "not in bash ($0), aborting"
  return

fi

SCRIPTNAME=lagarto_build_torture.sh

TEST=`pwd`/ci/
if [[ $(readlink -e "${TEST}/${SCRIPTNAME}") == "" ]]
then
  echo "aborting"
  return
fi

export PITON_ROOT=`pwd`/..


VAS_TILE_CORE_PATH=${PITON_ROOT}/piton/design/chip/tile/vas_tile_core
TORTURE_TEST_MODULE_PATH=${VAS_TILE_CORE_PATH}/modules/riscv-torture
BUILD_TMP_PATH=${VAS_TILE_CORE_PATH}/tmp

cd ${VAS_TILE_CORE_PATH}


if [ -d ${BUILD_TMP_PATH} ] 
then
    mkdir -p riscv-torture
    cd ${BUILD_TMP_PATH}
    
    echo $PWD 
    # TMP have to alreafy exist. Copying the TORTURE test to tmp if not exist
        [ -d riscv-torture ] || cp -R ${TORTURE_TEST_MODULE_PATH} .

    ## Now build the Torture test ##

    # cd into the copied ISA/Benchmark folder
    cd ${BUILD_TMP_PATH}/riscv-torture

    make clean
    make gen-torture TORTURE_CONFIG=$1 TORTURE_SIZE=$2

    cd ${PITON_ROOT}/build

echo "----------------***Torture complete***--------------"
else

    cd ${PITON_ROOT}
    echo
    echo "----------------------------------------------------------------------"
    echo "No tmp folder"
    echo "----------------------------------------------------------------------"
    echo

  fi
