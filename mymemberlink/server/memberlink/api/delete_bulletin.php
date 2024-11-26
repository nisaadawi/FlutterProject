<?php
if(!isset($_POST)){
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once('db_config.php');
$bulletinid = ($_POST['bulletinid']);

$sqldeletebulletin = "DELETE FROM `tbl_bulletin` WHERE `bulletin_id` = $bulletinid";

if ( $conn->query( $sqldeletebulletin ) === TRUE ) {
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