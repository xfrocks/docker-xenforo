#!/bin/sh

set -e

_caddyfilePathDefault='/etc/Caddyfile'
_caddyfilePath=${CADDYFILE_PATH:-"$_caddyfilePathDefault"}
_phpFastcgiEndpoint="$CADDY_PHP_FASTCGI_ENDPOINT"

# if command starts with an option, prepend caddy
if [ "${1:0:1}" = '-' ]; then
  set -- /usr/bin/caddy -conf "$_caddyfilePath" "$@"
fi

if [ "x$_caddyfilePath" = "x$_caddyfilePathDefault" ]; then
  _caddyfile="$( cat /opt/templates/Caddyfile )"

  if [ ! -z "$_phpFastcgiEndpoint" ]; then
    _caddyfile="$( echo "$_caddyfile" | sed -e "s/php-fpm.local:9000/$_phpFastcgiEndpoint/" )"
  fi

  echo "$_caddyfile" | tee "$_caddyfilePath" >&2
fi

echo "Executing $@..." >&2
exec "$@"
