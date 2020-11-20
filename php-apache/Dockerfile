# https://github.com/docker-library/docs/blob/master/php/README.md#supported-tags-and-respective-dockerfile-links
FROM php:7.4.12-apache-buster

ARG DOCKER_XENFORO_PHP_EXT_INSTALL
ARG DOCKER_XENFORO_PHP_PECL_INSTALL

# https://hub.docker.com/_/composer/
COPY --from=composer:2.0.7 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 2.0.7

# https://github.com/wimg/PHPCompatibility/releases
ENV PHP_COMPATIBILITY_VERSION 9.3.5

COPY tmp /tmp
RUN /tmp/build.sh

COPY apache2 /etc/apache2
