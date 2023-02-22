#!/bin/bash

# Use this script to call protosyn using the OpenPIton Framework. Here you can choose the differents "flavours" we can implement

#Colors debug porpuses
R='\033[0;0;31m'    #Red
BR='\033[1;31m'     #Bold Red 
BIR='\033[1;3;31m'  #Bold Italic Red
Y='\033[0;0;93m'    #Yellow
BY='\033[1;0;93m'   #Bold Yellow
BC='\033[1;36m'     #Bold Cyan
G='\033[0;32m'      #Green
BP='\033[1;35m'     #Bold Purple
BW='\033[1;37m'     #Bold White
NC='\033[0;0;0m'        #NO COLOR

#help fuction


function help(){

while getopts 'sh' OPTION; do
  case "$OPTION" in
    s)       
        echo -e ${BR} " ACME_EA Naming Convention" 
        echo -e ${BW} "First letter: to designate the core (A: Ariane; H: Lagarto Hun) " 
        echo -e       " Second letter: to identify the accelerator (x: no accelerator; V: VPU; G: VPU+SA-HEVC+SA-NN)" 
        echo -e       " Thrid letter: to identify the Memory Tile (x: no MT, M: Memory Tile)" 
        echo -e      ${Y} " ( acme_ea_ahbvcm ); where:" 
        echo -e      ${G} "  "a" means the number of cores in the system" 
        echo -e               "   "b" means the number of vector lanes" 
        echo -e               "   "c" means the number of MT "  ${NC}
        exit 0
    ;;
    h)
      echo -e ${BR}"Help menu "
      echo -e ${BC}"Accelerator_build:"${BW}"\tA script used for the EA to build potential RTL files. Uses OpenPiton Framwork "
      echo -e ${BC}"script usage:"${BW}"\t\t./$(basename "$0") <EA_name> <protosyn_flags>"   
      echo -e ${BC}"<EA_name> available combinations :" 
      echo -e ${BW} "  acme_ea_4a: \t\tCORE=ariane \tx_tiles=2 \ty_tyles=2" 
      echo -e       "   acme_ea_1h16v: \tCORE=lagarto \tx_tiles=1 \ty_tyles=1 \tvlanes=16" 
      echo -e       "   acme_ea_4h2v: \tCORE=lagarto \tx_tiles=2 \ty_tyles=2 \tvlanes=2"
      echo -e ${BC}"<protosyn_flag> available combinations :"
      echo -e  ${BW}"  pronoc: ProNoC routers"
      echo -e  "  vnpm: \tVivado non project mode" 
      echo -e  "  hbm: \t\tHigh Bandwidth Memory. Implement design with HBM memory going first"
      echo -e  "  meep: \tGenerate a file list and a define list to called by the MEEP Shell project flow"
      echo -e  "  eth: \t\tAdd Ethernet controller to implementation"
      echo -e  "  ncmem: \tCreate an alias of the main memory bypassing the cache. Only available with meep option" ${NC}
      exit 0
      ;;
    ?)
      echo "script usage: ./$(basename "$0") <EA_name> <protosyn_flags>"
      exit 1
      ;;
  esac
done
}

# Execute the help function
help $1
#####################



if [ x$1 == x ]; then
   echo Missing arguments
   echo Usage: $0 EA_flavours meep_config
   echo -e ${R}"    EA_flavours supported: acme_ea_4a acme_ea_1h16v acme_ea_4h2v " ${NC}
   exit 1
fi

