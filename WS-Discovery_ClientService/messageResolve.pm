package messageResolve;
use messageSkeleton;
use strict; 
use Data::UUID;

#contructor
sub new {
	my($class) = @_;
	my $self = {
		_messageProbe => undef,
		_aMessegeID => undef,
		_aTo => undef,
		_aAction => undef
	};
	bless($self, $class);
	#build messageProbe
	my $probe = messageSkeleton->new();
	$probe->create();
	$self->{_messageProbe} = $probe->getXML();	
    return $self;
}

#return messageProbe XML
sub getMessageProbe {
	my ($self) = @_;
	return $self->{_messageProbe};
}

#add messageID [UUID] to <s:Header> 
sub addMessageID{
	#vars
	my ($self) = @_;
	my $auxDoc = undef;
	my $root = undef;
	my $elemNode = undef;
	my $elemInsert = undef;
	
	#generate the UUID
	my $generate = new Data::UUID;
  	my $uuid = $generate->create();
	$uuid = $generate->to_string($uuid);
	
	#set value to attr.
	$self->{_aMessageID} = $uuid;
	
	#get XML document
	$auxDoc = $self->{_messageProbe};
	
	#get the root of the XML
	$root = $auxDoc->documentElement();
	
	#get s:Header node
	$elemNode = $root->firstChild;
	
	#create new node a:MessageID with the UUID
	$elemInsert = XML::LibXML::Element->new("a:MessageID");
	$elemInsert->appendText("urn:" . $self->{_aMessageID});
	$elemNode->addChild($elemInsert);
}

#add action to message
sub addAction{
	#vars
	my ($self) = @_;
	my $auxDoc = undef;
	my $root = undef;
	my $elemNode = undef;
	my $elemInsert = undef;
	
	#get XML document
	$auxDoc = $self->{_messageProbe};
	
	#get the root of the XML
	$root = $auxDoc->documentElement();
	
	#get s:Header node
	$elemNode = $root->firstChild;
	
	#create new node a:MessageID with the UUID
	$elemInsert = XML::LibXML::Element->new("a:Action");
	$elemInsert->appendText($_[1]);
	$elemNode->addChild($elemInsert);
}

#add to child to message
sub addTo{
	#vars
	my ($self) = @_;
	my $auxDoc = undef;
	my $root = undef;
	my $elemNode = undef;
	my $elemInsert = undef;
	
	#get XML document
	$auxDoc = $self->{_messageProbe};
	
	#get the root of the XML
	$root = $auxDoc->documentElement();
	
	#get s:Header node
	$elemNode = $root->firstChild;
	
	#create new node a:MessageID with the UUID
	$elemInsert = XML::LibXML::Element->new("a:To");
	$elemInsert->appendText($_[1]);
	$elemNode->addChild($elemInsert);
}

#add ReplyTo child to message
sub addReplyTo{
	#vars
	my ($self) = @_;
	my $auxDoc = undef;
	my $root = undef;
	my $elemNode = undef;
	my $elemInsert = undef;
	my $elemInsert2 = undef;
	my $elemInsert3 = undef;
	
	#get XML document
	$auxDoc = $self->{_messageProbe};
	
	#get the root of the XML
	$root = $auxDoc->documentElement();
	
	#get s:Body node
	$elemNode = $root->lastChild;
	
	#create new node a:ReplyTo
	$elemInsert = XML::LibXML::Element->new("a:ReplyTo");
	$elemInsert2 = XML::LibXML::Element->new("a:EndpointReference");
	$elemInsert3 = XML::LibXML::Element->new("a:Address");
	$elemInsert3->appendText($_[1]);
	
	$elemInsert->addChild($elemInsert2);
	$elemInsert2->addChild($elemInsert3);
	$elemNode->addChild($elemInsert);	
}


sub addResolveBody {
	my ($self) = @_;
	my $auxDoc = undef;
	my $root = undef;
	my $elemNode = undef;
	my $elemInsert = undef;
	
	$auxDoc = $self->{_messageProbe};
	
	$root = $auxDoc->documentElement();
	
	$elemNode = $root->lastChild;
	
	$elemInsert = XML::LibXML::Element->new("d:Resolve");
	$elemInsert->appendText(" ");
	$elemNode->addChild($elemInsert);
}

sub addXAddrs{
	#vars
	my ($self) = @_;
	my $auxDoc = undef;
	my $root = undef;
	my $elemNode = undef;
	my $elemInsert = undef;
	my $ipconf = undef;
	my $ip = undef;
	
	$auxDoc = $self->{_messageProbe};
	
	$root = $auxDoc->documentElement();
	
	$elemNode = $root->lastChild;
	$elemInsert = XML::LibXML::Element->new("d:XAddrs");
	
	$ipconf = `/sbin/ifconfig eth0`;
	$ipconf =~ m/addr:(.*?)  Bcast/gi;
	
	$ip = $1 . ":3752";

	$elemInsert->appendText($ip);
	$elemNode->addChild($elemInsert);
	
}

#convert XML to string and return it
sub toString {
	my($self) = @_;
	my $stringProbe = undef;
	my $strOut = $self->{_messageProbe};
	$stringProbe = $strOut->toString;
	$stringProbe =~ s/\<\?xml version=\"1.0\" encoding=\"UTF-8\"\?\>//;
	$stringProbe =~ s/[\n\r]//mg;
	return $stringProbe;
}

1;
