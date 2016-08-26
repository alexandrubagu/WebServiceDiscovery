<?php
include '_isAjax.php';
include '../config/config.php';

if(!isAjax()){
	die("Are you a haker ?");
}else{
	$file_log_multicast_out = fopen(LOG_MULTICAST_OUT, 'r');
	$big_array = array();
	while(!feof($file_log_multicast_out)){
		$line = fgets($file_log_multicast_out);
		
		preg_match('/DATE: (.*?) TIME/ism',$line, $match);
		$date = $match['1'];
		$date = str_replace('/','-',$date);
		
		preg_match('/TIME: (.*?)]/ism',$line, $match);
		$time = $match['1'];
		$dateTime = $date . " " . $time;
	
		$dateTime = strtotime($dateTime);
		
		if(array_key_exists($dateTime, $big_array)){
			$arrayAux = (array) $big_array[$dateTime];
			$arrayAux[] = $line;
			$big_array[$dateTime] = $arrayAux;
		}else{
			$big_array[$dateTime] = $line;
		}
	}
	
	$file_log_multicast_in = fopen(LOG_MULTICAST_IN, 'r');
	while(!feof($file_log_multicast_in)){
		$line = fgets($file_log_multicast_in);
		
		preg_match('/DATE: (.*?) TIME/ism',$line, $match);
		$date = $match['1'];
		$date = str_replace('/','-',$date);
		
		preg_match('/TIME: (.*?)]/ism',$line, $match);
		$time = $match['1'];
		$dateTime = $date . " " . $time;
	
		$dateTime = strtotime($dateTime);
		
		if(array_key_exists($dateTime, $big_array)){
			$arrayAux = (array) $big_array[$dateTime];
			$arrayAux[] = $line;
			$big_array[$dateTime] = $arrayAux;
		}else{
			$big_array[$dateTime] = $line;
		}
	}
	
	$file_log_unicast_in = fopen(LOG_UNICAST_IN, 'r');
	while(!feof($file_log_unicast_in)){
		$line = fgets($file_log_unicast_in);
		
		preg_match('/DATE: (.*?) TIME/ism',$line, $match);
		$date = $match['1'];
		$date = str_replace('/','-',$date);
		
		preg_match('/TIME: (.*?)]/ism',$line, $match);
		$time = $match['1'];
		$dateTime = $date . " " . $time;
	
		$dateTime = strtotime($dateTime);
		
		if(array_key_exists($dateTime, $big_array)){
			$arrayAux = (array) $big_array[$dateTime];
			$arrayAux[] = $line;
			$big_array[$dateTime] = $arrayAux;
		}else{
			$big_array[$dateTime] = $line;
		}
	}
	
	$last_key = end(array_keys($big_array));
	unset($big_array[$last_key]);
	krsort($big_array);
	
	if(count($big_array) > 20){
		$myControl = 0;
		foreach($big_array as $key => $new_array){
			foreach($new_array as $value){
				if($myControl > 20) {
					break;
				}else{
					echo '<p>' . $value . '</p>';
					$myControl++;
				}
			} 
		}
	}else{
		foreach($big_array as $key => $new_array)
			foreach($new_array as $value)
				echo '<p>' . $value . '</p>';
	}
}
?>
