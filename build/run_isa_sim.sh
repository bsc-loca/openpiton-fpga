#!/bin/bash

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
sims -sys=manycore -x_tiles=1 -y_tiles=1 -msm_build -lagarto -config_rtl=BSC_RTL_SRAMS -config_rtl=OPENPITON_LAGARTO_COMMIT_LOG

echo "[MEEP] Running simulation..."
sims -sys=manycore -msm_run -x_tiles=1 -y_tiles=1 $TEST.S -lagarto -precompiled 

echo "[MEEP] Running spike. Getting golden reference..."
$TOOLS/spike -l /home/tools/openpiton/open-piton/piton/design/chip/tile/ariane/tmp/riscv-tests/build/isa/$TEST 2> $TEST.sig

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