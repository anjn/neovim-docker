#!/usr/bin/env bash
set -ex

cd /tmp
git clone https://github.com/Z3Prover/z3.git
cd z3
git checkout z3-4.13.0

python scripts/mk_make.py
cd build
make
sudo make install

