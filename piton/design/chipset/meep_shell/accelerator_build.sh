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

while getopts 'sh' OPTION; do
  case "$OPTION" in
    s)       
        echo -e ${LR} "ACME_EA Naming Convention" ${NC} 
        echo -e ${WH} "First letter: to designate the core (A: Ariane; H: Lagarto Hun) " 
        echo -e       " Second letter: to identify the accelerator (x: no accelerator; V: VPU; G: VPU+SA-HEVC+SA-NN)" 
        echo -e       " Thrid letter: to identify the Memory Tile (x: no MT, M: Memory Tile)" 
        echo -e       "  ACME_EA_aHbVcM; where:" 
        echo -e       "   "a" means the number of cores in the system" 
        echo -e       "   "b" means the number of vector lanes" 
        echo -e       "   "c" means the number of MT "  ${NC}
        exit 0
    ;;
    h)
      echo -e ${LR}"Help menu "
      echo -e "Accelerator_build: A script used for the EA to build potential RTL files. Uses OpenPiton Framwork "
      echo -e "script usage: ./$(basename "$0") <EA_name> <protosyn_flag>"   ${NC} 
      echo -e "<EA_name> available combinatios :" 
      echo -e ${WH} "  acme_ea_4a: CORE=ariane x_tiles=2 y_tyles=2" 
      echo -e       "   acme_ea_1h16v: CORE=lagarto x_tiles=1 y_tyles=1 vlanes=16" 
      echo -e       "   acme_ea_4h2v: CORE=lagarto x_tiles=2 y_tyles=2 vlanes=2" 
      echo -e "<protosyn_flag> available combinatios :"
      echo -e  "  --pronoc: ProNoC routers"
      echo -e  "  --vnpm: Vivado non project mode" ${NC}
      exit 0
      ;;
    ?)
      echo "script usage: ./$(basename "$0") <EA_name>" 
      exit 1
      ;;
  esac
done
}

# Execute the help function
help $1
#####################

# /bin/true is a command that returns 0 (a truth value in the shell)
# if [ x$1 == x--dryrun ]; then
# 	dryrun=/bin/true
# 	shift
# else
# 	dryrun=/bin/false
# fi

## Check the input arguments: no empty vaules

if [ x$1 == x ]; then
   echo Missing arguments
   echo Usage: $0 EA_flavours meep_config
   echo -e ${RED}"    EA_flavours supported: acme_ea_4a acme_ea_1h16v acme_ea_4h2v default" ${NC}
   exit 1
fi

#EA Flavours function: Selection of the production and test bitstreams
#There we have the mandatories protsyn flags
PROTO_OPTIONS="--meep --eth --ncmem --hbm "

function ea_flavours() {
    
    local eaName=$1
    case "$eaName" in
        acme_ea_4a)
            CORE=ariane
            XTILES=2
            YTILES=2
            echo -e ${LP}"    Selected build configuration: Ariane 2x2 Golden Reference " ${NC}
            ;;
        acme_ea_1h16v)
            CORE=lagarto
            XTILES=1
            YTILES=1
            VLANES=16
            PROTO_OPTIONS+=" --vpu --vlanes $VLANES "
            echo -e ${LP}"    Selected build configuration: Lagarto Hun 1x1 16 Vector Lanes" ${NC}
            ;;
        acme_ea_4h2v)
            CORE=lagarto
            XTILES=2
            YTILES=2
            VLANES=2
            PROTO_OPTIONS+=" --vpu --vlanes $VLANES "
            echo -e ${LP}"    Selected build configuration: Lagarto Hun 2x2 2 Vector Lanes " ${NC}
            ;; 
        default)
            # Default options
            CORE=lagarto
            XTILES=1
            YTILES=1
            echo -e ${LP}"Selected build configuration: Lagarto 1x1 " ${NC}
            ;;
    esac
    
    
}

function ea_options() {
    
    case "$1" in
        pronoc)
        PROTO_OPTIONS+=--pronoc 
        echo -e ${LP}"   Added ProNoc routers " ${NC}
        ;;
        vpu)
        PROTO_OPTIONS+=--vpu
        echo -e ${LP}"    vpu " ${NC}
        ;;
        vnpm)
        PROTO_OPTIONS+=--vnpm 
        echo -e ${LP}"    Vivado Non Project mode " ${NC}
        ;;
    esac
}
# Check the input arguments
# The first one must be the EA, second one will be MEEP 

declare -A map=( [acme_ea_4a]=1 [acme_ea_1h16v]=1 [acme_ea_4h2v]=1  [default]=1)
ea_is=$1
if [[ ${map["$ea_is"]} ]] ; then
    echo "EA_selection: $ea_is" 
    ea_flavours $ea_is
else
    echo -e ${RED}"EA selection is not supported" ${NC}
    exit 1
fi
shift
## Build configurations
 declare -A map1=( [pronoc]=1  [default]=1)
 ea_conf=$1

if [ x$1 == x ]; then
    echo -e ${RED}"    No added meep optional configuration arguments. Used mandatory ones --meep --eth --ncmem --hbm " ${NC}
        
elif [[ ${map1["$ea_conf"]} ]]; then
#     MEEP="--vnpm --hbm "
   ea_options $ea_conf
else
    echo -e ${RED}"     EA protosyn flags is not supported" ${NC}
    exit 1
fi



echo "Final result : $CORE x_tiles=$XTILES y_tiles=$YTILES  , flags: $PROTO_OPTIONS"

# Execute protosyn command to build the infrastructure with OP
make protosyn CORE=$CORE XTILES=$XTILES YTILES=$YTILES PROTO_OPTIONS="$PROTO_OPTIONS"

