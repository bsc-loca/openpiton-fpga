#!/bin/bash

ROOT_DIR=$(PWD)
ACC_DIR=$1

cd $ACC_DIR

git submodule update --init --recursive

cd $ROOT_DIR

