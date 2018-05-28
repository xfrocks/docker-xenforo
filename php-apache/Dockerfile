FROM php:7.2.6-apache-stretch

ARG DOCKER_XENFORO_PHP_EXT_INSTALL
ARG DOCKER_XENFORO_PHP_PECL_INSTALL

# https://github.com/wimg/PHPCompatibility/releases
ENV PHP_COMPATIBILITY_VERSION 8.1.0

COPY ./build.sh /build.sh
COPY ./build_apache.sh /build_apache.sh
RUN /build.sh && rm /build*.sh
