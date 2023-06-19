# docker pull xfrocks/xenforo
Docker containers to develop and run XenForo.

[![CircleCI](https://circleci.com/gh/xfrocks/docker-xenforo.svg?style=svg)](https://circleci.com/gh/xfrocks/docker-xenforo)
[![Docker](https://img.shields.io/docker/pulls/xfrocks/xenforo.svg)](https://hub.docker.com/r/xfrocks/xenforo)

Installed extensions (other than the default ones):
 * apcu
 * exif
 * gd
 * gmp
 * imagick
 * memcached
 * mysqli
 * opcache
 * pcntl
 * redis
 * soap
 * sockets
 * xdebug (installed but disabled on php-fpm)
 * zip

List of all extensions on php-fpm (according to `php -m`):
apcu
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
gmp
hash
iconv
igbinary
json
libxml
mbstring
memcached
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_sqlite
Phar
posix
readline
redis
Reflection
session
SimpleXML
soap
sockets
sodium
SPL
sqlite3
standard
tokenizer
xml
xmlreader
xmlwriter
Zend OPcache
zip
zlib
Zend OPcache

## Development

Sample `docker-compose.yml` using Apache:

```yaml
version: "2"

services:
  php:
    image: xfrocks/xenforo:php-apache
    ports:
      - "8080:80"
    links:
      - mysql
    volumes:
      - .:/var/www/html/

  mysql:
    image: mysql
    environment:
      MYSQL_RANDOM_ROOT_PASSWORD: "yes"
      MYSQL_DATABASE: database
      MYSQL_USER: user
      MYSQL_PASSWORD: password
    ports:
      - "3306:3306"
    volumes:
      - ./internal_data/mysql:/var/lib/mysql
```

### Friendly URLs

The apache image doesn't have mod_rewrite enabled, use FallbackResource in `.htaccess` if you need XenForo's friendly URLs:

```
FallbackResource /index.php
```

### Locale

The apache image has `locales-all` installed for easy development but it's not included in the fpm image.
Click [here](https://github.com/gliderlabs/docker-alpine/issues/144) for installation instructions.

## Production
It's recommended to use the fpm image with nginx for better performance in production.
