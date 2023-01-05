#!/bin/bash
cd $(dirname $0)

base="${1:-focal}" 
ver="${2:-latest}" 
docker push swt-env1-$base:$ver 