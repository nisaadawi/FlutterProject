<?php
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null, 'error' => 'Invalid request method');
    sendJsonResponse($response);
    die;
}

include_once("db_config.php");

try {
    $email = $_POST['email'];
    $password = sha1($_POST['password']);  // Note: SHA1 is not recommended for password hashing

    $sqllogin = "SELECT * FROM `tbl_admin` WHERE `admin_email` = ? AND `admin_pass` = ?";
    $stmt = $conn->prepare($sqllogin);
    $stmt->bind_param("ss", $email, $password);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $adminarray['admin'] = array();

        while($row = $result->fetch_assoc()) {
            $admin = array();
            $admin['admin_id'] = $row['admin_id'];
            $admin['admin_name'] = $row['admin_name'];
            $admin['admin_email'] = $row['admin_email'];
            $admin['admin_phone'] = $row['admin_phone'];
            $admin['admin_dob'] = $row['admin_dob'];
            $admin['admin_address'] = $row['admin_address'];
            $admin['admin_pass'] = $row['admin_pass'];
            $admin['member_type'] = $row['member_type'];
            $admin['admin_datereg'] = $row['admin_datereg'];
            array_push($adminarray['admin'], $admin);
        }

        $response = array('status' => 'success', 'data' => $adminarray);
    } else {
        $response = array('status' => 'failed', 'data' => null, 'error' => 'Invalid credentials');
    }
} catch (Exception $e) {
    $response = array('status' => 'failed', 'data' => null, 'error' => 'Server error');
    // Log the actual error: error_log($e->getMessage());
} finally {
    if (isset($stmt)) {
        $stmt->close();
    }
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>