use strict;
use warnings;
use threads;
use threads::shared;
use IO::Handle;
use IO::Socket::INET;
use IO::Socket::Multicast;
use DB::Schema;
use Data::Dumper;
use messageProbe;
use messageResolve;




my $sync : shared; #variabila shared pentru sincronizare
#my $schema : shared; #variabila folosita de treduri pentru conexiunea la baza de date

use constant GROUP => '239.1.1.1';
use constant PORT  => '3702';
use constant DESTINATION => '239.1.1.1:3702'; 

main();

sub main{
    print "--------- main --------\n";
    my $thread1;
    my $thread2;
    my $thread3;

    $thread2 = threads->new(\&threadUnicastInSocket);
    $thread1 = threads->new(\&threadMulticastOutSocket);
    $thread3 = threads->new(\&threadMulticastInSocket);

    threads->yield();

    $thread1->join();
    $thread2->join();
    $thread3->join();
}

sub threadMulticastOutSocket{
	my $socket = undef;
	my $time = undef;
	
	#initializam socketul si setam ttl = 1
	$socket = IO::Socket::Multicast->new(PROTO => 'udp', LocalPort=>PORT, PeerAddr=>DESTINATION, ReuseAddr=>1);
	$socket->mcast_ttl(1);

	
	while(1){
	    {
		    lock($sync);
			
			#copie mesajele
			`cat messagesFromWebInterface.dat >> messagesToSend.dat`;
			$time  = `date '+DATE: %d/%m/%Y TIME: %H:%M:%S'`; $time =~ s/\n//gi;
			`/bin/echo "[ClientService] [$time] [threadMulticastOutSocket::Am copiat mesajele din fisierul messagesFromWebInterface.dat]" >> threadMulticastOutSocket.log`;
			
				
			#sterge mesajele din fisierul messagesFromWebInterface.dat
			`/bin/echo "" > messagesFromWebInterface.dat`;
			$time  = `date '+DATE: %d/%m/%Y TIME: %H:%M:%S'`; $time =~ s/\n//gi;
			`/bin/echo "[ClientService] [$time] [threadMulticastOutSocket::Am sters mesajele din fisierul messagesFromWebInterface.dat]" >> threadMulticastOutSocket.log`;
			
	
			$time  = `date '+DATE: %d/%m/%Y TIME: %H:%M:%S'`; $time =~ s/\n//gi;
			`/bin/echo "[ClientService] [$time] [threadMulticastOutSocket::Deschidem fisierul messagesToSend.dat]" >> threadMulticastOutSocket.log`;
			open FILE, "< messagesToSend.dat";
			
			while(<FILE>){
				$time = `date '+DATE: %d/%m/%Y TIME: %H:%M:%S'`; $time =~ s/\n//gi;
				`/bin/echo "[ClientService] [$time] [threadMulticastOutSocket::mesaj trimis]" >> threadMulticastOutSocket.log`;
				$socket->send($_);
				sleep 5;
			}
			
			$time  = `date '+DATE: %d/%m/%Y TIME: %H:%M:%S'`; $time =~ s/\n//gi;
			`/bin/echo "[ClientService] [$time] [threadMulticastOutSocket::Inchidem fisierul messagesToSend.dat]" >> threadMulticastOutSocket.log`;
			close FILE;
			
			#stergem continutul trimis 
			`/bin/echo "" > messagesToSend.dat`;
			$time  = `date '+DATE: %d/%m/%Y TIME: %H:%M:%S'`; $time =~ s/\n//gi;
			`/bin/echo "[ClientService] [$time] [threadMulticastOutSocket::Stergem mesaje din messagesToSend.dat]" >> threadMulticastOutSocket.log`;
			
		}
		sleep(20);
	}
}

sub threadMulticastInSocket{
	my $socket = undef;
	my $time = undef;
	my $data = undef;
	
	#initializam socketul
	$socket = IO::Socket::Multicast->new(PROTO => 'udp', LocalPort=>PORT, ReuseAddr=>1);
	$socket->mcast_add(GROUP);
	

	#ne conectam la baza de data folosind ORM-ul 
	my $schema = DB::Schema->connect('dbi:mysql:database=wsstore;host=localhost;port=3306', 'root', '12345');

	while(1){
		$data = undef;
		$_ = undef;
		$socket->recv($data,9999);

		#DEBUG
		#print "-----------------------------------\n";
		#print $data . "\n"; 
		#print "-----------------------------------\n";
		
		#testeaza daca mesajul primit este de tip Hallo say Bye
		if($data =~ m/http:\/\/schemas.xmlsoap.org\/ws\/2005\/04\/discovery\/Hello/gi)
		{
			 $time  = `date '+DATE: %d/%m/%Y TIME: %H:%M:%S'`; $time =~ s/\n//gi;
			 $data =~ m/<d:Hallo><a:EndpointReference><a:Address>(.*?)<\/a:Address><\/a:EndpointReference><\/d:Hallo>/gis;
			`/bin/echo "[ClientService] [$time] [threadMulticastInSocket::Am primit un mesaj de tipul Hallo de la $1]" >> threadMulticastInSocket.log`;

			#DEBUG
		 	#print "[ClientService] [$time] [threadMulticastInSocket::Am primit un mesaj de tipul Hallo de la $1]";

			my $service_rs = $schema->resultset('W')->search({ uuid => $1  })->first;
			if($service_rs){
				$service_rs->update({ online => 1 });
			}
		}
		if($data =~ m/http:\/\/schemas.xmlsoap.org\/ws\/2005\/04\/discovery\/Bye/gi)
		{
			 $time  = `date '+DATE: %d/%m/%Y TIME: %H:%M:%S'`; $time =~ s/\n//gi;
			 $data =~ m/<d:Bye><a:EndpointReference><a:Address>(.*?)<\/a:Address><\/a:EndpointReference><\/d:Bye>/gis;
			`/bin/echo "[ClientService] [$time] [threadMulticastInSocket::Am primit un mesaj de tipul Bye de la $1]" >> threadMulticastInSocket.log`;

			#DEBUG
		 	#print "[ClientService] [$time] [threadMulticastInSocket::Am primit un mesaj de tipul Bye de la $1]";

			my $service_rs = $schema->resultset('W')->search({ uuid => $1  })->first;
                        if($service_rs){
                            $service_rs->update({ online => 0 });
                        }
		}
	}
}

