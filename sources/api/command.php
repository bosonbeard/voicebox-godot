<?php

// Heaers
header("Access-Control-Allow-Orgin: *");
header("Access-Control-Allow-Methods: *");
header("Content-Type: application/json");

// Get parameters
$method = $_SERVER['REQUEST_METHOD'];
$phone = $_REQUEST["phone"];
$command = $_REQUEST["command"];

$dt = date('c', time()); // get currtent time and date

// write request in log
$fw = fopen("log.txt", "a+");
fwrite($fw, $phone." ".$command." ".$dt."\r\n");
fclose($fw);

//connect to DB
$db = new SQLite3('control.db');


switch ($method) {
 // GET method   
    case "GET":

        // get last key command
        $sql = "SELECT `key`   FROM commands WHERE `phone` = '$phone' AND `is_readed`=0  ORDER BY `timestamp` DESC";
        $result_key = $db->querySingle($sql);
        // set other not not processed to processed
        // (in this simple case we use only last not processed command, but you can improve it)
        $sql = "UPDATE commands SET `is_readed`=1  WHERE `phone` = '$phone' AND `is_readed`=0   ";
        $result = $db->querySingle($sql, true);
        
        // set API response
        $response = array('key' => $result_key, 'phone'=> $phone  );

        break;
 // POST method   
    case "POST":
        // add new not processed command in DB
        $sql = "INSERT INTO commands (`key`,`phone`, `timestamp`, `is_readed`) VALUES('$command','$phone','$dt',0)";
        $result = $db->querySingle($sql);
        // set API response
        $response = array('key' => $command, 'phone'=> $phone );
        break;
    default:
        echo '{"error":"unknown method"}';
        break;
}

//return response
echo json_encode($response);
