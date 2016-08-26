<?php
include '../config/config.php';
include '_isAjax.php';

if(!isAjax()){
	die("error");
}else{
	$control = "ps -eF | grep clientService.pl | wc -l";
	$count = shell_exec($control);
	if($count >= 3){
		echo "deschis";
	}else{
		$command = "cd " . CLIENT_SERVICE . "; perl clientService.pl &";
		$pipe = popen($command, "w");
		if($pipe == false){
			echo "false";
		}else{
			echo "true";
		}
	}
}
?>