sub threadUnicastInSocket{
	my $data = undef;
	my $testMatch = undef;
	my $socket = undef;
	my $time = undef;
	my $ip = undef;
	my $ipconf = undef;
	my $serverUUID = undef;
	my $probeResolve = undef;
	
	$ipconf = `/sbin/ifconfig eth0`;
	$ipconf =~ m/addr:(.*?)  Bcast/;
	$ip = $1 . ":3752";

	$socket = new IO::Socket::INET->new(Proto=>'udp', LocalAddr => $ip,  ReuseAddr=>1);
        my $schema = DB::Schema->connect('dbi:mysql:database=wsstore;host=localhost;port=3306', 'root', '12345');
	
	while(1){
		 $data = undef;
		 $testMatch = undef;
		 $socket->recv($data,9999);
		 
		 {		
		 	lock($sync);
		 	
		 	$time  = `date '+DATE: %d/%m/%Y TIME: %H:%M:%S'`; $time =~ s/\n//gi;
			`/bin/echo "[ClientService] [$time] [threadSocketInUnicast::Deschidem fisierul messagesToSend.dat]" >> threadUnicastInSocket.log`;
		 	open FILE, ">>", "messagesToSend.dat";

		 	#testeaza daca mesajul primit este de tipul ProbeMatch sau ResolveMatch
		 	if($data =~ m/http:\/\/schemas.xmlsoap.org\/ws\/2005\/04\/discovery\/ProbeMatches/gi)
		 	{
		 		$time  = `date '+DATE: %d/%m/%Y TIME: %H:%M:%S'`; $time =~ s/\n//gi;
				`/bin/echo "[ClientService] [$time] [threadSocketInUnicast::Am primit un mesaj de tip ProbeMatch]" >> threadUnicastInSocket.log`;
				print "[ClientService] [$time] [threadSocketInUnicast::Am primit un mesaj de tip ProbeMatch]\n";
				
				$data =~ m/<a:EndpointReference><a:Address>(.*?)<\/a:Address><\/a:EndpointReference>/gi;
				$serverUUID = $1;
				
				$probeResolve = new messageResolve();
				$probeResolve->addAction("http://schemas.xmlsoap.org/ws/2005/04/discovery/Resolve");
				$probeResolve->addMessageID();
				$probeResolve->addReplyTo($serverUUID);
				$probeResolve->addTo('http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous');
				$probeResolve->addResolveBody();
				$probeResolve->addXAddrs();
				
				print FILE $probeResolve->toString() . "\n";
		 	}
		 	
		 	if($data =~ m/http:\/\/schemas.xmlsoap.org\/ws\/2005\/04\/discovery\/ResolveMatches/gi)
		 	{ 		
		 		$time  = `date '+DATE: %d/%m/%Y TIME: %H:%M:%S'`; $time =~ s/\n//gi;
				`/bin/echo "[ClientService] [$time] [threadSocketInUnicast::Am primit un mesaj de tip ResolveMatch]" >> threadUnicastInSocket.log`;
				print "[ClientService] [$time] [threadSocketInUnicast::Am primit un mesaj de tip ResolveMatch]\n";
                                
				#DEBUG
				#print "Resolve Match---------------------\n";
				#print $data . "\n";
                                #print "-----------------------------------\n";

                                $data =~ m/<d:Types>(.*?)<\/d:Types>/gis;
				my $serverType = $1;

                                $data =~ m/<a:EndpointReference><a:Address>(.*?)<\/a:Address><\/a:EndpointReference>/gis;			
				my $server_uuid = $1;
                               
				$data =~ m/<d:XAddrs>(.*?)<\/d:XAddrs>/gis;
				my $serverAddr = $1;

				$schema->resultset('W')->create({ uuid => $server_uuid, type => $serverType, address => $serverAddr, online => 1 });       
		 	}
		 	
		 	`/bin/echo "[ClientService] [$time] [threadSocketInUnicast::Inchidem fisierul messagesToSend.dat]" >> threadUnicastInSocket.log`;
			close FILE;
		 }
	}
	#end while
}

