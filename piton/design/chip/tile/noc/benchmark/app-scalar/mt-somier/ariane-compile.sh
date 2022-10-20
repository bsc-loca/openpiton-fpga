#/bin/bash!

# Default problem size
size=1024
bin="bin/mt-somier${1}.riscv"
sources="mt-somier.c somier.c"

if [ "$#" -gt 2 ] || [ "$#" -lt 1 ]; then
    echo "Usage: #cores [opt]Mat_dim(power of 2)"
    exit 2
fi

if [ "$#" -eq 2 ]; then
    perl ./somier_gendata.pl --size $2 > dataset.h
else
    if [ ! -f dataset.h ]
    then
        perl ./somier_gendata.pl --size $size > dataset.h
    fi
fi



RISCV=~/scratch/`whoami`/riscv_install
common="../common_ariane"
compiler_bin="$RISCV/bin/"

mkdir -p  bin
rm $bin


$compiler_bin/riscv64-unknown-elf-gcc -I../ -I${common}/env -I${common}   -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O2 -ffast-math -fno-common -fno-builtin-printf -march=rv64g -DARIANE_TILE -o $bin $sources  ${common}/syscalls.c $common/crt.S -static -nostdlib -nostartfiles -lm -lgcc -T ${common}/test.ld -DPITON_NUMTILES=$1 -DPITONSTREAM

$compiler_bin/riscv64-unknown-elf-objdump --disassemble-all --disassemble-zeroes --section=.text --section=.text.startup --section=.data $bin > $bin.dump


















