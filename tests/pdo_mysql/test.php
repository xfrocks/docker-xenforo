<?php

$host = getenv('MYSQL');
if (empty($host)) {
	echo("`MYSQL` env var is not set\n");
	die(1);
}

$dbh = new PDO("mysql:host=$host;dbname=db", 'user', 'password');
