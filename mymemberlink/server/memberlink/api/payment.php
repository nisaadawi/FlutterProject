<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$email = $_GET['admin_email'] ?? '';
$phone = $_GET['admin_phone'] ?? '';
$name = $_GET['admin_name'] ?? '';
$price = $_GET['price'] ?? '0';
$member_type = $_GET['member_type'] ?? '';

// Validate inputs
if (empty($email) || empty($phone) || empty($name) || empty($price)) {
    die("Missing required parameters");
}

$api_key = '0b90e567-e964-4580-8d40-12ac1684e9a7';
$collection_id = 'mlh3xgo4';
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

// Convert price to cents
$amount_in_cents = (int)($price * 100);

$data = array(
    'collection_id' => $collection_id,
    'email' => $email,
    'mobile' => $phone,
    'name' => $name,
    'amount' => $amount_in_cents,
    'description' => 'Payment for order by ' . $name,
    'callback_url' => "https://humancc.site/ndhos/memberlink/api/return_url",
    'redirect_url' => "https://humancc.site/ndhos/memberlink/api/pre_post_payment.php?admin_email=$email&admin_phone=$phone&price=$price&admin_name=$name&member_type=$member_type"
);

// Debug logging
error_log("Payment Request Data: " . print_r($data, true));

$process = curl_init($host);
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data));

$return = curl_exec($process);
$curl_error = curl_error($process);
curl_close($process);

if ($curl_error) {
    error_log("Curl Error: " . $curl_error);
    die("Error processing payment");
}

$bill = json_decode($return, true);

// Debug logging
error_log("Billplz Response: " . print_r($bill, true));

if (isset($bill['url'])) {
    header("Location: {$bill['url']}");
    exit();
} else {
    error_log("Error: No URL in Billplz response");
    die("Error creating payment bill");
}
?>