#EA Flavours function: Selection of the production and test bitstreams
function ea_flavours() {
    
    local eaName=$1
    case "$eaName" in
        acme_ea_4a)
            CORE=ariane
            XTILES=2
            YTILES=2
            echo -e ${BP}"    Selected build configuration: Ariane 2x2 Golden Reference " ${NC}
            ;;
        acme_ea_1h16v)
            CORE=lagarto
            XTILES=1
            YTILES=1
            VLANES=16
            PROTO_OPTIONS+=" --vpu --vlanes $VLANES "
            echo -e ${BP}"    Selected build configuration: Lagarto Hun 1x1 16 Vector Lanes" ${NC}
            ;;
        acme_ea_4h2v)
            CORE=lagarto
            XTILES=2
            YTILES=2
            VLANES=2
            PROTO_OPTIONS+=" --vpu --vlanes $VLANES "
            echo -e ${BP}"    Selected build configuration: Lagarto Hun 2x2 2 Vector Lanes " ${NC}
            ;; 
        default)
            # Default options
            CORE=lagarto
            XTILES=1
            YTILES=1
            echo -e ${BP}"Selected build configuration: Lagarto 1x1 " ${NC}
            ;;
    esac
    
    
}

function ea_options() {
    
    case "$1" in
        pronoc)
        PROTO_OPTIONS+=" --pronoc"
        echo -e ${BC}"    Added ProNoc routers " ${NC}
        ;;        
        vnpm)
        PROTO_OPTIONS+=" --vnpm " 
        echo -e ${BC}"    Vivado Non Project mode " ${NC}
        ;;
        hbm)
        PROTO_OPTIONS+=" --hbm"  
        echo -e ${BC}"    HBM " ${NC}
        ;;
        meep)
        PROTO_OPTIONS+=" --meep " 
        echo -e ${BC}"    MEEP " ${NC}
        ;;
        eth)
        PROTO_OPTIONS+=" --eth " 
        echo -e ${BC}"    Ethernet " ${NC}
        ;;
        ncmem)
        PROTO_OPTIONS+=" --ncmem " 
        echo -e ${BC}"    Main memory bypassing the cache " ${NC}
        ;;
    esac
}

# Check the input arguments
# The first one must be the EA, second one will be PROTOSYN_FLAG 

function ea_selected() {
declare -A map=( [acme_ea_4a]=1 [acme_ea_1h16v]=1 [acme_ea_4h2v]=1  [default]=1)
ea_is=$1
if [[ ${map["$ea_is"]} ]] ; then
    echo "EA_selection: $ea_is" 
    ea_flavours $ea_is
else
    echo -e ${BY}"EA selection: ${BIR}  $ea_is ${BY} is not supported" ${NC}
    exit 1
fi
shift
}
## Build configurations
#Right flag names
function protosyn_flags() {
 declare -A map1=( [pronoc]=1 [vnpm]=1 [hbm]=1 [meep]=1 [eth]=1 [ncmem]=1)
 ea_conf=$1

if [ x$1 == x ]; then
    echo -e ${R}"    No added meep optional configuration arguments. Used mandatory ones --meep --eth --ncmem --hbm " ${NC}
    PROTO_OPTIONS+="--meep --eth --ncmem --hbm "
elif [[ ${map1["$ea_conf"]} ]]; then     
   ea_options $ea_conf   
else
    echo -e ${BY}"EA protosyn flags: "${BIR} "$1" ${BY}"is not supported" ${NC}
    exit 1
fi
}

#read the input array and set the specific flags
array=("$@")

for i in "${array[@]}"
do
    if [ $# -eq 0 ]; then
        echo "No arguments passed. Please provide some arguments."
    elif [ $# -eq 1 ]; then
        ea_selected $1
        protosyn_flags 
    elif [ $# -gt 1 ]; then 
        if [[ $i  != *"acme_ea"* ]]; then        
            protosyn_flags $i
        else 
            ea_selected $1
        fi
    fi

done


echo -e ${BW}"Final result : $CORE x_tiles=$XTILES y_tiles=$YTILES  , flags: $PROTO_OPTIONS" ${NC}

#check the variables are not empty

if [ -z "$CORE" ] || [ -z "$XTILES" ] || [ -z "$YTILES" ] || [ -z "$PROTO_OPTIONS" ]; then
      echo "Can't execute protosyn command"
else
      
      echo "Execute protosyn command to build the infrastructure with OP"
      make protosyn CORE=$CORE XTILES=$XTILES YTILES=$YTILES PROTO_OPTIONS="$PROTO_OPTIONS"
fi

