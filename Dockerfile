FROM php:7.4-cli-alpine

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
    && curl -L https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o /usr/local/bin/install-php-extensions \
    && chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions swoole redis gd pdo_mysql @composer \
    && git clone https://github.com/swoole/sdebug.git -b sdebug_2_9 --depth=1 \
    && cd sdebug \
    && phpize && ./configure && make clean && make && make install \
    && cd .. \
    && rm -rf sdebug \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* \
    && apk add --no-cache freetype libpng libjpeg-turbo libstdc++ git