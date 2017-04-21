#!/bin/sh

set -e

RUN_PACKAGES=""
TMP_PACKAGES=""
RUN_PACKAGES="$RUN_PACKAGES libfreetype6-dev"        # gd
RUN_PACKAGES="$RUN_PACKAGES libjpeg62-turbo-dev"     # gd
RUN_PACKAGES="$RUN_PACKAGES libmagickwand-6.q16-dev" # imagick
RUN_PACKAGES="$RUN_PACKAGES libmcrypt-dev"           # mcrypt
TMP_PACKAGES="$TMP_PACKAGES libmemcached-dev"        # memcached
RUN_PACKAGES="$RUN_PACKAGES libmemcached11"          # memcached
RUN_PACKAGES="$RUN_PACKAGES libmemcachedutil2"       # memcached
RUN_PACKAGES="$RUN_PACKAGES libpng12-dev"            # gd
RUN_PACKAGES="$RUN_PACKAGES libssl-dev"
RUN_PACKAGES="$RUN_PACKAGES libwebp-dev"             # gd
TMP_PACKAGES="$TMP_PACKAGES git"
RUN_PACKAGES="$RUN_PACKAGES zlib1g-dev"              # memcached
eval "apt-get update && apt-get install --no-install-recommends -y $TMP_PACKAGES $RUN_PACKAGES"

case "$DOCKER_XENFORO_PHP_EXT_INSTALL" in 
  *gd*)
    echo 'Preparing module: gd...'
    docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-webp-dir=/usr/include/
    ;;
esac

case "$DOCKER_XENFORO_PHP_EXT_INSTALL" in 
  *memcached*)
    echo 'Preparing module: memcached...'
    git clone --branch php7 https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached/
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
eval "pecl install xdebug $DOCKER_XENFORO_PHP_PECL_INSTALL"
eval "docker-php-ext-enable $DOCKER_XENFORO_PHP_PECL_INSTALL"
docker-php-source delete

# clean up
rm -rf /tmp/* /var/lib/apt/lists/*
eval apt-mark manual "$RUN_PACKAGES"
eval "apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $TMP_PACKAGES"

# No longer enable mod_rewrite for apache images
# It's much more simple to just use `FallbackResource /index.php` for XenForo
# and maybe `FallbackResource /api/index.php` for [bd] API
# a2enmod rewrite
