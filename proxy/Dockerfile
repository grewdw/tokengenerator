FROM nginx:latest

RUN rm /etc/nginx/conf.d/default.conf
COPY proxy_config.conf /etc/nginx/conf.d/

RUN rm /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/

COPY update_config.sh /
RUN chmod +x /update_config.sh

# install CertBot
RUN apt-get update && \
	apt-get -y install certbot && \
	apt-get -y install certbot python-certbot-nginx
