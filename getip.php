<?php
$ip = $_SERVER['REMOTE_ADDR'];
file_put_contents('ip.txt', "IP: $ip\n");
header('Content-Type: image/png');
echo base64_decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=');
?>
