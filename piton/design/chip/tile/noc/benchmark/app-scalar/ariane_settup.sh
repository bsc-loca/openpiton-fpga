#!/bin/bash
SCRPT_FULL_PATH=$(realpath ${BASH_SOURCE[0]})
SCRPT_DIR_PATH=$(dirname $SCRPT_FULL_PATH)

PITON_ROOT=$(realpath $SCRPT_DIR_PATH/../../../../../../..)

 # link in adapted syscalls.c such that the benchmarks can be used in the OpenPiton TB
  cd common_ariane/
  rm syscalls.c util.h
  ln -s ${PITON_ROOT}/piton/verif/diag/assembly/include/riscv/ariane/syscalls.c
  ln -s ${PITON_ROOT}/piton/verif/diag/assembly/include/riscv/ariane/util.h
  cd -

