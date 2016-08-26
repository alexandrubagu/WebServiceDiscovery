use strict;
use warnings;
use DB::Schema;
use Data::Dumper;
my $schema = DB::Schema->connect('dbi:mysql:database=ws_discovery_store;host=localhost;port=3306', 'root', '12345');


#$schema->resultset('Service')->create({ uuid => 'my new test' , online => 1});

my $rs_new = $schema->resultset('Service')->search({ uuid => 'my new test'  })->first;


#$rs_new->types->create({ service_id => $rs_new->id, type => 'test' });

print "Closing ... \n";
DB::Schema->disconnect;
print "Closed ...\n";


