FROM nginxinc/nginx-unprivileged:1-alpine
LABEL maintainer="bryanberk.com"

COPY ./default.conf.tpl /etc/nginx/default.conf.tpl
COPY ./ssl.conf.tpl /etc/nginx/ssl.conf.tpl
COPY ./run.sh /usr/local/bin/run.sh

ENV LISTEN_PORT=80
ENV APP_HOST=app
ENV APP_PORT=8000
ENV DOMAIN=""
ENV EMAIL=""
ENV SSL_MODE="initial"

USER root

RUN mkdir -p /vol/static && \
    chmod 755 /vol/static && \
    mkdir -p /etc/letsencrypt && \
    chmod 755 /etc/letsencrypt && \
    mkdir -p /var/lib/letsencrypt && \
    chmod 755 /var/lib/letsencrypt && \
    mkdir -p /var/www/certbot && \
    chmod 755 /var/www/certbot && \
    touch /etc/nginx/conf.d/default.conf && \
    chown nginx:nginx /etc/nginx/conf.d/default.conf && \
    touch /etc/nginx/conf.d/ssl.conf && \
    chown nginx:nginx /etc/nginx/conf.d/ssl.conf && \
    chmod +x /usr/local/bin/run.sh && \
    chown nginx:nginx /usr/local/bin/run.sh

VOLUME /vol/static
VOLUME /etc/letsencrypt
VOLUME /var/lib/letsencrypt
VOLUME /var/www/certbot

USER nginx

CMD ["/usr/local/bin/run.sh"]
