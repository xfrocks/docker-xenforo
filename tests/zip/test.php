<?php

$zip = new ZipArchive();
$opened = $zip->open(dirname($argv[0]) . '/a.zip');
assert($opened);

exit(0);