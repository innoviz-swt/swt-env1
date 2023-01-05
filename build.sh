#!/bin/bash
cd $(dirname $0)

ver="${1:-latest}" 
build=$(git rev-parse --short HEAD)

dist="bionic" # focal" jellyfish"
for base in $dist
do
echo build ver: $ver, build: $build, base: $base  
docker build . -t swt-env1-$base:$ver --build-arg BASE=$base --build-arg VER=$ver --build-arg BUILD=$build &
done
wait