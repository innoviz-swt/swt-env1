#!/bin/bash
cd $(dirname $0)

ver="${1:-latest}" 
build=$(git rev-parse --short HEAD)

dist="bionic" # focal" jellyfish"

# base map
declare -A base_arr
base_arr[bionic]=nvidia/cuda:11.7.1-base-ubuntu18.04

for dist in $dist
do
base=${base_arr[$dist]}
echo build dist: $dist, ver: $ver, build: $build, base: $base  
docker build . -t swt-env1-$dist:$ver --build-arg BASE=$base --build-arg VER=$ver --build-arg BUILD=$build &
done
wait