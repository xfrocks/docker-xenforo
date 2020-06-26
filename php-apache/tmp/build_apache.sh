#!/bin/bash

set -e

# ffmpeg
apt-get install -y ffmpeg

# phpcs
pear install PHP_CodeSniffer
curl -Lo /tmp/PHPCompatibility.tar.gz "https://github.com/wimg/PHPCompatibility/archive/${PHP_COMPATIBILITY_VERSION}.tar.gz"
tar -xzf /tmp/PHPCompatibility.tar.gz -C /usr/local/share/
phpcs --config-set installed_paths "/usr/local/share/PHPCompatibility-${PHP_COMPATIBILITY_VERSION}"

# remote ip (`X-Forwarded-For` header etc.)
a2enmod remoteip

# tls
openssl req \
  -days 365 \
  -keyout /etc/ssl/private/ssl-cert-snakeoil.key \
  -newkey rsa:4096 \
  -nodes \
  -out /etc/ssl/certs/ssl-cert-snakeoil.pem \
  -subj "/C=VN/ST=Hanoi/O=xfrocks/CN=php-apache" \
  -x509
a2enmod ssl
a2ensite default-ssl
