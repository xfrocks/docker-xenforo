FROM php:7.2.8-fpm-alpine3.7

ARG DOCKER_XENFORO_PHP_EXT_INSTALL
ARG DOCKER_XENFORO_PHP_PECL_INSTALL

# https://tideways.com/profiler/downloads
ENV TIDEWAYS_VERSION 4.1.6

COPY . /tmp/.
RUN /tmp/build.sh
