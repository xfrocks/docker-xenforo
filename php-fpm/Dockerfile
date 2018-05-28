FROM php:7.2.6-fpm-alpine3.7

ARG DOCKER_XENFORO_PHP_EXT_INSTALL
ARG DOCKER_XENFORO_PHP_PECL_INSTALL

# https://tideways.com/profiler/downloads
ENV TIDEWAYS_VERSION 4.1.6

COPY ./build.sh /build.sh
COPY ./build_fpm.sh /build_fpm.sh
RUN /build.sh && rm /build*.sh
