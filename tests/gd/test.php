<?php

$img = imagecreatetruecolor(100, 100);
$white = imagecolorallocate($img, 255, 255, 255);
imagestring($img, 1, 0, 0,  'Text', $white);

imagegif  ($img, '/dev/null');
imagejpeg ($img, '/dev/null');
imagepng  ($img, '/dev/null');
imagewbmp ($img, '/dev/null');
imagexbm  ($img, '/dev/null');
