FROM php:apache

RUN docker-php-ext-install -j$(nproc) opcache \
	&& ( \
    echo "opcache.revalidate_freq=0"; \
    ) > /usr/local/etc/php/conf.d/opcache-fast.ini

RUN apt-get update && apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmagickwand-6.q16-dev \
        libmcrypt-dev \
        libpng12-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
    	gd \
    	mcrypt \
    	mysqli \
    && pecl install imagick \
    && docker-php-ext-enable imagick