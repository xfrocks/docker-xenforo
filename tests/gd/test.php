<?php

$img = imagecreatetruecolor(100, 100);
$white = imagecolorallocate($img, 255, 255, 255);
imagestring($img, 1, 0, 0,  'Text', $white);

imagejpeg($img, '/tmp/a.jpg');
imagepng($img, '/tmp/a.png');
imagewebp($img, '/tmp/a.webp');
imagettfbbox(10, 0, '/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf', 'TTF');