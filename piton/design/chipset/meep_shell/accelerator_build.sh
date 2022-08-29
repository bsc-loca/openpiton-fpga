#!/bin/bash

#Use this script to call protosyn

CORE=lagarto

make protosyn CORE=$CORE XTILES=1 YTILES=1 PROTO_OPTIONS="--meep --eth --hbm --vpu"

