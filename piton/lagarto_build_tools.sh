#!/bin/bash
# Copyright 2018 ETH Zurich and University of Bologna.
# Copyright and related rights are licensed under the Solderpad Hardware
# License, Version 0.51 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
# http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
# or agreed to in writing, software, hardware and materials distributed under
# this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#
# Author: Michael Schaffner <schaffner@iis.ee.ethz.ch>, ETH Zurich
# Date: 26.11.2018
# Description: This script builds the RISCV toolchain, benchmarks, assembly tests
# the RISCV FESVR and the RISCV Torture framework for OpenPiton+Ariane configurations.
# Please source the ariane_setup.sh first.
#
#
# Make sure you have the following packages installed:
#
# sudo apt install \
#          gcc-7 \
#          g++-7 \
#          gperf \
#          autoconf \
#          automake \
#          autotools-dev \
#          libmpc-dev \
#          libmpfr-dev \
#          libgmp-dev \
#          gawk \
#          build-essential \
#          bison \
#          flex \
#          texinfo \
#          python-pexpect \
#          libusb-1.0-0-dev \
#          default-jdk \
#          zlib1g-dev \
#          valgrind \
#          csh


echo
echo "----------------------------------------------------------------------"
echo "building RISCV toolchain and tests (if not existing)"
echo "----------------------------------------------------------------------"
echo

if [[ "${RISCV}" == "" ]]
then
    echo "Please source lagarto_setup.sh first, while being in the root folder."
else

  VAS_TILE_CORE_PATH=${PITON_ROOT}/piton/design/chip/tile/vas_tile_core
  ISA_TEST_MODULE_PATH=${VAS_TILE_CORE_PATH}/modules/riscv-tests
  BUILD_TMP_PATH=${VAS_TILE_CORE_PATH}/tmp

  git submodule update --init --recursive piton/design/chip/tile/vas_tile_core

  # parallel compilation
  export NUM_JOBS=4

  cd ${VAS_TILE_CORE_PATH}

  #########################################
  #  Build the toolchain                  #
  #########################################

  scripts/build-riscv-gcc.sh   # Build the RISCV toolchain
  
  #########################################
  # build the RISCV tests  and benchmarks #
  #########################################
 
  if [ ! -d ${BUILD_TMP_PATH} ] 
  then
    scripts/make-tmp.sh          # Make the tmp area
    cd ${BUILD_TMP_PATH}

    # Copying the ISA and Benchmart to tmp if not exist
    [ -d riscv-tests ] || cp -R ${ISA_TEST_MODULE_PATH} .

    # cd into the copied ISA/Benchmark folder
    cd ${BUILD_TMP_PATH}/riscv-tests

    autoconf
    mkdir -p build

    #Neiel has apadted the OP env for riscv-test, we don't have to this
    # # link in adapted syscalls.c such that the benchmarks can be used in the OpenPiton TB
    # cd ${BUILD_TMP_PATH}/riscv-tests/benchmarks/common/
    
    # rm syscalls.c  
    # ln -s ${PITON_ROOT}/piton/verif/diag/assembly/include/riscv/lagarto/syscalls.c
    
    # rm util.h 
    # ln -s ${PITON_ROOT}/piton/verif/diag/assembly/include/riscv/lagarto/util.h
    
    # rm crt.S 
    # ln -s ${PITON_ROOT}/piton/verif/diag/assembly/include/riscv/lagarto/crt.S
 
    cd ${BUILD_TMP_PATH}/riscv-tests/build

    ../configure --prefix=${BUILD_TMP_PATH}/tmp/riscv-tests/build

    make clean

    make isa        -j${NUM_JOBS} > /dev/null
    make benchmarks -j${NUM_JOBS} > /dev/null
    make install
    cd ${PITON_ROOT}

    echo
    echo "----------------------------------------------------------------------"
    echo "build complete"
    echo "----------------------------------------------------------------------"
    echo
    
  else

    cd ${PITON_ROOT}
    echo
    echo " *** NOTE: ISA Test and Benchmark already built. Please remove tmp to recompile it again. !!!"
    echo "----------------------------------------------------------------------"
    echo "build complete"
    echo "----------------------------------------------------------------------"
    echo

  fi

fi
