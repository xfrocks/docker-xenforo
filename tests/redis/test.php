<?php

$host = getenv('REDIS');
if (empty($host)) {
	echo("`REDIS` env var is not set\n");
	die(1);
}

$redis = new Redis();
$redis->connect($host);