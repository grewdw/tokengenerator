#!/bin/bash

cd $(dirname $0)/..

docker build -t dgrew/tokenproxy:dev ./.

docker push dgrew/tokenproxy:dev