# docker pull xfrocks/xenforo
Docker containers to develop and run XenForo.

Installed extensions (other than the default ones):
 * exif
 * gd
 * imagick
 * mcrypt
 * memcached
 * mysqli
 * opcache
 * pcntl
 * redis
 * zip

List of all extensions (according to `php -m`):
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
hash
iconv
imagick
json
libxml
mbstring
mcrypt
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
Sample `docker-compose.yml`:

```
version: '2'

services:
  php:
    image: xfrocks/xenforo:php-apache
    environment:
      - VIRTUAL_HOST=dev.local.xfrocks.com
    expose:
      - "80"
    links:
      - mysql
    volumes:
      - .:/var/www/html/

  mysql:
    image: mysql
    environment:
      MYSQL_RANDOM_ROOT_PASSWORD: 'yes'
      MYSQL_DATABASE: 'database'
      MYSQL_USER: 'user'
      MYSQL_PASSWORD: 'password'
    expose:
      - "3306"
    volumes:
      - ./internal_data/mysql:/var/lib/mysql

  nginx-proxy:
    image: jwilder/nginx-proxy
    ports:
      - "80:80"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
```

## Production
It's recommended to use the fpm container with nginx for better performance in production.
