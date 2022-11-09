# you may not use this file except in compliance with the License, or, at your option, the Apache License version 2.0.
# You may obtain a copy of the License at
# 
#     http://www.solderpad.org/licenses/SHL-2.1
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Author: Daniel J.Mazure, BSC-CNS
# Date: 22.11.2022
# Description: 


#!/bin/bash

#echo "Latches:";     grep -rni . -e "Synth 8-327"
#echo "Timing loops"; grep -rni . -e "Synth 8-295"

#$ echo "grep -rni . -e \"Synth 8-295\"" >> script_cicd.sh
ROOT_DIR=$1
CONFIG_DIR=$2

LOG_DIR=$ROOT_DIR/$CONFIG_DIR

LATCHES_ERR="Synth 8-327"
TM_LOOP_ERR="Synth 8-295"
## Add more error sources here
ret=0

declare -a ERROR_SRCs=("$LATCHES_ERR" "$TM_LOOP_ERR")

for i in "${ERROR_SRCs[@]}"
do 
    synthErr="`grep -rni $LOG_DIR -e "$i" || true`"
    if [ "x" != "x$synthErr" ]; then
        echo "error [$i] detected"
        # Refer to some place where the error codes are translated. Wiki?
        ret=11
    fi

done

CRIT_WARNS="`egrep -rni . -e [[:space:]][1-9]+.Critical.warnings || true`"

 if [ "x" == "x$CRIT_WARNS" ]; then
    echo "The synthesis contains critical warnings"
 fi


exit $ret
