#!/bin/bash

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --enable-encryption)
    ENABLE_ENCRYPTION="true"
    shift # past argument
    ;;
    -d|--domain)
    DOMAIN="$2"
    shift # past argument
    shift # past value
    ;;
esac
done

if [[ -z $DOMAIN ]]; then
	exit 1
fi

sed -i "s/DOMAIN/${DOMAIN}/" /etc/nginx/conf.d/proxy_config.conf

if [[ ${ENABLE_ENCRYPTION} == "true" ]]; then
	certbot --nginx \
		--email davidgrew@hotmail.co.uk \
		--agree-tos \
		--no-eff-email \
		-d ${DOMAIN} \
		--redirect \
		-n
fi