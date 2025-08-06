#!/bin/sh

set -e

DOMAIN="${DOMAIN}"

if [ -z "$DOMAIN" ]; then
    exit 1
fi

envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf
envsubst < /etc/nginx/ssl.conf.tpl > /etc/nginx/conf.d/ssl.conf

nginx -g 'daemon off;'
