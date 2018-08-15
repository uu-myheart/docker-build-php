FROM php:5.6-fpm-alpine

RUN apk upgrade --update \
    && apk add --no-cache --virtual .build-deps \
    coreutils \
    freetype-dev \
    libjpeg-turbo-dev \
    libltdl \
    libmcrypt-dev \
    libpng-dev \
    linux-headers \
    autoconf \
    gcc \
    libc-dev \
    make \
    git \
    && git clone https://github.com/swoole/swoole-src.git /swoole-src \
    && ( \
        cd /swoole-src \
        && git checkout v2.0.10-stable \
        && phpize \
        && ./configure \
        && make -j$(nproc) && make install \
        ) \
    && docker-php-ext-enable swoole \
    && rm -r /swoole-src \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* 


