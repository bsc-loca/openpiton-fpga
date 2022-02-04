#!/usr/bin/tclsh
global env
set PITON_ROOT  $::env(PITON_ROOT)



transcript on

vlib $PITON_ROOT/build/rtl_work
vmap work $PITON_ROOT/build/rtl_work


vlog  +acc=rn  -F $PITON_ROOT/piton/design/chip/tile/noc/modelsim/file_list.f

vsim -t 1ps  -L $PITON_ROOT/build/rtl_work -L work -voptargs="+acc"  testbench_piton

add wave *
view structure
view signals
run -all
