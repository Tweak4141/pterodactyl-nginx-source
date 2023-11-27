ARG NODE_VERSION=18.16.0
ARG ALPINE_VERSION=3.16

FROM node:${NODE_VERSION}-alpine AS node
FROM php:8.1-fpm-alpine3.15
COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories
RUN docker-php-ext-install mysqli
RUN apk update && \
    apk add bash build-base gcc wget git autoconf libmcrypt-dev libzip-dev zip \
    g++ make openssl-dev \
    php81-openssl \
    php81-pdo_mysql \
    php81-mbstring

RUN npm install -g yarn --force

ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 python3-dev python2-dev
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
RUN apk add --update --no-cache python2 
#&& ln -sf python2 /usr/bin/python

RUN apk --update --no-cache add ca-certificates
RUN apk add \
    build-base \
    pcre \
    pcre-dev \
    openssl \
    openssl-dev \
    zlib \
    zlib-dev \
    tar \
    bash \
    wget \
    curl \
    git \
    bash \ 
    build-base \
    g++ \
    cairo-dev \
    jpeg-dev \
    pango-dev \
    giflib-dev \
    opencv 
    
 
RUN git clone https://github.com/aperezdc/ngx-fancyindex.git ngx-fancyindex \
 && wget https://nginx.org/download/nginx-1.23.3.tar.gz \
 && tar zxf nginx-1.23.3.tar.gz \
 && cd nginx-1.23.3 \
 && ./configure \
    --add-module=../ngx-fancyindex \
    --with-http_mp4_module \
    --with-http_sub_module \
    --prefix=/var/www/html \
    --sbin-path=/usr/sbin/nginx \
    --http-log-path=/home/container/nginx/access.log \
    --error-log-path=/home/container/nginx/error.log \
    --with-pcre \
    --lock-path=/var/lock/nginx.lock \
    --pid-path=/var/run/nginx.pid \
    --with-http_ssl_module \
    --modules-path=/etc/nginx/modules \
    --with-http_v2_module \
    --with-stream=dynamic \
    --with-http_addition_module \
&& make \
&& make install

USER container
ENV  USER container
ENV HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
COPY ./startup /home/container/startup

CMD ["/bin/ash", "/entrypoint.sh"]
