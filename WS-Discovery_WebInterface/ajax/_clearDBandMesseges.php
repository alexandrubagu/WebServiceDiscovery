<?php
include '../config/config.php';
include '_isAjax.php';

if(!isAjax()){
	die("error");
}else{
    $server = "localhost";
    $user = "root";
    $passwd = "12345";
    $database = "wsstore";
    
    $con = mysql_connect($server,$user, $passwd);
    if(!$con){
		echo "error";
	} else{
		mysql_select_db($database);
	}


    $sql = "truncate ws";
    $result = mysql_query($sql);

    $command = "cd " . CLIENT_SERVICE . "; echo -n > messagesFromWebInterface.dat; echo -n > messagesToSend.dat; ";
    $pipe = popen($command, "w");
    if($pipe == false){
		echo "false";
    }else{
		echo "true";
    }
}
?>
