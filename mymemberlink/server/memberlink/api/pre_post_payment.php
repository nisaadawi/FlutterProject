<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
include_once("db_config.php");

// Get admin details from URL parameters
$admin_email = $_GET['admin_email'];
$admin_phone = $_GET['admin_phone'];
$admin_name = $_GET['admin_name'];
$price = $_GET['price'];
$member_type = $_GET['member_type'];

// Get Billplz payment details
$billplz_data = array(
    'id' => $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'],
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

// Verify X-Signature
$signing = '';
foreach ($billplz_data as $key => $value) {
    $signing .= 'billplz' . $key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
$x_signature = hash_hmac('sha256', $signing, '5e918c1697e5e5986b43d47a513b7dbc3268cc120cca16b71595368c572df84ba4d8cf99266783a14c222c4632bb04409f26523a16a46f8c2453489ef9fbcb0f');

if ($x_signature === $billplz_data['x_signature']) {
    $payment_status = $billplz_data['paid'];
    if ($payment_status == "true") {
        $payment_status = "Success";
    } else if ($payment_status == "false") {
        $payment_status = "Failed";
    } else {
        $payment_status = "Pending";
    }

    $billplz_id = $billplz_data['id'];
    $date_purchased = date('Y-m-d H:i:s');

    try {
        // First check if this billplz_id already exists
        $sqlcheck = "SELECT payment_id, payment_status FROM tbl_payment WHERE billplz_id = ?";
        $checkStmt = $conn->prepare($sqlcheck);
        $checkStmt->bind_param('s', $billplz_id);
        $checkStmt->execute();
        $result = $checkStmt->get_result();

        if ($result->num_rows > 0) {
            // Payment record exists, update if status changed to Success
            $row = $result->fetch_assoc();
            if ($payment_status == "Success" && $row['payment_status'] != "Success") {
                // Start transaction
                $conn->begin_transaction();
                
                try {
                    // 1. Update payment status
                    $sqlupdate = "UPDATE tbl_payment 
                                 SET payment_status = ?, date_purchased = ? 
                                 WHERE billplz_id = ?";
                    $updateStmt = $conn->prepare($sqlupdate);
                    $updateStmt->bind_param('sss', 
                        $payment_status,
                        $date_purchased,
                        $billplz_id
                    );
                    $updateStmt->execute();
                    
                    // 2. Update admin's member_type
                    $sqlupdateAdmin = "UPDATE tbl_admin 
                                     SET member_type = ? 
                                     WHERE admin_email = ?";
                    $updateAdminStmt = $conn->prepare($sqlupdateAdmin);
                    $updateAdminStmt->bind_param('ss', 
                        $member_type,
                        $admin_email
                    );
                    $updateAdminStmt->execute();
                    
                    // If both queries successful, commit transaction
                    $conn->commit();
                    error_log("Payment and admin member_type updated successfully for billplz_id: $billplz_id");
                    
                } catch (Exception $e) {
                    // If any query fails, rollback changes
                    $conn->rollback();
                    throw $e;
                }
            }
        } else {
            // Start transaction for new payment
            $conn->begin_transaction();
            
            try {
                // 1. Insert new payment record
                $sqlinsert = "INSERT INTO tbl_payment 
                              (billplz_id, admin_email, admin_phone, admin_name, 
                               price, membership_name, payment_status, date_purchased) 
                              VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                $insertStmt = $conn->prepare($sqlinsert);
                $insertStmt->bind_param('ssssdsss', 
                    $billplz_id,
                    $admin_email,
                    $admin_phone,
                    $admin_name,
                    $price,
                    $member_type,
                    $payment_status,
                    $date_purchased
                );
                $insertStmt->execute();
                
                // 2. If payment is successful, update admin's member_type
                if ($payment_status == "Success") {
                    $sqlupdateAdmin = "UPDATE tbl_admin 
                                     SET member_type = ? 
                                     WHERE admin_email = ?";
                    $updateAdminStmt = $conn->prepare($sqlupdateAdmin);
                    $updateAdminStmt->bind_param('ss', 
                        $member_type,
                        $admin_email
                    );
                    $updateAdminStmt->execute();
                }
                
                // If both queries successful, commit transaction
                $conn->commit();
                error_log("New payment record inserted and admin updated for billplz_id: $billplz_id");
                
            } catch (Exception $e) {
                // If any query fails, rollback changes
                $conn->rollback();
                throw $e;
            }
        }

    } catch (Exception $e) {
        error_log("Error processing payment: " . $e->getMessage());
    }

    // Generate receipt
         echo "
        <!DOCTYPE html>
        <html lang=\"en\">
        <head>
            <meta charset=\"UTF-8\">
            <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
            <title>Payment Receipt</title>
            <!-- Bootstrap CSS -->
            <link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css\" rel=\"stylesheet\">
            <!-- Font Awesome -->
            <link href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css\" rel=\"stylesheet\">
            <style>
                body {
                    background-color: #f0f2f5;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                }
                .receipt-container {
                    max-width: 700px;
                    margin: 30px auto;
                    background: #ffffff;
                    border-radius: 15px;
                    padding: 30px;
                    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
                }
                .receipt-header {
                    text-align: center;
                    padding-bottom: 20px;
                    border-bottom: 2px solid #e9ecef;
                    margin-bottom: 30px;
                }
                .receipt-header h1 {
                    color: #7b2cbf;
                    font-size: 2rem;
                    font-weight: 600;
                    margin-bottom: 10px;
                }
                .receipt-header i {
                    font-size: 3rem;
                    color: #9d4edd;
                    margin-bottom: 15px;
                }
                .table {
                    margin-bottom: 30px;
                }
                .table th {
                    background-color: #f8f9fa;
                    color: #7b2cbf;
                    font-weight: 600;
                }
                .table td {
                    vertical-align: middle;
                    color: #444;
                }
                .status-success {
                    color: #198754;
                    font-weight: 600;
                    background-color: #d1e7dd;
                    padding: 5px 10px;
                    border-radius: 5px;
                }
                .status-failed {
                    color: #dc3545;
                    font-weight: 600;
                    background-color: #f8d7da;
                    padding: 5px 10px;
                    border-radius: 5px;
                }
                .receipt-footer {
                    text-align: center;
                    margin-top: 30px;
                    padding-top: 20px;
                    border-top: 2px solid #e9ecef;
                    color: #666;
                }
                .price-value {
                    font-size: 1.2rem;
                    font-weight: 600;
                    color: #7b2cbf;
                }
                @media print {
                    body {
                        background-color: #fff;
                    }
                    .receipt-container {
                        box-shadow: none;
                        margin: 0;
                        padding: 15px;
                    }
                    .no-print {
                        display: none;
                    }
                }
            </style>
        </head>
        <body>
            <div class=\"receipt-container\">
                <div class=\"receipt-header\">
                    " . ($payment_status == 'Success' ? 
                        "<i class=\"fas fa-check-circle mb-3\"></i>
                         <h1>Payment Receipt</h1>
                         <p class=\"text-muted\">Thank you for your payment</p>"
                        : 
                        "<i class=\"fas fa-times-circle mb-3\" style=\"color: #dc3545;\"></i>
                         <h1 style=\"color: #dc3545;\">Payment Failed</h1>
                         <p class=\"text-muted\">Please try again</p>"
                    ) . "
                </div>
                
                <table class=\"table table-hover\">
                    <tbody>
                        <tr>
                            <th scope=\"row\">Receipt ID</th>
                            <td>{$billplz_id}</td>
                        </tr>
                        <tr>
                            <th scope=\"row\">Name</th>
                            <td>{$admin_name}</td>
                        </tr>
                        <tr>
                            <th scope=\"row\">Email</th>
                            <td>{$admin_email}</td>
                        </tr>
                        <tr>
                            <th scope=\"row\">Phone</th>
                            <td>{$admin_phone}</td>
                        </tr>
                        <tr>
                            <th scope=\"row\">Membership Type</th>
                            <td><span class=\"badge bg-primary\">{$member_type}</span></td>
                        </tr>
                        <tr>
                            <th scope=\"row\">Amount</th>
                            <td class=\"price-value\">RM {$price}</td>
                        </tr>
                        <tr>
                            <th scope=\"row\">Payment Status</th>
                            <td><span class=\"" . ($payment_status == 'Success' ? 'status-success' : 'status-failed') . "\">
                                {$payment_status}
                            </span></td>
                        </tr>
                        <tr>
                            <th scope=\"row\">Date</th>
                            <td>{$date_purchased}</td>
                        </tr>
                    </tbody>
                </table>
        
                <div class=\"receipt-footer\">
                    " . ($payment_status == 'Success' ? 
                        "<p class=\"mt-3 mb-0\">
                            <small>This is a computer-generated receipt. No signature is required.</small>
                        </p>"
                        :
                        "<div class=\"alert alert-danger\" role=\"alert\">
                            <i class=\"fas fa-exclamation-triangle me-2\"></i>
                            Your payment was unsuccessful. Please try again or contact support if the problem persists.
                        </div>
                        <a href=\"javascript:history.back()\" class=\"btn btn-primary\">
                            <i class=\"fas fa-redo me-2\"></i>Try Again
                        </a>"
                    ) . "
                </div>
            </div>
        
            <!-- Bootstrap Bundle with Popper -->
            <script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js\"></script>
        </body>
        </html>
            ";

} else {
    error_log("X-Signature verification failed");
    die("Invalid payment verification");
}
?>