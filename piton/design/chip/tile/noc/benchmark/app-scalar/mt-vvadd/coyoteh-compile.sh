#/bin/bash!

# Default problem size
size=1024

common="../common_coyote"
compiler_bin="../../../epi_compiler/llvm-EPI-release-toolchain-cross/bin/"
bin="bin/mt-vvadd${1}"

if [ "$#" -gt 2 ] || [ "$#" -lt 1 ]; then
    echo "Usage: #cores [opt]Mat_dim(power of 2)"
    exit 2
fi

if [ "$#" -eq 2 ]; then
    perl ./vvadd_gendata.pl --size $2 > dataset.h
else
    if [ ! -f dataset.h ]
    then
        perl ./vvadd_gendata.pl --size $size > dataset.h
    fi
fi

sed -i '/li a7/c li a7, '$1 ./my_crt.S


mkdir -p  bin

rm $bin

#run epi_compiler directly
#compile="../../../epi_compiler/llvm-EPI-release-toolchain-cross/bin/riscv64-unknown-elf-gcc"
#compile="../../../epi_compiler/llvm-EPI-release-toolchain-cross/bin/clang --target=riscv64-unknown-elf -mepi"
 
$compiler_bin/riscv64-unknown-elf-gcc -I../ -I${common}/env -I${common} -I/usr/include/ -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O2 -ffast-math -fno-common -fno-builtin-printf -march=rv64g ${common}/syscalls.c ./my_crt.S -static -nostdlib -nostartfiles -T ${common}/test.ld mt-vvadd.c vvadd.c -o $bin 

$compiler_bin/riscv64-unknown-elf-objdump --disassemble-all --disassemble-zeroes --section=.text --section=.text.startup --section=.data $bin > $bin.dump


