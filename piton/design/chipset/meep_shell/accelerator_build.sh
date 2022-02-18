#!/bin/bash

#Use this script to call protosyn

CORE=lagarto

source $ACC_DIR/piton/${CORE}_settings.sh
make protosyn CORE=$CORE XTILES=2 YTILES=2 PROTO_OPTIONS="--meep --vpu --eth"

