<?php

header("Access-Control-Allow-Orgin: *");
header("Access-Control-Allow-Methods: *");
header("Content-Type: application/json");

$method = $_SERVER['REQUEST_METHOD'];


$phone = $_REQUEST["phone"];
$command = $_REQUEST["command"];
$dt = date('c', time());
$fw = fopen("log.txt", "a+");
fwrite($fw, $phone." ".$command." ".$dt."\r\n");
fclose($fw);


$db = new SQLite3('control.db');


switch ($method) {
    case "GET":
        $sql = "SELECT `key`   FROM commands WHERE `phone` = '$phone' AND `is_readed`=0  ORDER BY `timestamp` DESC";
        
        $result_key = $db->querySingle($sql);
        $sql = "UPDATE commands SET `is_readed`=1  WHERE `phone` = '$phone' AND `is_readed`=0   ";
        $result = $db->querySingle($sql, true);
        
        $response = array('key' => $result_key, 'phone'=> $phone  );

        break;
    case "POST":
        $sql = "INSERT INTO commands (`key`,`phone`, `timestamp`, `is_readed`) VALUES('$command','$phone','$dt',0)";
        $result = $db->querySingle($sql);
        $response = array('key' => $command, 'phone'=> $phone );
        break;
    default:
        echo '{"error":"unknown method"}';
        break;
}

echo json_encode($response);
