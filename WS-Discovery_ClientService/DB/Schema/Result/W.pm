package DB::Schema::Result::W;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

DB::Schema::Result::W

=cut

__PACKAGE__->table("ws");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 uuid

  data_type: 'varchar'
  is_nullable: 0
  size: 36

=head2 type

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 address

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 online

  data_type: 'tinyint'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "uuid",
  { data_type => "varchar", is_nullable => 0, size => 36 },
  "type",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "address",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "online",
  { data_type => "tinyint", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-05-29 13:21:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mY1+O0LDytI0kbru//n3CQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
