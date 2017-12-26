#!/bin/sh

set -e

RUN_PACKAGES=""
TMP_PACKAGES=""
TMP_PACKAGES="$TMP_PACKAGES autoconf"
RUN_PACKAGES="$RUN_PACKAGES cyrus-sasl-dev"     # memcached
TMP_PACKAGES="$TMP_PACKAGES freetype-dev"       # gd
TMP_PACKAGES="$TMP_PACKAGES g++"
RUN_PACKAGES="$RUN_PACKAGES gd"                 # gd
TMP_PACKAGES="$TMP_PACKAGES gd-dev"             # gd
TMP_PACKAGES="$TMP_PACKAGES git"
TMP_PACKAGES="$TMP_PACKAGES libjpeg-turbo-dev"  # gd
RUN_PACKAGES="$RUN_PACKAGES libltdl"            # gd?
RUN_PACKAGES="$RUN_PACKAGES libmcrypt-dev"      # mcrypt
RUN_PACKAGES="$RUN_PACKAGES libmemcached"       # memcached
TMP_PACKAGES="$TMP_PACKAGES libmemcached-dev"   # memcached
TMP_PACKAGES="$TMP_PACKAGES libpng-dev"         # gd
TMP_PACKAGES="$TMP_PACKAGES libtool"
RUN_PACKAGES="$RUN_PACKAGES libwebp"            # gd
TMP_PACKAGES="$TMP_PACKAGES libwebp-dev"        # gd
RUN_PACKAGES="$RUN_PACKAGES libxml2-dev"        # xml
RUN_PACKAGES="$RUN_PACKAGES libxpm"             # gd
TMP_PACKAGES="$TMP_PACKAGES libxpm-dev"         # gd
TMP_PACKAGES="$TMP_PACKAGES make"
eval "apk add --update --no-cache $TMP_PACKAGES $RUN_PACKAGES"

case "$DOCKER_XENFORO_PHP_EXT_INSTALL" in 
  *gd*)
    echo 'Preparing module: gd...'
    docker-php-ext-configure gd \
        --with-gd=/usr/include \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-webp-dir=/usr/include/ \
        --with-xpm-dir=/usr/include
    ;;
esac

case "$DOCKER_XENFORO_PHP_EXT_INSTALL" in
  *tideways*)
    echo 'Preparing module: tideways...'

    git clone https://github.com/tideways/php-profiler-extension /usr/src/php/ext/tideways/
    docker-php-ext-configure tideways

    echo 'tideways.auto_start=0' >> /usr/local/etc/php/conf.d/zzz-tideways.ini
    echo 'tideways.auto_prepend_library=0' >> /usr/local/etc/php/conf.d/zzz-tideways.ini
    ;;
esac

# for improved ASLR and optimizations
# https://github.com/docker-library/php/issues/105#issuecomment-278114879
export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS"

docker-php-source extract
eval "docker-php-ext-install $DOCKER_XENFORO_PHP_EXT_INSTALL"
eval "pecl install $DOCKER_XENFORO_PHP_PECL_INSTALL"
eval "docker-php-ext-enable $DOCKER_XENFORO_PHP_PECL_INSTALL"
docker-php-source delete

# clean up
pecl clear-cache
eval "apk del $TMP_PACKAGES"
rm -rf /tmp/* /var/cache/apk/*
