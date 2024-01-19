#!/usr/bin/env bash

dir=$(dirname $(readlink -f $0))

opts=

if [[ -n $HTTP_PROXY ]] ; then
    opts="$opts --build-arg http_proxy=$HTTP_PROXY"
    opts="$opts --build-arg https_proxy=$HTTP_PROXY"
    opts="$opts --build-arg HTTP_PROXY=$HTTP_PROXY"
    opts="$opts --build-arg HTTPS_PROXY=$HTTP_PROXY"
fi

cd $dir
docker buildx build $opts -t anjn/neovim .
