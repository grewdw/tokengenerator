#!/bin/bash

TAG=${1:-dev}
HOST=${2:-localhost}

docker run \
	-d \
	--rm \
	--name proxy \
	-p 80:80 \
	dgrew/tokenproxy:${TAG}

docker exec proxy /update_config.sh -d ${HOST}