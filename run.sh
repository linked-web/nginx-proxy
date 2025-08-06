#!/bin/sh

set -e

DOMAIN="${DOMAIN}"

if [ -z "$DOMAIN" ]; then
    exit 1
fi

if [ -f "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem" ] && [ -f "/etc/letsencrypt/live/${DOMAIN}/privkey.pem" ]; then
    envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf
    envsubst < /etc/nginx/ssl.conf.tpl > /etc/nginx/conf.d/ssl.conf
else
    envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf
fi

nginx -g 'daemon off;'
