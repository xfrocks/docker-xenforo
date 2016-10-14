FROM php:7.0.11-fpm-alpine

ENV PHPREDIS_VERSION 3.0.0

RUN apk add --update freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev \
		cyrus-sasl-dev libmemcached-dev zlib-dev \
		libmcrypt-dev \
		autoconf g++ imagemagick-dev libtool make \
	&& docker-php-ext-configure gd \
		--with-freetype-dir=/usr/include/ \
		--with-jpeg-dir=/usr/include/ \
		--with-png-dir=/usr/include/ \
		--with-webp-dir=/usr/include/ \
		&& docker-php-ext-install gd \
	&& mkdir -p /usr/src/php/ext/redis \
		&& curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
		&& echo 'redis' >> /usr/src/php-available-exts \
		&& docker-php-ext-install redis \
	&& curl -sSL -A "Docker" -D - -o /tmp/ext-memcached.tgz https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz \
		&& tar zxpf /tmp/ext-memcached.tgz -C /tmp \
		&& cd /tmp/php-memcached-php7 \
		&& phpize \
		&& ./configure \
			--disable-memcached-sasl \
			--with-zlib-dir=/usr \
		&& make \
		&& make install \
		&& docker-php-ext-enable memcached \
	&& docker-php-ext-install curl \
	&& docker-php-ext-install exif \
	&& docker-php-ext-install ftp \
	&& docker-php-ext-install iconv \
	&& docker-php-ext-install mbstring \
	&& docker-php-ext-install mcrypt \
	&& docker-php-ext-install mysqli \
	&& docker-php-ext-install simplexml \
	&& docker-php-ext-install xml \
	&& docker-php-ext-install zip \
	&& pecl install imagick \
	&& docker-php-ext-enable imagick \
	&& apk del autoconf g++ libtool make \
	&& rm -rf /tmp/* /var/cache/apk/*