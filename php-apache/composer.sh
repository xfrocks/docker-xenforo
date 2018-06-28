#!/bin/sh

set -e

# https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md
_signatureExpected="$( curl -fS https://composer.github.io/installer.sig )"
_tmpPath='/tmp/composer.php'
curl -fLS -o "$_tmpPath" https://getcomposer.org/installer
_signatureActual="$( sha384sum "$_tmpPath" | awk '{ print $1 }' )"

if [ "$_signatureActual" != "$_signatureExpected" ]; then
  echo "Bad signature $_tmpPath ($_signatureActual), expected $_signatureExpected" >&2
  exit 1
fi

php "$_tmpPath"
mv composer.phar /usr/local/bin/composer
