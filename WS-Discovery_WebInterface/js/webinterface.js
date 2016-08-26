$(document).ready(function(){

	$('button').eq(0).css('margin-left', '20px');

	/* initializare butoane */
	$('button').each(function(){
		$(this).button();
	});
	
	$('button').eq(0).click(function(){
		var status = $.ajax({
			url: 'ajax/_startService.php',
			async: false
		}).responseText;
		
		if(status == "deschis"){
			$('#widgetAlert1').html('<h3>Serviciul este deja deschis ! Nu putem deschide mai multe servicii !</h3>');
		}
		if(status == "true"){
			$('#widgetAlert1').html('<h3>Serviciul a fost pornit !!</h3>');
		}
		if(status == "false"){
			$('#widgetAlert1').html('<h3>Nu pot initia serviciul !</h3>');
		}
		$('#widgetAlert1').dialog('open');
	});
	
	$('button').eq(1).click(function(){
		var isWorking = $.ajax({
		    url: 'ajax/_isWorking.php',
		    async: false
		}).responseText;
		if(isWorking == "true"){
			var status = $.ajax({
				url: 'ajax/_stopService.php',
				async: false
			}).responseText;
			$('#widgetAlert2').html('<h3>Am inchis serviciul !</h3>');
			$('#widgetAlert2').dialog('open');
		}else{
			$('#widgetAlert2').html('<h3>Serviciul nu este deschis pentru a putea fi inchis !</h3>');
			$('#widgetAlert2').dialog('open');
		}
	});
	
	$('button').eq(2).click(function(){
		$('#widgetViewWS').dialog('open');
	});
	
	$('button').eq(3).click(function(){
		$('#widgetDiscoverAll').dialog('open');
	});
	
	$('button').eq(4).click(function(){
		$('#widgetSearch').dialog('open');
	});
	
	$('button').eq(5).click(function(){
		$('#widgetThreads').dialog('open');
	});
	
	$('button').eq(6).click(function(){
		$('#widgetLogs').dialog('open');
	});

	$('button').eq(7).click(function(){
		var isWorking = $.ajax({
		    url: 'ajax/_isWorking.php',
		    async: false
		}).responseText;
		if(isWorking == "true"){
                        /* stergem tot din baza de date si fisierele messagesToSend.dat, messagesFromWebInterface.dat */
                        var error = $.ajax({
                            url: 'ajax/_clearDBandMesseges.php',
                            async: false
                        }).responseText;
						console.log(error);
                        
			var status = $.ajax({
				url: 'ajax/_createProbeAll.php',
				async: false
			}).responseText;
			if(status == "true"){
				$('#widgetAlert2').html('<h3>Am creat proba !</h3>');
				$('#widgetAlert2').dialog('open');
			}
		}else{
			$('#widgetAlert2').html('<h3>Proba nu poate fi creeata deoarece serviciul nu este deschis !</h3>');
			$('#widgetAlert2').dialog('open');
		}
	});

	$('button').eq(8).click(function(){
		var isWorking = $.ajax({
		    url: 'ajax/_isWorking.php',
		    async: false
		}).responseText;
		if(isWorking == "true"){
                        /* stergem tot din baza de date si fisierele messagesToSend.dat, messagesFromWebInterface.dat */
                        var error = $.ajax({
                            url: 'ajax/_clearDBandMesseges.php',
                            async: false
                        }).responseText;
						console.log(error);                    

			var value = $('.customsearch option:selected').val();
			var status = $.ajax({
				type: "POST",
				url: "ajax/_createProbe.php",
				data: "type=" + value
			});
		
		}else{
			$('#widgetAlert2').html('<h3>Proba nu poate fi creeata deoarece serviciul nu este deschis !</h3>');
			$('#widgetAlert2').dialog('open');
		}
	});
	
	$('#widgetViewWS').dialog({
		autoOpen: true,
		resizable: true,
		draggable: false,
		show: 'clip',
		hide: 'blind',
		title: '- Vizualizare Servicii Web Descoperite -',
		width: 500,
		height: 250,
		position: [186, 80]
	});
	
	$('#widgetLogs').dialog({
		autoOpen: true,
		resizable: false,
		draggable: false,
		show: 'clip',
		hide: 'blind',
		title: ' - Loguri Web Interface - ',
		width: 900,
		height: 250,
		position: [186, 355]
	});
	
	$('#widgetDiscoverAll').dialog({
		autoOpen: true,
		resizable: false,
		draggable: false,
		show: 'clip',
		hide: 'blind',
		title: ' - Descopera toate serviciile web - ',
		width: 360,
		height: 80,
		position: [710, 80]
	});
	
	$('#widgetSearch').dialog({
		autoOpen: true,
		resizable: false,
		draggable: false,
		show: 'clip',
		hide: 'blind',
		title: ' - Cautare Avansata - ',
		width: 360,
		height: 150,
		position: [710, 180]
	});
	
	$('#widgetAlert1').dialog({
		autoOpen: false,
		resizable: false,
		draggable: false,
		show: 'pulsate',
		modal: true,
		title: ' - Alert -',
		width: 350,
		height: 200
	});
	
	$('#widgetAlert2').dialog({
		autoOpen: false,
		resizable: false,
		draggable: false,
		show: 'pulsate',
		modal: true,
		title: ' - Alert -',
		width: 350,
		height: 200
	});

	window.setInterval(function(){
		var isWorking = $.ajax({
		    url: 'ajax/_isWorking.php',
		    async: false
		}).responseText;

		if(isWorking == "true"){
			/* get logs */

/*
			var logs = $.ajax({
			url: 'ajax/_getLogs.php',
			    async: false
			}).responseText;

*/			
			/* update the widgetLogs */
/*
			$('#widgetLogs').html('');
			$('#widgetLogs').html(logs);
*/	
			var ws_services = $.ajax({
			url: 'ajax/_getServices.php',
			async: false
			}).responseText;
                        
                        $('#widgetViewWS').html('');
                        $('#widgetViewWS').html(ws_services);
                        
		}
	}, 1500);

});
