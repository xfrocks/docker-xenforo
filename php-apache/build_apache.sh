#!/bin/bash

set -e

pear install PHP_CodeSniffer

curl -Lo /tmp/PHPCompatibility.tar.gz "https://github.com/wimg/PHPCompatibility/archive/${PHP_COMPATIBILITY_VERSION}.tar.gz"
tar -xzf /tmp/PHPCompatibility.tar.gz -C /usr/local/share/
phpcs --config-set installed_paths "/usr/local/share/PHPCompatibility-${PHP_COMPATIBILITY_VERSION}"
