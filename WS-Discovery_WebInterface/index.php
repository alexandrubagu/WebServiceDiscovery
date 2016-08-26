<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en_US" xml:lang="en_US">
<head>
<title>WS-Discovery - Web Interface</title>
<link type="text/css" href="css/custom-theme/jquery-ui-1.8.12.custom.css" rel="stylesheet" />
<link type="text/css" href="css/style.css" rel="stylesheet" />
<script type="text/javascript" src="js/jquery-1.5.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.12.custom.min.js"></script>
 <script type="text/javascript" src="js/webinterface.js"></script> 
</head>
<body>
	<!-- Containter -->
	<div id="container">
	
		<!-- Bara care contine widgeturile -->
		<div class="bar ui-corner-all">
			<ul>
				<li><button>Start ClientService</button></li>
				<li><button>Stop ClientService</button></li>
				<li><button>Vizualizare servicii web</button></li>
				<li><button>Cautare</button></li>
				<li><button>Cautare avansata</button></li>
				<li><button>Infos</button></li>
				<li><button>Loguri</button></li>
			</ul>
		</div>
	
		<!-- Vizualizare toate serviciile descoperite -->
		<div id="widgetViewWS"></div>
		
		<!-- Descopera toate serviciile web-->
		<div id="widgetDiscoverAll"><button>Descopera toate serviciile</button></div>
		
		<!-- Descopera servicii web dupa anumite constrangeri -->
		<div id="widgetSearch">
			<select class="customsearch">
				<option value="null">------------</option>
				<option value="printer-basic">printer basic</option>
				<option value="printer-advanced">printer advanced</option>
				<option value="whois">whois</option>
				<option value="biling system">biling system</option>
				<option value="alarm">alarm</option>
				<option value="testing">testing</option>
				<option value="syncronisation">syncronisation</option>
				<option value="spake">spake</option>
				<option value="agenda">agenda</option>
				<option value="contacts">contacts</option>
				<option value="mobile">mobile</option>
				<option value="resources">resources</option>
				<option value="games">games</option>
				<option value="addressing">addressing</option>
				<option value="discovery">discovery</option>
			</select>
			<button>Custom Search</button>
		</div>
		
		<!-- Loguri -->
		<div id="widgetLogs"></div>
		
		<!-- Alerte -->
		<div id="widgetAlert1"></div>
		<div id="widgetAlert2"></div>
	</div>
</body>
</html>
