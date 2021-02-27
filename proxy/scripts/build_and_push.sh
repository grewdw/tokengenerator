#!/bin/bash

TAG=${1:-dev}

cd $(dirname $0)/..

docker build -t dgrew/tokenproxy:${TAG} ./.

docker push dgrew/tokenproxy:${TAG}