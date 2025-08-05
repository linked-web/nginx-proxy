#!/bin/bash

set -e

DOMAIN="${DOMAIN}"
EMAIL="${EMAIL}"

if [ -z "$DOMAIN" ]; then
    echo "Error: DOMAIN environment variable is required"
    exit 1
fi

echo "Starting proxy container for domain: ${DOMAIN}"

# Check if SSL certificates exist
if [ -f "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem" ] && [ -f "/etc/letsencrypt/live/${DOMAIN}/privkey.pem" ]; then
    echo "SSL certificates found - enabling HTTPS"
    envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf
    envsubst < /etc/nginx/ssl.conf.tpl > /etc/nginx/conf.d/ssl.conf
else
    echo "SSL certificates not found - HTTP only mode"
    envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf
fi

# Test nginx configuration
nginx -t

echo "Starting nginx..."
nginx -g 'daemon off;'
