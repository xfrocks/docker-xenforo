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
    _xenforo="$( cat /opt/templates/xenforo.Caddyfile | sed -e "s/%_phpFastcgiEndpoint%/$_phpFastcgiEndpoint/" )"
    _caddyfile="$_caddyfile$_xenforo"
  fi

  echo "$_caddyfile" | tee "$_caddyfilePath" >&2
fi

echo "Executing $@..." >&2
exec "$@"
