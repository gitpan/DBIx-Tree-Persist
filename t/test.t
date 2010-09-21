use common::sense;

use Test::More tests => 8;

use DBI;

use DBIx::Tree::Persist;

use File::Spec;
use File::Temp;

use File::Slurp; # For read_file.

use FindBin::Real;

# --------------------------------------------------

sub create_table
{
	my($dbh, $table_name) = @_;
	my($sql) = <<SQL;
create table $table_name
(
id integer not null primary key,
parent_id integer not null,
class varchar(255) not null,
value varchar(255)
)
SQL
	$dbh -> do($sql);

	return 0;

}	# End of create_table.

# -----------------------------------------------

sub insert_hash
{
	my($dbh, $table_name, $field_values) = @_;

	my(@fields) = sort keys %$field_values;
	my(@values) = @{$field_values}{@fields};
	my($sql)    = sprintf 'insert into %s (%s) values (%s)', $table_name, join(',', @fields), join(',', ('?') x @fields);

	$dbh -> do($sql, {}, @values);

	return 0;

} # End of insert_hash.

# -----------------------------------------------

sub populate_table
{
	my($dbh, $table_name) = @_;
	my($data) = read_a_file("$table_name.txt");

	my(@field);
	my($id);
	my($parent_id);
	my($result);

	for (@$data)
	{
		@field     = split(/\s+/, $_);
		$parent_id = pop @field;
		$id        = pop @field;
		$result    = insert_hash
		(
			$dbh,
			$table_name,
		 	{
			 class     => 'Tree',
			 id        => $id,
			 parent_id => $parent_id eq 'NULL' ? 0 : $parent_id,
			 value     => join(' ', @field),
		 	}
		);
	}

	return 0;

}	# End of populate_table.

# -----------------------------------------------

sub read_a_file
{
	my($input_file_name) = @_;
	$input_file_name = FindBin::Real::Bin . "/../data/$input_file_name";
	my(@line)        = read_file($input_file_name);

	chomp @line;

	return [grep{! /^$/ && ! /^#/} map{s/^\s+//; s/\s+$//; $_} @line];

} # End of read_a_file.

# ------------------------------------------------

my($dir)  = File::Temp -> newdir;
my($file) = File::Spec -> catfile($dir, 'test.sqlite');
my(@opts) =
(
$ENV{DBI_DSN}  || "dbi:SQLite:dbname=$file",
$ENV{DBI_USER} || '',
$ENV{DBI_PASS} || '',
);

my($dbh) = DBI -> connect(@opts, {RaiseError => 1, PrintError => 1, AutoCommit => 1});

ok(defined $dbh, '$dbh is defined');

my($table_name) = 'two';
my($result)     = create_table($dbh, $table_name);

ok($DBI::errstr eq '', "created table $table_name");
ok($result == 0, 'create_table() worked');

$result = populate_table($dbh, $table_name);

ok($DBI::errstr eq '', "populated table $table_name");
ok($result == 0, 'populate_table() worked');

my($persist) = DBIx::Tree::Persist -> new(table_name => $table_name, verbose => 1);

ok(defined $persist, 'DBIx::Tree::Persist.new() worked');

$result = $persist -> run;
ok($result == 0, 'DBIx::Tree::Persist.run() worked');

$dbh -> do("drop table $table_name");

ok($DBI::errstr eq '', "dropped table $table_name");

$dbh -> disconnect;
