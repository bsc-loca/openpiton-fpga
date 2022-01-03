#!/bin/bash

ROOT_DIR=$(PWD)
ACC_DIR=$1

cd $ACC_DIR

git submodule update --init --recursive

#Use this script to call protosyn

CORE=ariane

source $ACC_DIR/piton/${CORE}_settings.sh
source $ACC_DIR/piton/${CORE}_build_tools.sh
make protosyn CORE=$CORE XTILES=2 YTILES=2 PROTO_OPTIONS="--meep --eth"

cd $ROOT_DIR

