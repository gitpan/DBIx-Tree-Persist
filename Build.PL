use Module::Build;

my($builder) = Module::Build -> new
(
	module_name    => 'DBIx::Tree::Persist',
	license        => 'artistic',
	dist_abstract  => 'Play with Tree and Tree::Persist a la DBIx::Tree',
	dist_author    => 'Ron Savage <ron@savage.net.au>',
	build_requires =>
	{
		Test::More => 0.94,
		Test::Pod  => 1.44,
	},
	requires =>
	{
		common::sense            => 3.3,
		Config::Tiny             => 2.12,
		Data::Dumper::Concise    => 2.012,
		DBD::SQLite              => 1.31,
		DBI                      => 1.612,
		DBIx::Admin::CreateTable => 2.07,
		File::Slurp              => 9999.13,
		FindBin::Real            => 1.05,
		Hash::FieldHash          => 0.10,
		Tree                     => 1.01,
		Tree::Persist            => 1.01,
	},
);

$builder -> add_build_element('conf');
$builder -> create_build_script();
