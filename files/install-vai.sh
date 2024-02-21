#!/usr/bin/env bash
set -ex

sudo apt update
sudo apt install -y libprotobuf-dev protobuf-compiler

#wget https://github.com/protocolbuffers/protobuf/releases/download/v3.19.4/protobuf-cpp-3.19.4.tar.gz
#tar xf protobuf-cpp-3.19.4.tar.gz
#cd protobuf-3.19.4
#./configure
#make -j
#sudo make install

cd /tmp
wget "https://www.xilinx.com/bin/public/openDownload?filename=vairuntime-3.5.0.tar.gz" -O vairuntime-3.5.0.tar.gz
tar xf vairuntime-3.5.0.tar.gz
sudo apt install -y ./vairuntime/*.deb
rm -f vairuntime-3.5.0.tar.gz vairuntime

cd /usr/include/vitis/ai/proto
sudo protoc --cpp_out=. dpu_model_param.proto
