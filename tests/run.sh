#!/bin/sh

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
NETWORK="docker-xenforo-test"

{
    docker network create "$NETWORK" || true
} &> /dev/null



CONTAINER_ID_MYSQL="$( docker ps -qf "name=$NETWORK-mysql" )"
if [ -z "$CONTAINER_ID_MYSQL" ]; then
    {
        docker run --network "$NETWORK" --name "$NETWORK-mysql" \
            -e MYSQL_RANDOM_ROOT_PASSWORD=1 \
            -e MYSQL_USER=user \
            -e MYSQL_PASSWORD=password \
            -e MYSQL_DATABASE=db \
            -d mysql || docker restart "$NETWORK-mysql"
    } &> /dev/null
    sleep 5
    CONTAINER_ID_MYSQL="$( docker ps -qf name="$NETWORK-mysql" )"
fi
if [ -z "$CONTAINER_ID_MYSQL" ]; then
    echo 'Cannot start mysql container'
    exit 1
fi
CONTAINER_HOSTNAME_MYSQL="$( docker inspect --format '{{.Config.Hostname}}' "$CONTAINER_ID_MYSQL" )"



CONTAINER_ID_REDIS="$( docker ps -qf "name=$NETWORK-redis" )"
if [ -z "$CONTAINER_ID_REDIS" ]; then
    {
        docker run --network "$NETWORK" --name "$NETWORK-redis" -d redis || docker restart "$NETWORK-redis"
    } &> /dev/null
    CONTAINER_ID_REDIS="$( docker ps -qf name="$NETWORK-redis" )"
fi
if [ -z "$CONTAINER_ID_REDIS" ]; then
    echo 'Cannot start redis container'
    exit 1
fi
CONTAINER_HOSTNAME_REDIS="$( docker inspect --format '{{.Config.Hostname}}' "$CONTAINER_ID_REDIS" )"



CONTAINER_ID_TARGET="$( docker run \
    --network "$NETWORK" \
    -v "$DIR:/tests/:ro" \
    -e MYSQL="$CONTAINER_HOSTNAME_MYSQL" \
    -e REDIS="$CONTAINER_HOSTNAME_REDIS" \
    -d "$TAG"
)"



cd "$DIR"
for d in */ ; do
    if [ -f "$DIR/$d/test.php" ]; then
        echo "Testing $d..."
        docker exec "$CONTAINER_ID_TARGET" php "/tests/${d}test.php"
    fi
done



{
    docker stop "$CONTAINER_ID_MYSQL" "$CONTAINER_ID_REDIS" "$CONTAINER_ID_TARGET"
    docker network rm "$NETWORK" || true
} &> /dev/null
echo 'All done!'
