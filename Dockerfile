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
    git \
    && pecl install swoole-v4.5.8 \
    && pecl install redis \
    && docker-php-ext-enable swoole redis \
    && docker-php-ext-install pdo_mysql pcntl posix bcmath zip sockets \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && cd / \
    && git clone https://github.com/swoole/sdebug.git -b sdebug_2_9 --depth=1 \
    && cd sdebug \
    && phpize && ./configure && make clean && make && make install \
    && echo zend_extension=xdebug.so > /usr/local/etc/php/conf.d/docker-php-ext-sdebug.ini \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* \
    && apk add --no-cache freetype libpng libjpeg-turbo libstdc++ \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer


