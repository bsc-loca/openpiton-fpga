#!/bin/bash

#Use this script to call protosyn

CORE=ariane

make protosyn CORE=$CORE XTILES=1 YTILES=1 PROTO_OPTIONS="--meep --eth --hbm"

