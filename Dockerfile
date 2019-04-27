FROM php:7.2-fpm-alpine

COPY php.ini /usr/local/etc/php/

RUN apk upgrade --update \
    && apk add --no-cache --virtual .build-deps \
    coreutils \
    freetype-dev libjpeg-turbo-dev libltdl libpng-dev \
    linux-headers \
    autoconf \
    gcc \
    glibc-headers \
    gcc-c++ \
    libc-dev \
    make \
    git \
    && git clone https://github.com/redis/hiredis.git /hiredis \
    && cd /hiredis \
    && make -j$(nproc) \
    && make install > /dev/null 2>&1 \
    && git clone https://github.com/swoole/swoole-src.git /swoole-src \
    && ( \
        cd /swoole-src \
        && git checkout v4.3.3 \
        && phpize \
        && ./configure \
        && make -j$(nproc) && make install \
        ) \
    && docker-php-ext-enable swoole \
    && rm -r /swoole-src \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* \
    && apk add --no-cache freetype libpng libjpeg-turbo


