use warnings;
use threads;
use threads::shared;
use IO::Socket::INET;
use IO::Socket::Multicast;
use messageProbeMatch;
use messageResolveMatch;
use messageHallo;
use messageBye;

use constant GROUP => '239.1.1.1';
use constant PORT  => '3702';
use constant DESTINATION => '239.1.1.1:3702'; 


my $s1 = undef;
my $s2 = undef;
my $s3 = undef;
my $s4 = undef;
my $s5 = undef;
my $s6 = undef;
my $s7 = undef;
my $s8 = undef;
my $s9 = undef;
my $s10 = undef;
my $s11 = undef;
my $s12 = undef;
my $s13 = undef;
my $s14 = undef;
my $s15 = undef;


$s1 =  threads->new(\&server, "www.myserver1.ro", 40, 'printer-basic');
$s2 =  threads->new(\&server, "www.myserver2.ro", 50, 'printer-advanced');
$s3 =  threads->new(\&server, "www.myserver3.ro", 60, 'whois');
$s4 =  threads->new(\&server, "www.myserver4.ro", 70, 'biling system');
$s5 =  threads->new(\&server, "www.myserver5.ro", 40, 'alarm');
$s6 =  threads->new(\&server, "www.myserver6.ro", 80, 'testing');
$s7 =  threads->new(\&server, "www.myserver7.ro", 90, 'syncronisation');
$s8 =  threads->new(\&server, "www.myserver8.ro", 50, 'speker');
$s9 =  threads->new(\&server, "www.myserver9.ro", 100, 'agenda');
$s10 =  threads->new(\&server, "www.myserver10.ro", 100, 'contacts');
$s11 =  threads->new(\&server, "www.myserver11.ro", 70, 'mobile');
$s12 =  threads->new(\&server, "www.myserver12.ro", 90, 'resources');
$s13 =  threads->new(\&server, "www.myserver13.ro", 100, 'games');
$s14 =  threads->new(\&server, "www.myserver14.ro", 80, 'addressing');
$s15 =  threads->new(\&server, "www.myserver15.ro", 90, 'discovery');


threads->yield();

$s1->join;
$s2->join;
$s3->join;
$s4->join;
$s5->join;
$s6->join;
$s7->join;
$s8->join;
$s9->join;
$s10->join;
$s11->join;
$s12->join;
$s13->join;
$s14->join;
$s15->join;


