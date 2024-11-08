<?php

    include_once("db_config.php");

    $sqlloadbulletin = "SELECT * FROM `tbl_bulletin` ORDER BY `bulletin_date` DESC";
    $result = $conn->query($sqlloadbulletin);

    if ($result->num_rows > 0) {

        $bulletinarray['bulletin'] = array();

        while($row = $result-> fetch_assoc()){
            $bulletin = array();
            $bulletin['bulletin_id'] =$row['bulletin_id'];
            $bulletin['bulletin_title'] =$row['bulletin_title'];
            $bulletin['bulletin_details'] =$row['bulletin_details'];
            $bulletin['bulletin_date'] =$row['bulletin_date'];
            array_push($bulletinarray['bulletin'],$bulletin);
        }
        
        $response = array('status' => 'success', 'data' => $bulletinarray);
        sendJsonResponse($response);
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
        
	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>