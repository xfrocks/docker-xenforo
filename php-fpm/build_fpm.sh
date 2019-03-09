#!/bin/bash

set -e

# xdebug: installed but disabled on php-fpm
sed -i'' 's/^/;/' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
