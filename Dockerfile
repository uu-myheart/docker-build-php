FROM php:7.2-fpm-alpine

COPY php.ini /usr/local/etc/php/

RUN apk upgrade --update \
    && apk add --no-cache --virtual .build-deps \
    coreutils \
    freetype-dev libjpeg-turbo-dev libltdl libpng-dev \
    linux-headers \
    autoconf \
    gcc \
    g++ \
    libc-dev \
    make \
    && pecl install swoole-4.3.3 \
    && pecl install redis \
    && docker-php-ext-enable swoole redis \
    && docker-php-ext-install pdo_mysql pcntl posix bcmath \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* \
    && apk add --no-cache freetype libpng libjpeg-turbo libstdc++


