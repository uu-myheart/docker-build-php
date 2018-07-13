FROM php:7.2-fpm-alpine

RUN apk upgrade --update \
    && apk add --no-cache --virtual .build-deps \
    linux-headers \
    autoconf \
    gcc \
    libc-dev \
    make \
    git \
    && git clone https://github.com/swoole/swoole-src.git \
    && ( \
        cd swoole-src \
        && git checkout v2.2.0 \
        && phpize \
        && ./configure \
        && make -j$(nproc) && make install \
        ) \
    && rm -r /swoole-src \
    && docker-php-ext-enable swoole \
    && docker-php-ext-install pdo_mysql \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* 