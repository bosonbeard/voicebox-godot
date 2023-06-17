<?php

header("Access-Control-Allow-Orgin: *");
header("Access-Control-Allow-Methods: *");
header("Content-Type: application/json");

$method = $_SERVER['REQUEST_METHOD'];


$db = new SQLite3('control.db');

//$songId=$_REQUEST["s"];
//echo "aaa".$songId;

$dt = date('c', time());
//$sql = 'INSERT INTO "commands" ("key", "phone", "timestamp", "is_readed") VALUES("up", "79651988777",'.$dt.',0)';
//    echo "stat1 {$sql}";
$sql = "INSERT INTO commands (`key`,`phone`, `timestamp`, `is_readed`) VALUES('up','79651988777','$dt',0)";
$result = $db->querySingle($sql);

//echo $dt;


$sql = "SELECT `key`  FROM commands";
 
$result = $db->querySingle($sql, true);
echo $result;

//echo $method;


switch ($method) {
    case "GET":
        $response = array('key' => "down" );

        break;
    case "POST":
        $response = array('key' => "up" );
        break;
    default:
        echo '{"error":"unknown method"}';
        break;
}


//echo json_encode($response);
?>