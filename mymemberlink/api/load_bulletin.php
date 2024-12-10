<?php
    include_once("db_config.php");

    $results_per_page = 10;
    if (isset($_GET['pageno'])){
        $pageno = (int)$_GET['pageno'];
    }else{
        $pageno = 1;
    }

    $page_first_result = ($pageno - 1) * $results_per_page;

    $sqlloadbulletin = "SELECT * FROM `tbl_bulletin` ORDER BY `bulletin_date` DESC";
    $result = $conn->query($sqlloadbulletin);
    $number_of_result = $result->num_rows;

    $number_of_page = ceil($number_of_result / $results_per_page);
    $sqlloadbulletin = $sqlloadbulletin." LIMIT $page_first_result, $results_per_page";
    
    $result = $conn->query($sqlloadbulletin);
    
    if ($result->num_rows > 0) {

        $bulletinarray['bulletin'] = array();

        while($row = $result-> fetch_assoc()){
            $bulletin = array();
            $bulletin['bulletin_id'] =$row['bulletin_id'];
            $bulletin['bulletin_title'] =$row['bulletin_title'];
            $bulletin['bulletin_details'] =$row['bulletin_details'];
            $bulletin['bulletin_date'] =$row['bulletin_date'];
            $bulletin['isEdited'] = $row['isEdited'];
            array_push($bulletinarray['bulletin'],$bulletin);
        }
        
        $response = array('status' => 'success', 'data' => $bulletinarray,'numofpage'=>$number_of_page,'numberofresult'=>$number_of_result);
        sendJsonResponse($response);
    }else{
        $response = array('status' => 'failed', 'data' => null, 'numofpage'=>$number_of_page,'numberofresult'=>$number_of_result);
        sendJsonResponse($response);
    }
function sendJsonResponse($sentArray)
    {
        header('Content-Type: application/json');
        echo json_encode($sentArray);
    }
?>