# https://hub.docker.com/_/php/
FROM php:8.2.7-apache-bookworm

ARG DOCKER_XENFORO_PHP_EXT_INSTALL
ARG DOCKER_XENFORO_PHP_PECL_INSTALL

# https://hub.docker.com/_/composer/
COPY --from=composer:2.0.7 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 2.0.7

COPY tmp /tmp
RUN /tmp/build.sh

COPY apache2 /etc/apache2
