FROM nginxinc/nginx-unprivileged:1-alpine
LABEL maintainer="bryanberk.com"

COPY ./default.conf.tpl /etc/nginx/default.conf.tpl
COPY ./ssl.conf.tpl /etc/nginx/ssl.conf.tpl
COPY ./run.sh /run.sh

ENV LISTEN_PORT=80
ENV APP_HOST=app
ENV APP_PORT=8000
ENV DOMAIN=""
ENV EMAIL=""

USER root

RUN mkdir -p /etc/letsencrypt && \
    chmod 755 /etc/letsencrypt && \
    mkdir -p /var/lib/letsencrypt && \
    chmod 755 /var/lib/letsencrypt && \
    touch /etc/nginx/conf.d/default.conf && \
    chown nginx:nginx /etc/nginx/conf.d/default.conf && \
    touch /etc/nginx/conf.d/ssl.conf && \
    chown nginx:nginx /etc/nginx/conf.d/ssl.conf && \
    chmod +x /run.sh

VOLUME /etc/letsencrypt
VOLUME /var/lib/letsencrypt

USER nginx

CMD ["/run.sh"]
