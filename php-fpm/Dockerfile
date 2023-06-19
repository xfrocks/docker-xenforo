# https://hub.docker.com/_/php/
FROM php:8.2.7-fpm-alpine3.18

ARG DOCKER_XENFORO_PHP_EXT_INSTALL
ARG DOCKER_XENFORO_PHP_PECL_INSTALL

COPY . /tmp/.
RUN /tmp/build.sh
