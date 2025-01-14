<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
include_once("db_config.php");

try {
    // Get specific payment to update if provided
    if (isset($_POST['date_purchased']) && isset($_POST['admin_email'])) {
        $date_purchased = $_POST['date_purchased'];
        $admin_email = $_POST['admin_email'];
        
        $sqlUpdate = "UPDATE tbl_payment 
                      SET payment_status = 'Failed' 
                      WHERE payment_status = 'Pending' 
                      AND date_purchased = ? 
                      AND admin_email = ?
                      AND TIMESTAMPDIFF(MINUTE, date_purchased, NOW()) >= 5";
        
        $stmt = $conn->prepare($sqlUpdate);
        $stmt->bind_param('ss', $date_purchased, $admin_email);
    } else {
        // Update all pending payments older than 5 minutes
        $fiveMinutesAgo = date('Y-m-d H:i:s', strtotime('-5 minutes'));
        
        $sqlUpdate = "UPDATE tbl_payment 
                      SET payment_status = 'Failed' 
                      WHERE payment_status = 'Pending' 
                      AND date_purchased < ?";
        
        $stmt = $conn->prepare($sqlUpdate);
        $stmt->bind_param('s', $fiveMinutesAgo);
    }
    
    $stmt->execute();
    $response = array('status' => 'success', 'updated_count' => $stmt->affected_rows);
    
} catch (Exception $e) {
    error_log("Error in update_pending_payments.php: " . $e->getMessage());
    $response = array('status' => 'failed', 'error' => $e->getMessage());
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