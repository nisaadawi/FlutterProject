<?php
if(!isset($_POST)){
    $response = array('status'=> 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("db_config.php");
$title = addslashes($_POST['title']);
$details = addslashes($_POST['details']);

$sqlinsertbulletin = "INSERT INTO `tbl_bulletin`(`bulletin_title`, `bulletin_details`) VALUES ('$title',' $details')";

if ($conn->query($sqlinsertbulletin) === TRUE) {
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