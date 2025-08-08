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

render_http() {
    # Use envsubst with specific variables to avoid substituting nginx variables
    envsubst '${DOMAIN} ${AWS_S3_BUCKET} ${APP_HOST} ${APP_PORT} ${LISTEN_PORT}' \
        < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf
}

render_ssl_if_present() {
    CERT_DIR="/etc/letsencrypt/live/${DOMAIN}"
    if [ -f "${CERT_DIR}/fullchain.pem" ] && [ -f "${CERT_DIR}/privkey.pem" ]; then
    # Use envsubst with specific variables to avoid substituting nginx variables
        envsubst '${DOMAIN} ${AWS_S3_BUCKET} ${APP_HOST} ${APP_PORT} ${LISTEN_PORT}' \
        < /etc/nginx/ssl.conf.tpl > /etc/nginx/conf.d/ssl.conf
        return 0
    else
        # Ensure NO TLS server block is loaded at all
        rm -f /etc/nginx/conf.d/ssl.conf
        return 1
    fi
}

if [ "$1" = "--render-ssl-and-reload" ]; then
    if render_ssl_if_present; then
        nginx -s reload
        exit 0
    else
        echo "SSL certs not found; cannot render TLS config."
        exit 1
    fi
fi

render_http
render_ssl_if_present || echo "Starting without TLS (certs not present yet)."

echo "Conf.d contents:"
ls -l /etc/nginx/conf.d || true
[ -f /etc/nginx/conf.d/ssl.conf ] && { echo "--- ssl.conf ---"; sed -n '1,120p' /etc/nginx/conf.d/ssl.conf; echo "----------------"; }

# Test nginx configuration
echo "Testing nginx configuration..."
nginx -t

echo "Starting nginx..."
nginx -g 'daemon off;'
