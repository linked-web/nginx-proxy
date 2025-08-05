FROM nginxinc/nginx-unprivileged:1-alpine
LABEL maintainer="bryanberk.com"

COPY ./default.conf.tpl /etc/nginx/default.conf.tpl
COPY ./ssl.conf.tpl /etc/nginx/ssl.conf.tpl
COPY ./run.sh /run.sh

ENV LISTEN_PORT=80
ENV APP_PORT=8000
ENV DOMAIN=""
ENV EMAIL=""

USER root

RUN touch /etc/nginx/conf.d/default.conf && \
    touch /etc/nginx/conf.d/ssl.conf && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    chmod +x /run.sh

VOLUME /vol/static
VOLUME /etc/letsencrypt

USER nginx

CMD ["/run.sh"]
