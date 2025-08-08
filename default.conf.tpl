server {
    listen ${LISTEN_PORT};
    server_name ${DOMAIN};

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://$$server_name$$request_uri;
    }
}
