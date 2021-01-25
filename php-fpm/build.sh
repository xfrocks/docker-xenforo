#!/bin/sh

set -e

RUN_PACKAGES=""
TMP_PACKAGES=""
TMP_PACKAGES="$TMP_PACKAGES autoconf"
RUN_PACKAGES="$RUN_PACKAGES bash"
RUN_PACKAGES="$RUN_PACKAGES cyrus-sasl-dev"     # memcached
TMP_PACKAGES="$TMP_PACKAGES freetype-dev"       # gd
TMP_PACKAGES="$TMP_PACKAGES g++"
RUN_PACKAGES="$RUN_PACKAGES gd"                 # gd
TMP_PACKAGES="$TMP_PACKAGES gd-dev"             # gd
TMP_PACKAGES="$TMP_PACKAGES git"
RUN_PACKAGES="$RUN_PACKAGES gmp"                # gmp
TMP_PACKAGES="$TMP_PACKAGES gmp-dev"            # gmp
RUN_PACKAGES="$RUN_PACKAGES imagemagick"        # imagick
TMP_PACKAGES="$TMP_PACKAGES imagemagick-dev"    # imagick
TMP_PACKAGES="$TMP_PACKAGES libjpeg-turbo-dev"  # gd
RUN_PACKAGES="$RUN_PACKAGES libltdl"            # gd?
RUN_PACKAGES="$RUN_PACKAGES libmemcached"       # memcached
TMP_PACKAGES="$TMP_PACKAGES libmemcached-dev"   # memcached
TMP_PACKAGES="$TMP_PACKAGES libpng-dev"         # gd
TMP_PACKAGES="$TMP_PACKAGES libtool"
RUN_PACKAGES="$RUN_PACKAGES libwebp"            # gd
TMP_PACKAGES="$TMP_PACKAGES libwebp-dev"        # gd
RUN_PACKAGES="$RUN_PACKAGES libxml2-dev"        # soap
RUN_PACKAGES="$RUN_PACKAGES libxpm"             # gd
TMP_PACKAGES="$TMP_PACKAGES libxpm-dev"         # gd
RUN_PACKAGES="$RUN_PACKAGES libzip"             # zip
TMP_PACKAGES="$TMP_PACKAGES libzip-dev"         # zip
TMP_PACKAGES="$TMP_PACKAGES make"
eval "apk add --update --no-cache $TMP_PACKAGES $RUN_PACKAGES"

case "$DOCKER_XENFORO_PHP_EXT_INSTALL" in 
  *gd*)
    echo 'Preparing module: gd...'
    docker-php-ext-configure gd \
        --enable-gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
        --with-xpm
    ;;
esac

# for improved ASLR and optimizations
# https://github.com/docker-library/php/issues/105#issuecomment-278114879
export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS"

docker-php-source extract
eval "docker-php-ext-install $DOCKER_XENFORO_PHP_EXT_INSTALL"
eval "pecl install $DOCKER_XENFORO_PHP_PECL_INSTALL"
eval "docker-php-ext-enable $DOCKER_XENFORO_PHP_PECL_INSTALL"
/tmp/build_fpm.sh
docker-php-source delete

# clean up
pecl clear-cache
eval "apk del $TMP_PACKAGES"
rm -rf /tmp/* /var/cache/apk/*
