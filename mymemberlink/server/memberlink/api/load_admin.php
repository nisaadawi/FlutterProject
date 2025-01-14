<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
include_once("db_config.php");

if (!isset($_GET['admin_email'])) {
    $response = array('status' => 'failed', 'message' => 'Email not provided');
    sendJsonResponse($response);
    die();
}

$admin_email = $_GET['admin_email'];

try {
    $sqlloadadmin = "SELECT * FROM tbl_admin WHERE admin_email = ?";
    $stmt = $conn->prepare($sqlloadadmin);
    $stmt->bind_param('s', $admin_email);
    
    if ($stmt->execute()) {
        $result = $stmt->get_result();
        if ($row = $result->fetch_assoc()) {
            $response = array(
                'status' => 'success',
                'data' => array(
                    'admin_id' => $row['admin_id'],
                    'admin_email' => $row['admin_email'],
                    'admin_name' => $row['admin_name'],
                    'admin_phone' => $row['admin_phone'],
                    'member_type' => $row['member_type']
                )
            );
        } else {
            $response = array('status' => 'failed', 'message' => 'Admin not found');
        }
    } else {
        throw new Exception("Failed to load admin data");
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