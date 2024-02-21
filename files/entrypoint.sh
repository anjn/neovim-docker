#!/bin/bash
set -x
set -e

mkdir -p /xdg/local/share
mkdir -p /xdg/local/state
mkdir -p /xdg/cache

if [[ -z "$ROOTLESS" ]] ; then
    uid=$(stat -c "%u" .)
    gid=$(stat -c "%g" .)
    
    getent group $USER || groupadd --gid $gid $USER
    id $USER || useradd -M $USER --uid $uid --gid $gid
    
    echo "%$USER    ALL=(ALL)   NOPASSWD:    ALL" > /etc/sudoers.d/$USER
    chmod 0440 /etc/sudoers.d/$USER

    find /xdg -not -user $USER -execdir chown $USER:$USER {} \+
fi

# Do nothing forever
tail -f /dev/null
