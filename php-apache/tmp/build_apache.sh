#!/bin/bash

set -e

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
