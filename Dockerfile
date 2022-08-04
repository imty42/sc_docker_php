FROM php:7.2-fpm

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
        libpng-dev libjpeg-dev libwebp-dev libfreetype6-dev libjpeg62-turbo-dev \
        ntpdate cron unzip vim procps \
    && apt-get install -y libicu-dev \
    && apt-get install -y libxml2-dev \
    && apt-get install -y libcurl4-openssl-dev pkg-config libssl-dev \
    && docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ --with-webp-dir=/usr/include/ --with-freetype-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install intl \
    && docker-php-ext-install exif \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install shmop \
    && docker-php-ext-install soap \
    && docker-php-ext-install sockets \
    && docker-php-ext-install sysvsem \
    && docker-php-ext-install xmlrpc \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install opcache


RUN apt-get install -y --no-install-recommends libzip-dev \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-install -j$(nproc) zip

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
