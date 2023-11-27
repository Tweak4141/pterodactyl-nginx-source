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
RUN apk add --no-cache mysql-client msmtp perl wget procps shadow libzip libpng libjpeg-turbo libwebp freetype icu icu-data-full

RUN apk add --no-cache --virtual build-essentials \
    icu-dev icu-libs zlib-dev g++ make automake autoconf libzip-dev \
    libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install gd && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install intl && \
    docker-php-ext-install opcache && \
    docker-php-ext-install exif && \
    docker-php-ext-install zip && \
    apk del build-essentials && rm -rf /usr/src/php*

RUN wget https://getcomposer.org/composer-stable.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer

RUN npm install -g yarn --force

ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 python3-dev 
# python2-dev
# RUN python3 -m ensurepip
# RUN pip3 install --no-cache --upgrade pip setuptools
# RUN apk add --update --no-cache python2 
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
