FROM php:7.2.1-fpm-alpine3.7

ARG DOCKER_XENFORO_PHP_EXT_INSTALL
ARG DOCKER_XENFORO_PHP_PECL_INSTALL

COPY ./build.sh /build.sh
RUN /build.sh && rm /build.sh
