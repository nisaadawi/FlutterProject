<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
include_once("db_config.php");

$sqlloadmembership = "SELECT * FROM tbl_membership ORDER BY price ASC";
$result = $conn->query($sqlloadmembership);

if ($result->num_rows > 0) {
    $memberships = array();
    while ($row = $result->fetch_assoc()) {
        $memberships[] = array(
            'membership_id' => $row['membership_id'],
            'membership_name' => $row['membership_name'],
            'price' => $row['price'],
            'description' => $row['description'],
            'benefits' => $row['benefits'],
            'terms' => $row['terms'],
            'duration' => $row['duration']
        );
    }
    $response = array('status' => 'success', 'data' => $memberships);
} else {
    $response = array('status' => 'failed', 'data' => null);
}

sendJsonResponse($response);

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?> 