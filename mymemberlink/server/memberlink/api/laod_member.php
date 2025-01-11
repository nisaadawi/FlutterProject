<?php
include_once("db_config.php");

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * FROM tbl_membership";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $memberarray['memberships'] = array();
    
    while ($row = $result->fetch_assoc()) {
        $memberships = array();
        $memberships['membership_id'] = $row['membership_id'];
        $memberships['membership_name'] = $row['membership_name'];
        $memberships['description'] = $row['description'];
        $memberships['price'] = $row['price'];
        $memberships['benefits'] = $row['benefits'];
        $memberships['terms'] = $row['terms'];
        $memberships['duration'] = $row['duration'];
        $memberships['membership_filename'] = $row['membership_filename'];
        array_push($memberarray['memberships'], $memberships);
    }

    $response = array('status' => 'success', 'data' => $memberarray);
    sendJsonResponse($response);

} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
