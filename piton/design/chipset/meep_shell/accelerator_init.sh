#!/bin/bash

ROOT_DIR=$(pwd)
ACC_DIR=$1

cd $ACC_DIR

git submodule update --init --recursive

cd $ROOT_DIR

