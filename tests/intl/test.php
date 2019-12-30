<?php

$formatter = new NumberFormatter('en_US', NumberFormatter::DECIMAL);
$formatted = $formatter->format(1234567);
assert($formatted === '1,234,567');
