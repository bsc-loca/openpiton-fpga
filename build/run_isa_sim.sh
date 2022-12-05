#!/bin/bash

trap '' INT

run_simulation () (
   trap - INT

   echo "[MEEP] Running simulation..."
   # differentiate virtual and physical test for the arguments
   if [[ $TEST == *"-v-"* ]];
   then
       echo "[MEEP] virtual test"
       sims -sys=manycore -msm_run -x_tiles=1 -y_tiles=1 $TEST.S -lagarto -precompiled -trap_offset=0x80000000 -rtl_timeout=1000000
   else
       echo "[MEEP] physical test"
       sims -sys=manycore -msm_run -x_tiles=1 -y_tiles=1 $TEST.S -lagarto -precompiled 
   fi
)

echo 'main shell here'


TOOLS=/home/tools/drac/bin
TEST=$1

echo "[MEEP] Removing previous sig..."
rm lagarto.sig
rm $TEST.sig
rm signature.txt
rm result.diff

echo "[MEEP] Cleaning..."
sims clean
rm -rf manycore/

echo "[MEEP] Compiling..."
sims -sys=manycore -x_tiles=1 -y_tiles=1 -msm_build -lagarto -config_rtl=BSC_RTL_SRAMS -config_rtl=OPENPITON_LAGARTO_COMMIT_LOG -config_rtl=MEEP_VPU

run_simulation

echo "[MEEP] Running spike. Getting golden reference..."
$TOOLS/spike -l --isa rv64gc ../piton/design/chip/tile/vas_tile_core/tmp/riscv-tests/build/isa/$TEST 2> $TEST.sig

echo "[MEEP] Formating lagarto signature for comparation..."
cat signature.txt |  $TOOLS/spike-dasm > lagarto.sig

sed -i '/core   0: 0x00000000000010/d' $TEST.sig
sed -i '/3 0x00000000000010/d' $TEST.sig
sed -i '/core   0: 0xfffffffff101/d' lagarto.sig
sed -i '/3 0xfffffffff101/d' lagarto.sig

NBR_LINES_FILE0=$(wc -l < $TEST.sig)
NBR_LINES_FILE1=$(wc -l < lagarto.sig)

echo "$TEST.sig have $NBR_LINES_FILE0 lines"
echo "lagarto.sig have $NBR_LINES_FILE1 lines"

if [[ $NBR_LINES_FILE0 -gt $NBR_LINES_FILE1 ]]
then
  NBR_LINES_FILE1=$(($NBR_LINES_FILE1 + 1))
  sed -i ''"$NBR_LINES_FILE1"',$d' $TEST.sig
else
  NBR_LINES_FILE0=$(($NBR_LINES_FILE0 + 1))
  sed -i ''"$NBR_LINES_FILE0"',$d' lagarto.sig
fi


NBR_LINES_FILE0=$(wc -l < $TEST.sig)
NBR_LINES_FILE1=$(wc -l < lagarto.sig)
echo "$TEST.sig have $NBR_LINES_FILE0 lines"
echo "lagarto.sig have $NBR_LINES_FILE1 lines"

echo "[MEEP] Comparing results..."
source diff.sh result.diff $TEST.sig lagarto.sig
exit
