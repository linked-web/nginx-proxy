server {
    listen ${LISTEN_PORT};
    server_name ${DOMAIN};

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    # Only redirect to HTTPS if SSL_MODE is not "initial"
    location / {
        if (${SSL_MODE} != "initial") {
            return 301 https://$server_name$request_uri;
        }
        
        proxy_pass http://${APP_HOST}:${APP_PORT};
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect off;
        
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
        
        client_max_body_size 20M;
    }
}
