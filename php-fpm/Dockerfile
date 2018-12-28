FROM php:7.2.13-fpm-alpine3.8

ARG DOCKER_XENFORO_PHP_EXT_INSTALL
ARG DOCKER_XENFORO_PHP_PECL_INSTALL

# https://tideways.com/profiler/downloads
ENV TIDEWAYS_VERSION 4.1.6

COPY . /tmp/.
RUN /tmp/build.sh
