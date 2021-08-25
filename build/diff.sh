#!/bin/bash

##############
# TESTS DIFF #
##############

#set -eu

# we erase boot lines 
#sed '1,5d' $3 > $3.temp
#sed '1,12d' $2 > $2.temp

# we erase the tohost lines
#head -n-2 $3.temp > $3
#head -n-14 $2.temp > $2

#rm $3.temp $2.temp

lines=$(cat $2 | wc -l)


paste -d";" $2 $3 | awk -F";" '
($1 != $2 && $2 != "") {
    failed = 1;
    printf "Miss Execution";
    printf "Line %s:\n", NR;
    expected=$1;
    found=$2;
    print "  Found:   ", found;
    print "  Expected:", expected;
}
($1 != $2 && 
    $1 == "" && 
    $2 != "core   0: exception trap_illegal_instruction, epc 0xffffffffffe02068") {
    failed = 1;
    printf "Verilator did not finish execution";
    printf "Line %s:\n", NR;
    expected=$1;
    found=$2;
    print "  Found:   ", found;
    print "  Expected:", expected;
}' > $1

errors=0

#set +e
errors=$(grep -c Line $1)
#set -e

if [ $errors -gt 0 ] ; then
    echo "Error: $errors/$lines lines differ" >&2
    exit 1
else
    #rm -rf $1 $2 $3
    exit 0
fi



