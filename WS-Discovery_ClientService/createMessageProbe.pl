use strict;
use warnings;
use messageProbe;

my $probe = undef;

$probe = new messageProbe();
$probe->addAction('http://schemas.xmlsoap.org/ws/2005/04/discovery/Probe');
$probe->addMessageID();
$probe->addTo('urn:schemas-xmlsoap-org:ws:2005:04:discovery');
$probe->addProbeBody();
$probe->addXAddrs();

print $probe->toString();
