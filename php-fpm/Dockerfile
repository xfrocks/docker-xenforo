# https://github.com/docker-library/docs/blob/master/php/README.md#supported-tags-and-respective-dockerfile-links
FROM php:7.4.12-fpm-alpine3.12

ARG DOCKER_XENFORO_PHP_EXT_INSTALL
ARG DOCKER_XENFORO_PHP_PECL_INSTALL

COPY . /tmp/.
RUN /tmp/build.sh
