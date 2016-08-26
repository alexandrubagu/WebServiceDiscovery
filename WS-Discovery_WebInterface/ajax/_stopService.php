<?php
include '../config/config.php';
include '_isAjax.php';
if(!isAjax()){
	die("error");
}else{
	$command = "ps -G alexandrubagu | grep perl";
	$data = shell_exec($command);
	preg_match('/(.*?)[ ]\?/ism',$data,$match);
	$pid = $match['1'];
	$command = "kill $pid";
	shell_exec($command);
}
?>
