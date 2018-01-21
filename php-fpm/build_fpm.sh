#!/bin/bash

set -e

# tideways
curl -Lo /tmp/tideways.tar.gz "https://s3-eu-west-1.amazonaws.com/tideways/extension/${TIDEWAYS_VERSION}/tideways-php-${TIDEWAYS_VERSION}-x86_64.tar.gz"
tar -xzf /tmp/tideways.tar.gz -C /tmp/
_installPath="/tmp/tideways-php-${TIDEWAYS_VERSION}/install.sh"
chmod +x "${_installPath}" && "${_installPath}"
docker-php-ext-enable tideways
{ \
  echo 'tideways.auto_start=0'; \
  echo 'tideways.auto_prepend_library=0'; \
} > /usr/local/etc/php/conf.d/zzz-tideways.ini
