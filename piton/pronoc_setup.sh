#!/bin/bash


echo
echo "----------------------------------------------------------------------"
echo "openpiton/pronoc path setup"
echo "----------------------------------------------------------------------"
echo

echo "make sure that you source this script in a bash shell in the root folder of OpenPiton"

if [ "$0" !=  "bash" ] && [ "$0" != "-bash" ]
then
  echo "not in bash ($0), aborting"
  return

fi

SCRIPTNAME=pronoc_setup.sh

TEST=`pwd`/piton/
if [[ $(readlink -e "${TEST}/${SCRIPTNAME}") == "" ]]
then
  echo "aborting"
  return
fi

################################
# PITON setup
################################

# set root directory
export PITON_ROOT=`pwd`
export PRONOC_ROOT=${PITON_ROOT}/piton/design/chip/tile/noc



