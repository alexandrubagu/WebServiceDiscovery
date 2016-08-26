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

	$con = mysql_connect($server, $user, $passwd);
	if(!$con){
		 die('ERROR');
	}else{
		mysql_select_db($database);
	}

	$sql = "select * from ws";
	$result = mysql_query($sql);

        if(mysql_num_rows($result) > 0){
            echo '<table cellpadding="0" cellspacing="5" border="1">';
            echo '<tr>';
                    echo '<td>Online</td>';
                    echo '<td>Server Address</td>';
                    echo '<td>Server Type</td>';
                    echo '<td>Server UUID</td>';
            echo '</tr>';

            while($row = mysql_fetch_array($result)){
                    echo '<tr>';
                        echo '<td>';
                            echo  ( $row["online"] == 1 ) ? ('<img src="images/on.png" />') : ('<img src="images/off.png" />');
                        echo '</td>';
                        echo '<td>' . $row["address"] . '</td>';
                        echo '<td>' . $row["type"] . '</td>';
                        echo '<td>' . $row["uuid"] . '</td>';
                    echo '</tr>';
            }
            echo '</table>';
	}
}
?>


