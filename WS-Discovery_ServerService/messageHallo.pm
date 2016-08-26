package messageHallo;
use strict;
use warnings;
use Data::UUID;
use messageSkeleton;

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


sub getMessageProbe {
	my ($self) = @_;
	return $self->{_messageProbe};
}


sub addMessageID{
	my ($self) = @_;
	my $auxDoc = undef;
	my $root = undef;
	my $elemNode = undef;
	my $elemInsert = undef;
	
	my $generate = new Data::UUID;
  	my $uuid = $generate->create();
	$uuid = $generate->to_string($uuid);
	
	$self->{_aMessageID} = $uuid;
	
	$auxDoc = $self->{_messageProbe};
	
	$root = $auxDoc->documentElement();
	
	$elemNode = $root->firstChild;
	
	$elemInsert = XML::LibXML::Element->new("a:MessageID");
	$elemInsert->appendText("urn:" . $self->{_aMessageID});
	$elemNode->addChild($elemInsert);
}

sub addAction{
	#vars
	my ($self) = @_;
	my $auxDoc = undef;
	my $root = undef;
	my $elemNode = undef;
	my $elemInsert = undef;
	
	$auxDoc = $self->{_messageProbe};
	
	$root = $auxDoc->documentElement();
	
	$elemNode = $root->firstChild;
	
	$elemInsert = XML::LibXML::Element->new("a:Action");
	$elemInsert->appendText($_[1]);
	$elemNode->addChild($elemInsert);
}


sub addTo{
	my ($self) = @_;
	my $auxDoc = undef;
	my $root = undef;
	my $elemNode = undef;
	my $elemInsert = undef;
	
	$auxDoc = $self->{_messageProbe};
	
	$root = $auxDoc->documentElement();
	
	$elemNode = $root->firstChild;
	
	$elemInsert = XML::LibXML::Element->new("a:To");
	$elemInsert->appendText($_[1]);
	$elemNode->addChild($elemInsert);
}


sub addHalloBody {
	my ($self) = @_;
	my $auxDoc = undef;
	my $root = undef;
	my $elemNode = undef;
	my $elemInsert = undef;
	
	$auxDoc = $self->{_messageProbe};
	
	$root = $auxDoc->documentElement();
	
	$elemNode = $root->lastChild;
	
	$elemInsert = XML::LibXML::Element->new("d:Hallo");
	$elemNode->addChild($elemInsert);
}

sub addEndpointReference {
	my ($self) = @_;
	my $auxDoc = undef;
	my $root = undef;
	my $elemNode = undef;
	my $elemInsert = undef;
	
	$auxDoc = $self->{_messageProbe};
	
	$root = $auxDoc->documentElement();
	
	$elemNode = $root->lastChild;
	
	$elemNode = $elemNode->firstChild;
	
	$elemInsert = XML::LibXML::Element->new("a:EndpointReference");
	
	my $auxElemInsert = XML::LibXML::Element->new("a:Address");
	$auxElemInsert->appendText($_[1]);
	
	$elemInsert->addChild($auxElemInsert);

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