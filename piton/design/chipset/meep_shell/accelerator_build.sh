#!/bin/bash

# Use this script to call protosyn
# make protosyn CORE=$CORE XTILES=$XTILES YTILES=$YTILES PROTO_OPTIONS="$PROTO_OPTIONS" MORE_OPTIONS="--debug-brom"


EA_MOD=$1
MEEP=$2

if [ x$MEEP == x ]; then
    MEEP="--meep --eth --ncmem --hbm "
else
    MEEP="--vnpm --hbm "
fi

# Default options
# CORE=lagarto
CORE=ariane
XTILES=1
YTILES=1
#PROTO_OPTIONS="--meep --eth --hbm --vpu"

case "$EA_MOD" in
acme)
    CORE=lagarto
    echo "Selected build configuration: Lagarto 1x1"
    ;;
ariane)
    CORE=ariane
    XTILES=2
    YTILES=2
    echo "Selected build configuration: Ariane 2x2"
    ;;
pronoc)
    CORE=lagarto
    XTILES=2
    YTILES=2
    PROTO_OPTIONS=" --pronoc"
    echo "Selected build configuration: Lagarto 2x2 with Pronoc"
    ;; 
meep_dvino)
    CORE=lagarto
    PROTO_OPTIONS=" --vpu"
    echo "Selected build configuration: MEEP DVINO"
    ;;
acme_v2)
    CORE=lagarto
    XTILES=2
    YTILES=2
    echo "Selected build configuration: Lagarto 2x2"
    ;;
acme_vpu)
    CORE=lagarto
    XTILES=1
    YTILES=1
    VLANES=2
    # Add VPU
    PROTO_OPTIONS=" --vpu --pronoc --acme"
    echo "Selected build configuration: Lagarto 2x2 plus VPU and pronoc"
    ;;
esac


echo "EA configuration is $EA_MOD with $MEEP$PROTO_OPTIONS"

PROTO_OPTIONS=$MEEP$PROTO_OPTIONS

make protosyn CORE=$CORE XTILES=$XTILES YTILES=$YTILES VLANES=$VLANES PROTO_OPTIONS="$PROTO_OPTIONS"

