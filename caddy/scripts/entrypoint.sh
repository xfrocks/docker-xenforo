#!/bin/sh

CADDYFILE_TEMPLATE_PATH='/opt/templates/Caddyfile'
CADDYFILE_PATH='/etc/Caddyfile'

set -e

# if command starts with an option, prepend caddy
if [ "${1:0:1}" = '-' ]; then
    set -- /usr/bin/caddy -conf "$CADDYFILE_PATH" "$@"
fi

CADDYFILE="$( cat "$CADDYFILE_TEMPLATE_PATH" )"

if [ ! -z "$CADDY_PHP_FASTCGI_ENDPOINT" ]; then
    CADDYFILE="$( echo "$CADDYFILE" | sed -e "s/php-fpm.local:9000/$CADDY_PHP_FASTCGI_ENDPOINT/" )"
    echo "$CADDYFILE" | grep 'fastcgi' | xargs
fi

echo "$CADDYFILE" > "$CADDYFILE_PATH"

echo "Executing $@..."
exec "$@"
