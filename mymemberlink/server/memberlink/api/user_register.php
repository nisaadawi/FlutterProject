<?php
if (!isset($_POST['name']) || !isset($_POST['email']) || !isset($_POST['phone']) || !isset($_POST['dob']) || !isset($_POST['address']) || !isset($_POST['password'])) {
    $response = array('status' => 'failed', 'data' => 'Missing required fields');
    sendJsonResponse($response);
    die;
}

include_once("db_config.php");

$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$dob = $_POST['dob'];
$address = addslashes($_POST['address']);
$password = sha1($_POST['password']);

$sqlinsert="INSERT INTO `tbl_admin`(`admin_name`, `admin_email`, `admin_phone`, `admin_dob`, `admin_address`, `admin_pass`) VALUES ('$name','$email','$phone','$dob','$address','$password')";

if ($conn->query($sqlinsert) == TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}	

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>