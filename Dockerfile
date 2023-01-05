FROM alpine:3.15

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
    curl 
    
RUN apk add --no-cache \
  php81 \
  php81-ctype \
  php81-curl \
  php81-dom \
  php81-fpm \
  php81-gd \
  php81-intl \
  php81-mbstring \
  php81-mysqli \
  php81-opcache \
  php81-openssl \
  php81-phar \
  php81-session \
  php81-xml \
  php81-xmlreader 
 
RUN wget https://nginx.org/download/nginx-1.23.3.tar.gz \
 && tar zxf nginx-1.23.3.tar.gz \
 && cd nginx-1.23.3 \
 && ./configure \
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

CMD ["/bin/ash", "/entrypoint.sh"]
