#!/bin/sh

set -e

DIR=$( pwd )
NETWORK="docker-xenforo-test"

{
    docker network create "$NETWORK" || true
} &> /dev/null



CONTAINER_ID_MYSQL="$( docker ps -qf "name=$NETWORK-mysql" )"
if [ -z "$CONTAINER_ID_MYSQL" ]; then
    MYSQL_ATTEMPT="$(
        docker run --network "$NETWORK" \
            --name "$NETWORK-mysql" \
            -e MYSQL_RANDOM_ROOT_PASSWORD=1 \
            -e MYSQL_USER=user \
            -e MYSQL_PASSWORD=password \
            -e MYSQL_DATABASE=db \
            -d mysql:5.7 2>&1 \
        || docker restart "$NETWORK-mysql" \
    )"
    echo 'Waiting for mysql...'
    sleep 5

    CONTAINER_ID_MYSQL="$( docker ps -qf name="$NETWORK-mysql" )"
    if [ -z "$CONTAINER_ID_MYSQL" ]; then
        echo "$MYSQL_ATTEMPT"
        echo 'Cannot start mysql container'
        exit 1
    fi
fi
CONTAINER_HOSTNAME_MYSQL="$( docker inspect --format '{{.Config.Hostname}}' "$CONTAINER_ID_MYSQL" )"



CONTAINER_ID_REDIS="$( docker ps -qf "name=$NETWORK-redis" )"
if [ -z "$CONTAINER_ID_REDIS" ]; then
    REDIS_ATTEMPT="$(
        docker run --network "$NETWORK" \
            --name "$NETWORK-redis" \
            -d redis 2>&1 \
        || docker restart "$NETWORK-redis"
    )"

    CONTAINER_ID_REDIS="$( docker ps -qf name="$NETWORK-redis" )"
    if [ -z "$CONTAINER_ID_REDIS" ]; then
        echo "$REDIS_ATTEMPT"
        echo 'Cannot start redis container'
        exit 1
    fi
fi
CONTAINER_HOSTNAME_REDIS="$( docker inspect --format '{{.Config.Hostname}}' "$CONTAINER_ID_REDIS" )"



cd "$DIR"
{ \
    echo "FROM $IMAGE_TAG_FOR_TESTING"; \
    echo "COPY . /tests"; \
} > Dockerfile
IMAGE_TAG_TMP="$IMAGE_TAG_FOR_TESTING-tmp"
docker build -t "$IMAGE_TAG_TMP" .
CONTAINER_ID_TARGET="$( docker run \
    --network "$NETWORK" \
    -e IMAGE_TAG_FOR_TESTING="$IMAGE_TAG_FOR_TESTING" \
    -e MYSQL="$CONTAINER_HOSTNAME_MYSQL" \
    -e REDIS="$CONTAINER_HOSTNAME_REDIS" \
    -d "$IMAGE_TAG_TMP"
)"
docker exec "$CONTAINER_ID_TARGET" ls -al



for d in */ ; do
    if [ -f "$DIR/$d/test.php" ]; then
        echo "Testing $d..."
        docker exec "$CONTAINER_ID_TARGET" php -c /tests/php.ini "/tests/${d}test.php"
    fi
done



echo 'Cleaning up...'
{
    docker stop "$CONTAINER_ID_MYSQL" "$CONTAINER_ID_REDIS" "$CONTAINER_ID_TARGET"
    docker rm -f "$CONTAINER_ID_MYSQL" "$CONTAINER_ID_REDIS" "$CONTAINER_ID_TARGET"
    docker network rm "$NETWORK" || true
} &> /dev/null
echo 'All done!'
