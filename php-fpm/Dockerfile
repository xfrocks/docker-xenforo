FROM php:7.2.0-fpm-alpine3.6

ARG DOCKER_XENFORO_PHP_EXT_INSTALL
ARG DOCKER_XENFORO_PHP_PECL_INSTALL

COPY ./build.sh /build.sh
RUN /build.sh && rm /build.sh
