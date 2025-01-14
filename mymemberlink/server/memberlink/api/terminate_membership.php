<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
include_once("db_config.php");

if (!isset($_POST['admin_email'])) {
    $response = array('status' => 'failed', 'message' => 'Email not provided');
    sendJsonResponse($response);
    die();
}

$admin_email = $_POST['admin_email'];

try {
    $sqlupdate = "UPDATE tbl_admin SET member_type = 'FREE EXPLORER' WHERE admin_email = ?";
    $stmt = $conn->prepare($sqlupdate);
    $stmt->bind_param('s', $admin_email);
    
    if ($stmt->execute()) {
        $response = array('status' => 'success', 'message' => 'Membership terminated successfully');
    } else {
        throw new Exception("Failed to update membership");
    }
    
} catch (Exception $e) {
    $response = array('status' => 'failed', 'message' => $e->getMessage());
} finally {
    if (isset($stmt)) {
        $stmt->close();
    }
    if (isset($conn)) {
        $conn->close();
    }
}

sendJsonResponse($response);

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?> 