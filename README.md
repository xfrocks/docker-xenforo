# docker pull xfrocks/xenforo
Docker containers to develop and run XenForo.

Installed extensions (other than the default ones):
 * exif
 * gd
 * mcrypt
 * memcached
 * mysqli
 * opcache
 * pcntl
 * redis
 * tideways (`auto_start=0` `auto_prepend_library=0`)
 * xdebug (not enabled)
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
tideways
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

### Debugging
The main images have `xdebug` installed but not enabled, use the `*-debug` images for that. Sample `docker-compose.yml`:

```
version: '2'

services:
  php:
    image: xfrocks/xenforo:php-apache-7.1.3-debug
    environment:
      - XDEBUG_CONFIG=remote_host=10.254.254.254 remote_connect_back=off
...
```

By default, the debug images have `xdebug.remote_enable=on` and `xdebug.remote_connect_back=on` (see [build script](https://github.com/xfrocks/docker-xenforo/blob/72443df7ea8d9d4139f245b3e82f7827aca65f4d/build-and-push#L41)) which should work for everyone. If you are using Docker for Mac, however, it's required to turn off `remote_connect_back` and specify a loopback alias for `remote_host` (more information [here](https://forums.docker.com/t/ip-address-for-xdebug/10460)).

## Production
It's recommended to use the fpm container with nginx for better performance in production.
