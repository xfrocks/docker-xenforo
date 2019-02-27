<?php

// https://github.com/xfrocks/docker-xenforo/pull/6
setlocale(LC_CTYPE, 'en_US.UTF8');
$actual = iconv('utf-8', 'us-ascii//TRANSLIT', 'địch');

if (getenv('APACHE_ENVVARS')) {
  $expected = 'dich';
} else {
  $expected = false;
}

var_dump($actual, $expected);

die($actual === $expected ? 0 : 1);
