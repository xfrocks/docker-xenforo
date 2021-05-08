# https://hub.docker.com/_/php/
FROM php:8.0.6-fpm-alpine3.13

ARG DOCKER_XENFORO_PHP_EXT_INSTALL
ARG DOCKER_XENFORO_PHP_PECL_INSTALL

COPY . /tmp/.
RUN /tmp/build.sh
