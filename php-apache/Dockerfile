FROM php:7.2.3-apache-stretch

ARG DOCKER_XENFORO_PHP_EXT_INSTALL
ARG DOCKER_XENFORO_PHP_PECL_INSTALL
ENV PHP_COMPATIBILITY_VERSION 8.0.1

COPY ./build.sh /build.sh
COPY ./build_apache.sh /build_apache.sh
RUN /build.sh && rm /build*.sh
