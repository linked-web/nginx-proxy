FROM nginx:alpine
LABEL maintainer="bryanberk.com"

COPY ./default.conf.tpl /etc/nginx/default.conf.tpl
COPY ./ssl.conf.tpl /etc/nginx/ssl.conf.tpl
COPY ./run.sh /run.sh

ENV LISTEN_PORT=80
ENV APP_HOST=app
ENV APP_PORT=8000
ENV DOMAIN=""
ENV EMAIL=""
ENV AWS_S3_BUCKET=""

RUN chmod +x /run.sh

CMD ["sh", "/run.sh"]
