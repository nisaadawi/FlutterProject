<?php
date_default_timezone_set('Asia/Kuala_Lumpur'); 

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("db_config.php");

$bulletinid = $_POST['bulletinid'];
$title = addslashes($_POST['title']);
$details = addslashes($_POST['details']);
$date = date('Y-m-d H:i:s');
$isEdited = $_POST['isEdited'];

// Update SQL to include the isEdited flag automatically
$sqlupdatebulletin = "UPDATE `tbl_bulletin` 
                      SET `bulletin_title`='$title', 
                          `bulletin_details`='$details', 
                          `bulletin_date`='$date', 
                          `isEdited`='$isEdited' 
                      WHERE `bulletin_id` = '$bulletinid'";

if ($conn->query($sqlupdatebulletin) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
