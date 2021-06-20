#!/bin/bash -e
set -e

#mkdir -p venv
#find venv -mindepth 1 -delete
##virtualenv -p python3 venv/
#python -m venv venv/

#mkdir -p photometry
#find photometry -mindepth 1 -delete
GIT_LFS_SKIP_SMUDGE=1 git clone https://github.com/tasoc/photometry.git --branch devel --single-branch photometry

#mkdir -p corrections
#find corrections -mindepth 1 -delete
GIT_LFS_SKIP_SMUDGE=1 git clone https://github.com/tasoc/corrections.git --branch devel --single-branch corrections

#mkdir -p dataval
#find dataval -mindepth 1 -delete
GIT_LFS_SKIP_SMUDGE=1 git clone https://github.com/tasoc/dataval.git --branch devel --single-branch dataval

#mkdir -p starclass
#find starclass -mindepth 1 -delete
GIT_LFS_SKIP_SMUDGE=1 git clone https://github.com/tasoc/starclass.git --branch devel --single-branch starclass
