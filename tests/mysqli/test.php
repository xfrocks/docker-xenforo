<?php

$host = getenv('MYSQL');
if (empty($host)) {
	echo("`MYSQL` env var is not set\n");
	die(1);
}

$mysqli = new mysqli($host, 'user', 'password', 'db');