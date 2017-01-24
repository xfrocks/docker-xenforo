<?php

$key = md5($key, true);
$data = '1234567890123456';
mcrypt_encrypt(MCRYPT_RIJNDAEL_128, $key, $data, MCRYPT_MODE_ECB);