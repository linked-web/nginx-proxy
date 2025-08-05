server {
    listen ${LISTEN_PORT};
    server_name ${DOMAIN};

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    # Only redirect to HTTPS if SSL_MODE is not "initial"
    location / {
        return 301 https://$server_name$request_uri;
    }
}
