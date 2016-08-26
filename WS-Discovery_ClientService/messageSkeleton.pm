package messageSkeleton;
use strict;
use XML::LibXML;

#contructor
sub new {
	#my($class, $name) = @_;
	my($class) = @_; 
	my $self = {
		_xmlDoc => undef
	};
	bless $self, $class;
	return $self;
}
#create XML
sub create {
	my($self) = @_;
	#vars
	my $xmlDoc = undef;
	my $root = undef;
	my $elemNode = undef;
	my $attr = undef;
	#create new XML::Document
	$xmlDoc = XML::LibXML::Document->createDocument( "1.0", "UTF-8" );
	#create the root node and set the attributes to this
	$root = XML::LibXML::Element->new("s:Envelope");
	$root->setAttribute("xmlns:a", "http://schemas.xmlsoap.org/ws/2004/08/addressing");
	$root->setAttribute("xmlns:d", "http://schemas.xmlsoap.org/ws/2005/04/discovery");
	$root->setAttribute("xmlns:s", "http://www.w3.org/2003/05/soap-envelope");
	#add root node to document
	$xmlDoc->setDocumentElement($root);
	#add header element as child of the root
	$elemNode = XML::LibXML::Element->new("s:Header");
	$root->addChild($elemNode);
	#add body element as child of the root
	$elemNode = XML::LibXML::Element->new("s:Body");
	$root->addChild($elemNode);
	#set data to attr. xmlDoc of class 
	$self->{_xmlDoc} = $xmlDoc;
}
 
#get XML
sub getXML {
	my($self) = @_;
	return $self->{_xmlDoc};
}

#convert XML to string and return it
sub toString {
	my($self) = @_;
	my $strOut = $self->{_xmlDoc};
	return $strOut->toString;
}

1;