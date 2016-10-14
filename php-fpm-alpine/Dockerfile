FROM php:7.0.11-fpm-alpine

RUN apk upgrade --update \
	&& apk add freetype-dev libjpeg-turbo-dev libpng-dev \
		autoconf g++ imagemagick-dev libtool make \
		libmcrypt-dev \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
		--with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd \
		exif \
		ftp \
		mbstring \
		mcrypt \
		mysqli \
	&& pecl install imagick \
	&& docker-php-ext-enable imagick \
	&& apk del autoconf g++ libtool make \
	&& rm -rf /tmp/* /var/cache/apk/*