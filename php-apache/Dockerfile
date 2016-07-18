FROM php:apache

RUN apt-get update && apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmagickwand-6.q16-dev \
        libmcrypt-dev \
        libpng12-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
        exif \
        ftp \
        gd \
        mcrypt \
        mysqli \
    && pecl install imagick \
    && docker-php-ext-enable imagick

RUN a2enmod rewrite