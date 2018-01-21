<?php

$imageTag = getenv('IMAGE_TAG_FOR_TESTING');
if (empty($imageTag)) {
  echo("`IMAGE_TAG_FOR_TESTING` env var is not set\n");
  die(1);
}

if (strpos($imageTag, 'php-fpm') === false) {
  exit(0);
}

assert(function_exists('tideways_enable'));

$tidewaysPhpPath = ini_get('extension_dir') . '/Tideways.php';
require($tidewaysPhpPath);
assert(class_exists('\Tideways\Profiler'));
