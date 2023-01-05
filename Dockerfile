FROM alpine:3.16

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
    php81-bcmath \
    php81-bz2 \
    php81-calendar \
    php81-cgi \
    php81-common \
    php81-ctype \
    php81-curl \
    php81-dba \
    php81-dom \
    php81-embed \
    php81-enchant \
    php81-exif \
    php81-ffi \
    php81-fileinfo \
    php81-fpm \
    php81-ftp \
    php81-gd \
    php81-gettext \
    php81-gmp \
    php81-iconv \
    php81-imap \
    php81-intl \
    php81-ldap \
    php81-litespeed \
    php81-mbstring \
    php81-mysqli \
    php81-mysqlnd \
    php81-odbc \
    php81-opcache \
    php81-openssl \
    php81-pcntl \
    php81-pdo \
    php81-pdo_dblib \
    php81-pdo_mysql \
    php81-pdo_odbc \
    php81-pdo_pgsql \
    php81-pdo_sqlite \
    php81-pear \
    php81-pgsql \
    php81-phar \
    php81-phpdbg \
    php81-posix \
    php81-pspell \
    php81-session \
    php81-shmop \
    php81-simplexml \
    php81-snmp \
    php81-soap \
    php81-sockets \
    php81-sodium \
    php81-sqlite3 \
    php81-sysvmsg \
    php81-sysvsem \
    php81-sysvshm \
    php81-tidy \
    php81-tokenizer \
    php81-xml \
    php81-xmlreader \
    php81-xmlwriter \
    php81-xsl \
    php81-zip
 
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
