#!/bin/bash

VERSION=${1-dev}

docker run \
	-d \
	--rm \
	--name proxy \
	-p 80:80 \
	dgrew/tokenproxy:${VERSION}

docker exec proxy /update_config.sh -d localhost