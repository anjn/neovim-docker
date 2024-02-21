#!/usr/bin/env bash
set -ex

sudo apt update

sudo apt install -y \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-rtsp \
    gstreamer1.0-plugins-ugly \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstrtspserver-1.0-dev \
    libswscale-dev

