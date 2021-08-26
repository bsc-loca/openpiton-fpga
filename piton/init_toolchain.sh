ROOT_DIR=$(pwd)

git clone https://github.com/riscv/riscv-gnu-toolchain riscv_toolchain
cd riscv_toolchain
./configure --prefix=$ROOT_DIR/riscv
make
cd $ROOT_DIR

export RISCV=$ROOT_DIR/riscv


