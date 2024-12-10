<?php
if(!isset($_POST)){
    $response = array('status'=> 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("db_config.php");
$title = addslashes($_POST['title']);
$description = addslashes($_POST['description']);
$location = addslashes($_POST['location']);
$eventype = addslashes($_POST['eventtype']);
$startdate = ($_POST['start']);
$enddate = ($_POST['end']);
$image = ($_POST['image']);
$decoded_image = base64_decode($image);

$filename = "event-".randomfilename(10).".jpg";
$path = "../assets/events/". $filename;

$sqlinsertbulletin = "INSERT INTO `tbl_events`(`event_title`, `event_description`, `event_startdate`, `event_enddate`, `event_type`, `event_location`, `event_filename`)
                      VALUES ('$title','$description','$startdate','$enddate','$eventype','$location','$filename')";

if (!is_dir("../assets/events/")) {
    error_log("Directory does not exist: ../assets/events/");
    die("Image directory does not exist");
}
if (!is_writable("../assets/events/")) {
    error_log("Directory not writable: ../assets/events/");
    die("Image directory is not writable");
}

// Validate and save the image
if (file_put_contents($path, $decoded_image) === false) {
    error_log("Failed to save image to " . $path);
    $response = array('status' => 'failed', 'data' => 'Failed to save image');
    sendJsonResponse($response);
    die;
}

if ($conn->query($sqlinsertbulletin) === TRUE) {
    
    file_put_contents($path, $decoded_image);
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}
function randomfilename($length) {
    $key = '';
    $keys = array_merge(range(0, 9), range('a', 'z'));
    for ($i = 0; $i < $length; $i++) {
        $key .= $keys[array_rand($keys)];
    }
    return $key;
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>