#!/bin/bash

_filter="$1"
_test="${TEST:-yes}"
_push="$PUSH"

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
TESTS_DIR="$DIR/tests"

EXT_INSTALL="exif gd mysqli opcache pcntl zip"
PECL_INSTALL="apcu igbinary memcached redis"

for d in */ ; do
    cd "$DIR/$d"
    if [ ! -f Dockerfile ]; then
        continue
    fi
    if [ ! -z "$_filter" -a "x$d" != "x$_filter" ]; then
        echo "Skipped $d (_filter == $_filter)" >&2
        continue
    fi

    echo "Building $d..."

    IS_PHP=0
    if [[ $d == php* ]]; then
        IS_PHP=1
    fi
    VERSION="$( head -n 1 "VERSION" )"
    TAG="xfrocks/xenforo:${d%?}"
    TAG_WITH_VERSION="$TAG-$VERSION"

    docker build \
        --build-arg DOCKER_XENFORO_PHP_EXT_INSTALL="$EXT_INSTALL" \
        --build-arg DOCKER_XENFORO_PHP_PECL_INSTALL="$PECL_INSTALL" \
        -t "$TAG" \
        -t "$TAG_WITH_VERSION" \
        . > build.log

    if [ "$IS_PHP" -gt 0 ]; then
        if [ "x$_test" = 'xyes' ]; then
            echo "Testing..."
            eval "IMAGE_TAG_FOR_TESTING=$TAG_WITH_VERSION $TESTS_DIR/run.sh > test.log"
        else
            echo "Skipped testing (TEST == $_test)" >&2
        fi
    fi

    if [ "x$_push" = 'xyes' ]; then
        echo "Pushing..."
        ( \
            docker push "$TAG" && \
            docker push "$TAG_WITH_VERSION" \
        ) > push.log
    else
        echo 'Skipped pushing, export PUSH=yes before building to do it' >&2
    fi
done
