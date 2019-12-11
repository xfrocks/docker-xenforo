<?php

$info = gd_info();

assert($info['BMP Support']);
assert($info['FreeType Support']);
assert($info['GIF Read Support']);
assert($info['JPEG Support']);
assert($info['PNG Support']);
assert($info['WebP Support']);
assert($info['XPM Support']);
