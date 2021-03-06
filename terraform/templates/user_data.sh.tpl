#!/bin/bash

set -e

yum update -y
amazon-linux-extras install docker
yum install docker
service docker start
yum install -y jq
yum install -y amazon-cloudwatch-agent

export AWS_DEFAULT_REGION=eu-west-2

AT=$(aws ssm get-parameter --name ${AT} --with-decryption | jq -r '.Parameter.Value')

PK=$(aws ssm get-parameter --name ${PK} --with-decryption | jq -r '.Parameter.Value')

KI=$(aws ssm get-parameter --name ${KI} --with-decryption | jq -r '.Parameter.Value')

TI=$(aws ssm get-parameter --name ${TI} --with-decryption | jq -r '.Parameter.Value')

docker network create -d bridge token_network

docker run \
	-d \
	-p 8399:8399 \
	--name generator \
	--network=token_network \
	-e AUTH_TOKEN="$AT" \
	-e APPLE_MUSIC_PRIVATE_KEY="$PK" \
	-e APPLE_MUSIC_KEY_IDENTIFIER="$KI" \
	-e APPLE_MUSIC_TEAM_ID="$TI" \
	dgrew/tokengenerator:${TAG}

mkdir /var/log/nginx

docker run \
	-d \
	-p 80:80 -p 443:443 \
	--name proxy \
	--network=token_network \
	-v /var/log/nginx:/var/log/nginx \
	dgrew/tokenproxy:${TAG}

docker exec proxy /update_config.sh -d ${DOMAIN} ${ENABLE_TLS}

aws s3 cp ${CLOUDWATCH_CONFIG} /tmp/cloudwatch_config.json
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/tmp/cloudwatch_config.json