sub server {
	our $serverAddr = shift;
	our $timeTo = shift;
	our $type = shift;
	
	our $sync = 0;
	
	our $socketMulticast = undef;
	our $socketUnicast = undef;
	our $socketMulticast2 = undef;
	our $time = undef;
	our $data = undef;
	our $clientMessageID = undef;
	our $probeMatch = undef;
	our $resolveMatch = undef;
	our $uuidCreate = undef;
	our $uuidServer = undef;
	our $clientAddr = undef;
	our $ipaddr = undef;
	our $ipANDport = undef;
	our $auxUUID = undef;
	our $thread1 = undef;
	our $thread2 = undef;
	our $type_data = undef;
	
	#uuid 
	$uuidCreate = new Data::UUID;
	$uuid = $uuidCreate->create_from_name_str(NameSpace_URL, $serverAddr);
	
	#threaduri
	$thread1 = threads->new(\&recv);
	$thread2 = threads->new(\&send);	
	threads->yield();
	$thread1->join;
	$thread2->join;
	
	sub recv {		
		#socket mulicast
		$socketMulticast = IO::Socket::Multicast->new(PROTO => 'udp', LocalPort=>PORT,  ReuseAddr=>1);
		$socketMulticast->mcast_add(GROUP);
		
		#socket unicast
		$socketUnicat = new IO::Socket::INET->new(Proto=>'udp', ReuseAddr=>1);
		
		
		while(1){
			$data = undef;
			$_ = undef;
			$ipaddr = undef;
			
			$socketMulticast->recv($data,9999); 
		
			#mesajul este de tip Probe
			if($data =~ m/http:\/\/schemas.xmlsoap.org\/ws\/2005\/04\/discovery\/Probe/)
			{	
				$data =~ m/<d:Types>(.*?)<\/d:Types>/;
				$type_data = $1;

				if($type_data){
					if($type_data eq $type){
						$data =~ m/<a:MessageID>(.*?)<\/a:MessageID>/;
	                    $clientMessageID = $1;

    	                $data =~ m/<d:XAddrs>(.*?)<\/d:XAddrs>/;
        	            $clientAddr = $1;

            	        $probeMatch = new messageProbeMatch();
                	    $probeMatch->addAction('http://schemas.xmlsoap.org/ws/2005/04/discovery/ProbeMatches');
                    	$probeMatch->addMessageID();
	                    $probeMatch->addRelates($clientMessageID);
    	                $probeMatch->addTo('http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous');
						$probeMatch->addType($type);
            	        $probeMatch->addEndpointReference($uuid);

                	    $clientAddr =~ m/:/;
                    	$ipaddr   = inet_aton($`);
	                    $ipANDport = sockaddr_in($', $ipaddr);

    	                $socketUnicat->send($probeMatch->toString(), 0, $ipANDport);
        	            print $serverAddr . " Send ProbeMatches Message\n";
					}
				}else{
					$data =~ m/<a:MessageID>(.*?)<\/a:MessageID>/;
					$clientMessageID = $1;
			
					$data =~ m/<d:XAddrs>(.*?)<\/d:XAddrs>/;
					$clientAddr = $1;
				
					$probeMatch = new messageProbeMatch();
					$probeMatch->addAction('http://schemas.xmlsoap.org/ws/2005/04/discovery/ProbeMatches');
					$probeMatch->addMessageID();
					$probeMatch->addRelates($clientMessageID);
					$probeMatch->addTo('http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous');
					$probeMatch->addProbeMatchBody();
					$probeMatch->addType($type);
					$probeMatch->addEndpointReference($uuid);
				
					$clientAddr =~ m/:/;
					$ipaddr   = inet_aton($`); 
					$ipANDport = sockaddr_in($', $ipaddr);
					
					$socketUnicat->send($probeMatch->toString(), 0, $ipANDport);
					print $serverAddr . " Send ProbeMatches Message\n";
				}
			}
			
			#mesajul este de tip Resolve
			if($data =~ m/http:\/\/schemas.xmlsoap.org\/ws\/2005\/04\/discovery\/Resolve/gi)
			{	
				#verificam daca UUID-ul din ReplyTo se adreseaza acestui server
				$data =~ m/<a:ReplyTo><a:EndpointReference><a:Address>(.*?)<\/a:Address><\/a:EndpointReference><\/a:ReplyTo>/gis;
				$auxUUID = $1;
		
				if($auxUUID eq $uuid){	
					$data =~ m/<a:MessageID>(.*?)<\/a:MessageID>/;
					$clientMessageID = $1;
					
					$data =~ m/<d:XAddrs>(.*?)<\/d:XAddrs>/;
					$clientAddr = $1;
					
					$resolveMatch = new messageResolveMatch();
					$resolveMatch->addAction('http://schemas.xmlsoap.org/ws/2005/04/discovery/ResolveMatches');
					$resolveMatch->addMessageID();
					$resolveMatch->addRelates($clientMessageID);
					$resolveMatch->addTo('http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous');
					$resolveMatch->addResolveMatchBody();
					$resolveMatch->addType($type);
					$resolveMatch->addXAddrs($serverAddr);
					$resolveMatch->addEndpointReference($uuid);
					
					
					$clientAddr =~ m/:/;
					$ipaddr   = inet_aton($`); 
					$ipANDport = sockaddr_in($', $ipaddr);
					
					$socketUnicat->send($resolveMatch->toString(), 0, $ipANDport);
					print $serverAddr . " Send ResolveMatches Message\n";
				}
			}
		}
	}
	
	
	sub send{
		my $messageHallo = undef;
		my $messageBye = undef;
		
		$socketMulticast2 = IO::Socket::Multicast->new(PROTO => 'udp', LocalPort=>PORT, PeerAddr=>DESTINATION, ReuseAddr=>1);
		$socketMulticast2->mcast_ttl(1);
		
		while(1){
			sleep($timeTo);
			
			$messageBye = undef;
			$messageHallo = undef;
			
			if($sync == 0){	
				#Bye 
				$messageBye = new messageBye();
				$messageBye->addAction('http://schemas.xmlsoap.org/ws/2005/04/discovery/Bye');
				$messageBye->addMessageID();
				$messageBye->addTo('urn:schemas-xmlsoap-org:ws:2005:04:discovery');
				$messageBye->addByeBody();
				$messageBye->addEndpointReference($uuid);

				$socketMulticast2->send($messageBye->toString());
				print $serverAddr . " Send Bye Message\n";
				
				$sync = 1;
			}else{
				$messageHallo = new messageHallo();
				$messageHallo->addAction('http://schemas.xmlsoap.org/ws/2005/04/discovery/Hello');
				$messageHallo->addMessageID();
				$messageHallo->addTo('urn:schemas-xmlsoap-org:ws:2005:04:discovery');
				$messageHallo->addHalloBody();
				$messageHallo->addEndpointReference($uuid); 
				
				$socketMulticast2->send($messageHallo->toString());
				print $serverAddr . " Send Hallo Message\n";
				
				$sync = 0;
			}
		}
	}
	#end send sub
}
