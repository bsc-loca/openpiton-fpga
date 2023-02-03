#!/bin/bash

# Use this script to call protosyn using the OpenPIton Framework. Here you can choose the differents "flavours" we can implement

#Colors debug porpuses
RED='\033[0;31m'
GREEN='\033[0;32m'   
YELLOW='\033[0;93m'
LC='\033[1;36m'
LP='\033[1;35m'
LR='\033[1;31m'
WH='\033[1;37m'
NC='\033[0m'

#help fuction

function help(){

while getopts 'lh' OPTION; do
  case "$OPTION" in
    l)
        
        echo "linuxconfig"
    ;;
    h)
      echo -e ${LR}"Help menu "
      echo -e "script usage: $(basename "$0") <EA_name>" >&2  ${NC} 
      echo -e "<EA_name> available combinatios :" >&2
      echo -e ${WH}"  acme: CORE=lagarto" >&2
      echo -e "  ariane: CORE=ariane x_tiles=2 y_tyles=2" >&2
      echo -e "  pronoc: CORE=lagarto x_tiles=2 y_tyles=2 PROTO_OPTIONS=--pronoc" >&2
      echo -e "  meep_dvino: CORE=lagarto PROTO_OPTIONS=--vpu" >&2
      echo -e "  acme_v2: CORE=lagarto x_tiles=2 y_tyles=2 " >&2
      echo -e "  acme_vpu: CORE=lagarto x_tiles=2 y_tyles=2 vlanes=2 PROTO_OPTIONS=--vpu --pronoc --acme --vlanes" >&2 ${NC}
	  exit 0
      ;;
    ?)
      echo "script usage: ./$(basename "$0") <EA_name>" >&2
      exit 1
      ;;
  esac
done
}

help $1

# /bin/true is a command that returns 0 (a truth value in the shell)
if [ x$1 == x--dryrun ]; then
	dryrun=/bin/true
	shift
else
	dryrun=/bin/false
fi


if [ x$1 == x ]; then
   echo Missing arguments
   echo Usage: $0 [--dryrun] EA_flavours meep_config
   echo -e ${RED}"    EAflavours supported: acme ariane pronoc meep_dvino acme_v2 acme_vpu" ${NC}
   exit 1
fi

#EA Flavours function

function ea_flavours() {
    local __eaName=$1

    case "$1" in
        acme)
            CORE=lagarto
            echo -e ${LP}"    Selected build configuration: Lagarto 1x1" ${NC}
            ;;
        ariane)
            CORE=ariane
            XTILES=2
            YTILES=2
            echo -e ${LP}"    Selected build configuration: Ariane 2x2" ${NC}
            ;;
        pronoc)
            CORE=lagarto
            XTILES=2
            YTILES=2
            PROTO_OPTIONS=" --pronoc"
            echo -e ${LP}"    Selected build configuration: Lagarto 2x2 with Pronoc" ${NC}
            ;; 
        meep_dvino)
            CORE=lagarto
            PROTO_OPTIONS=" --vpu"
            echo -e ${LP}"    Selected build configuration: MEEP DVINO" ${NC}
            ;; 
        acme_v2)
            CORE=lagarto
            XTILES=2
            YTILES=2
            echo -e ${LP}"    Selected build configuration: Lagarto 2x2" ${NC}
            ;;
        acme_vpu)
            CORE=lagarto
            XTILES=2
            YTILES=2
            VLANES=2
            # Add VPU
            PROTO_OPTIONS=" --vpu --pronoc --acme --vlanes $VLANES"
            echo -e ${LP}"Selected build configuration: Lagarto 2x2 plus VPU and pronoc" ${NC}
            ;;
        default)
            # Default options
            CORE=lagarto
            XTILES=1
            YTILES=1
            echo -e ${LP}"Selected build configuration: Lagarto 1x1 " ${NC}
            #PROTO_OPTIONS="--meep --eth --hbm --vpu"
        ;;
    esac
}


# Check the input arguments
# The first one must be the EA, second one will be MEEP 

declare -A map=( [acme]=1 [ariane]=1 [pronoc]=1 [meep_dvino]=1 [acme_v2]=1 [acme_vpu]=1 [default]=1)
ea_is=$1
if [[ ${map["$ea_is"]} ]] ; then
    echo -e ${YELLOW}"EA selection is supported: $ea_is" ${NC}
    ea_flavours $ea_is
else
    echo -e ${RED}"EA selection is not supported" ${NC}
    exit 1
fi
shift
## Build configurations
if [ x$1 == x ]; then
    echo -e ${RED}"    Missing meep optional configuration arguments" ${NC}
    # MEEP="--meep --eth --ncmem --hbm "
    exit 1
# else
#     MEEP="--vnpm --hbm "
fi

# echo "EA configuration is $EA_MOD with $MEEP$PROTO_OPTIONS"

PROTO_OPTIONS=$MEEP$PROTO_OPTIONS

make protosyn CORE=$CORE XTILES=$XTILES YTILES=$YTILES PROTO_OPTIONS="$PROTO_OPTIONS"

