#!/bin/bash

#Use this script to call protosyn

EA_MOD=$1

# Default options
CORE=lagarto
XTILES=1
YTILES=1
PROTO_OPTIONS="--meep --eth --hbm"
#PROTO_OPTIONS="--meep --eth --hbm --vpu"

case "$EA_MOD" in
acme)
    CORE=lagarto
    echo "Selected build configuration: Lagarto 1x1"
    ;;
openpiton)
    CORE=ariane
    echo "Selected build configuration: Ariane 1x1"
    ;;
acme_v2)
    CORE=lagarto
    XTILES=2
    YTILES=2
    echo "Selected build configuration: Lagarto 2x2"
    ;;
acme_vpu)
    CORE=lagarto
    XTILES=2
    YTILES=2
    # Add VPU
    PROTO_OPTIONS="--meep --eth --hbm --vpu"
    echo "Selected build configuration: Lagarto 2x2 plus VPU"
    ;;
esac

make protosyn CORE=$CORE XTILES=$XTILES YTILES=$YTILES PROTO_OPTIONS=$PROTO_OPTIONS MORE_OPTIONS="--debug-brom"

