<?php
include '../config/config.php';
include '_isAjax.php';

if(!isAjax()){
	die("error");
}else{
	$command = "cd " . CLIENT_SERVICE . "; perl createMessageProbe.pl >> messagesFromWebInterface.dat";
	$pipe = popen($command, "w");
	if($pipe == false){
		echo "false";
	}else{
		echo "true";
	}
}
?>


