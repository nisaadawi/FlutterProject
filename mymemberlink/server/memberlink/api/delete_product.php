<?php
if ( !isset( $_POST ) ) {
    $response = array( 'status' => 'failed', 'data' => null );
    sendJsonResponse( $response );
    die;
}
include_once( 'db_config.php' );
$productid = ( $_POST[ 'productid' ] );
$sqldeleteproduct = "DELETE FROM `tbl_products` WHERE `product_id` = '$productid'";
if ( $conn->query( $sqldeleteproduct ) === TRUE ) {
    $response = array( 'status' => 'success', 'data' => null );
    sendJsonResponse( $response );
} else {
    $response = array( 'status' => 'failed', 'data' => null );
    sendJsonResponse( $response );
}
function sendJsonResponse( $sentArray )
 {
    header( 'Content-Type: application/json' );
    echo json_encode( $sentArray );
}
?>