#!/bin/bash

#Use this script to call protosyn

CORE=lagarto

make protosyn CORE=$CORE XTILES=2 YTILES=2 PROTO_OPTIONS="--meep --eth --hbm --vpu"

