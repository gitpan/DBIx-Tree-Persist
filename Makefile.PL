use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile
(
	($] ge '5.005') ?
	(
		AUTHOR   => 'Ron Savage <ron@savage.net.au>',
		ABSTRACT => 'Play with Tree and Tree::Persist a la DBIx::Tree',
    ) : (),
	clean =>
	{
		FILES => 'blib/* Makefile MANIFEST DBIx-Tree-Persist-*'
	},
	dist =>
	{
		COMPRESS => 'gzip',
		SUFFIX   => 'gz'
	},
	DISTNAME  => 'DBIx-Tree-Persist',
	NAME      => 'DBIx::Tree::Persist',
	PL_FILES  => {},
	PREREQ_PM =>
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
	VERSION_FROM => 'lib/DBIx/Tree/Persist.pm',
);