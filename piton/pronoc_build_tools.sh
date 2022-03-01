#!/bin/bash


echo
echo "----------------------------------------------------------------------"
echo "Download ProNoC src fils (if not existing)"
echo "----------------------------------------------------------------------"
echo

if [[ "${PRONOC_ROOT}" == "" ]]
then
    echo "Please source pronoc_setup.sh first, while being in the root folder."
else

  git submodule update --init --recursive --progress piton/design/chip/tile/noc/pronoc

 

  echo
  echo "----------------------------------------------------------------------"
  echo " complete"
  echo "----------------------------------------------------------------------"
  echo

fi
