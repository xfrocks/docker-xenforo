#!/bin/bash

set -e

RUN_PACKAGES=""
TMP_PACKAGES=""
TMP_PACKAGES="$TMP_PACKAGES libfreetype6-dev"        # gd
RUN_PACKAGES="$RUN_PACKAGES libgd3"                  # gd
TMP_PACKAGES="$TMP_PACKAGES libgd-dev"               # gd
RUN_PACKAGES="$RUN_PACKAGES libgmp10"                # gmp
TMP_PACKAGES="$TMP_PACKAGES libgmp-dev"              # gmp
RUN_PACKAGES="$RUN_PACKAGES libicu63"                # intl
TMP_PACKAGES="$TMP_PACKAGES libicu-dev"              # intl
TMP_PACKAGES="$TMP_PACKAGES libjpeg62-turbo-dev"     # gd
RUN_PACKAGES="$RUN_PACKAGES libmagickwand-6.q16"     # imagick
TMP_PACKAGES="$TMP_PACKAGES libmagickwand-6.q16-dev" # imagick
TMP_PACKAGES="$TMP_PACKAGES libmemcached-dev"        # memcached
RUN_PACKAGES="$RUN_PACKAGES libmemcachedutil2"       # memcached
TMP_PACKAGES="$TMP_PACKAGES libpng-dev"              # gd
RUN_PACKAGES="$RUN_PACKAGES libssl-dev"
RUN_PACKAGES="$RUN_PACKAGES libwebp6"                # gd
TMP_PACKAGES="$TMP_PACKAGES libwebp-dev"             # gd
RUN_PACKAGES="$RUN_PACKAGES libxml2-dev"             # soap
RUN_PACKAGES="$RUN_PACKAGES libxpm4"                 # gd
TMP_PACKAGES="$TMP_PACKAGES libxpm-dev"              # gd
RUN_PACKAGES="$RUN_PACKAGES libzip4"                 # zip
TMP_PACKAGES="$TMP_PACKAGES libzip-dev"              # zip
RUN_PACKAGES="$RUN_PACKAGES locales-all"
RUN_PACKAGES="$RUN_PACKAGES default-mysql-client"
TMP_PACKAGES="$TMP_PACKAGES git"
RUN_PACKAGES="$RUN_PACKAGES unzip"
eval "apt-get update && apt-get install --no-install-recommends -y $TMP_PACKAGES $RUN_PACKAGES"

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

# for improved ASLR and optimizations
# https://github.com/docker-library/php/issues/105#issuecomment-278114879
export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS"

docker-php-source extract
eval "docker-php-ext-install $DOCKER_XENFORO_PHP_EXT_INSTALL"
eval "pecl install imagick $DOCKER_XENFORO_PHP_PECL_INSTALL"
eval "docker-php-ext-enable imagick $DOCKER_XENFORO_PHP_PECL_INSTALL"
/tmp/build_apache.sh
docker-php-source delete

# clean up
pecl clear-cache
rm -rf /tmp/* /var/lib/apt/lists/*
eval apt-mark manual "$RUN_PACKAGES"
eval "apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $TMP_PACKAGES"
