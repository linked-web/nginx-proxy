#!/bin/sh

set -e

DOMAIN="${DOMAIN}"
AWS_S3_BUCKET="${AWS_S3_BUCKET}"
APP_HOST="${APP_HOST}"
APP_PORT="${APP_PORT}"

if [ -z "$DOMAIN" ]; then
    echo "Error: DOMAIN environment variable is required"
    exit 1
fi

if [ -z "$AWS_S3_BUCKET" ]; then
    echo "Error: AWS_S3_BUCKET environment variable is required"
    exit 1
fi

if [ -z "$APP_HOST" ]; then
    echo "Error: APP_HOST environment variable is required"
    exit 1
fi

if [ -z "$APP_PORT" ]; then
    echo "Error: APP_PORT environment variable is required"
    exit 1
fi

echo "Generating nginx configuration with:"
echo "  DOMAIN: $DOMAIN"
echo "  AWS_S3_BUCKET: $AWS_S3_BUCKET"
echo "  APP_HOST: $APP_HOST"
echo "  APP_PORT: $APP_PORT"

envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf
envsubst < /etc/nginx/ssl.conf.tpl > /etc/nginx/conf.d/ssl.conf

# Test nginx configuration
echo "Testing nginx configuration..."
nginx -t

echo "Starting nginx..."
nginx -g 'daemon off;'
