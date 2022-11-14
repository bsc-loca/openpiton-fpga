#!/bin/bash

COMMIT_SHA=$1
PIPELINE_SOURCE=$2

echo "Pipeline Source is = $PIPELINE_SOURCE"

if [ "x$2" == "xpipeline" ]; then

THIS_DIR=`pwd`

git branch -a; git remote -v;
ls;
git remote -v
# remove submodule
git rm -rf piton/design/chip/tile/vas_tile_core
rm -rf .git/modules/piton/design/chip/tile/vas_tile_core
# add it again, with relative path to the project
git submodule add --force ../../../rtl_designs/vas_tile_core.git piton/design/chip/tile/vas_tile_core
echo "cd to submodule";
cd piton/design/chip/tile/vas_tile_core;
git remote -v;
ls; git status
git reset --hard
git status;
git branch -a
git switch main
git pull
ls
git --no-pager log --decorate=short --pretty=oneline -n1
git branch -a; git remote -v;
echo $COMMIT_SHA;
git checkout $COMMIT_SHA;
git branch -a;
ls;
git status
git --no-pager log --decorate=short --pretty=oneline -n1
git submodule update --init --recursive

cd $THIS_DIR

fi;

