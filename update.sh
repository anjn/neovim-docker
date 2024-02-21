#!/usr/bin/env bash

for f in ./files/install-*.sh ; do
    docker cp $f anjn-neovim:/
done
