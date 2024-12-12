<?php
if(!isset($_POST)){
    $response = array('status'=> 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("db_config.php");
$name = addslashes($_POST['name']);
$price = addslashes($_POST['price']);
$quantity = addslashes($_POST['quantity']);
$description = addslashes($_POST['description']);
$image = ($_POST['image']);
$decoded_image = base64_decode($image);

$filename = "product-".randomfilename(10).".jpg";

$sqlinsertbulletin = "INSERT INTO `tbl_products`(`product_name`, `product_price`, `product_quantity`, `product_description`, `product_filename`)
                       VALUES ('$name','$price','$quantity','$description','$filename')";
                      


if ($conn->query($sqlinsertbulletin) === TRUE) {
    $path = "../assets/products/". $filename;
    file_put_contents($path, $decoded_image);
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}
function randomfilename($length) {
    $key = '';
    $keys = array_merge(range(0, 9), range('a', 'z'));
    for ($i = 0; $i < $length; $i++) {
        $key .= $keys[array_rand($keys)];
    }
    return $key;
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>