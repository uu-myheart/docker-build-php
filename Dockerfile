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
    && pecl install swoole \
    && pecl install redis \
    && docker-php-ext-enable swoole redis \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-install -j$(nproc) gd \
    && git clone https://github.com/swoole/sdebug.git -b sdebug_2_9 --depth=1 \
    && cd sdebug \
    && phpize && ./configure && make clean && make && make install \
    && cd .. \
    && rm -rf sdebug \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* \
    && apk add --no-cache freetype libpng libjpeg-turbo libstdc++ git \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer