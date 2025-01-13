<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
include_once("db_config.php");

if (!isset($_GET['admin_email'])) {
    $response = array('status' => 'failed', 'data' => null, 'error' => 'Email not provided');
    sendJsonResponse($response);
    die();
}

$admin_email = $_GET['admin_email'];

$sqlloadpayment = "SELECT * FROM `tbl_payment` WHERE admin_email = ? ORDER BY date_purchased DESC";
$stmt = $conn->prepare($sqlloadpayment);
$stmt->bind_param('s', $admin_email);

if ($stmt->execute()) {
    $result = $stmt->get_result();
    $payments = array();
    
    while ($row = $result->fetch_assoc()) {
        $payments[] = array(
            'payment_id' => $row['payment_id'],
            'billplz_id' => $row['billplz_id'],
            'admin_email' => $row['admin_email'],
            'admin_phone' => $row['admin_phone'],
            'admin_name' => $row['admin_name'],
            'price' => $row['price'],
            'membership_name' => $row['membership_name'],
            'payment_status' => $row['payment_status'],
            'date_purchased' => $row['date_purchased']
        );
    }
    
    $response = array('status' => 'success', 'data' => $payments);
} else {
    $response = array('status' => 'failed', 'data' => null, 'error' => 'Database error');
}

sendJsonResponse($response);

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?> 