<?php

$date = date('dMYHis');
$locationData = isset($_POST['location']) ? $_POST['location'] : '';

if (!empty($locationData)) {
    error_log("Received Location Data: \n" . $locationData . "\n\n", 3, "location_log.txt");
    $file = fopen('location_'.$date.'.txt', 'w');
    fwrite($file, $locationData);
    fclose($file);
}

exit();
?>