#!/usr/bin/perl -w

# some basic tests of graphcnv

use Test::More;

BEGIN
  {
  plan tests => 9;
  chdir 't' if -d 't';
  }

use File::Spec;

my $cmd = File::Spec->catdir( File::Spec->updir(),'graphcnv' );

$cmd = 'perl ' . $cmd if $^O =~ /mswin/;

my $rc = `$cmd`;
like ($rc, qr/Usage:/, 'usage instruction');

$rc = `$cmd '[Bonn]->[Berlin]' 'utf-8'`;
like ($rc, qr/Bonn/, 'render graph');
like ($rc, qr/<table/, 'render graph as html');

$rc = `$cmd '[Bonn]->[Berlin]' 'utf-8' 'ascii'`;
like ($rc, qr/\| Bonn/, 'render graph as ascii');
unlike ($rc, qr/<table/, 'render graph not as html');

SKIP:
  {
  eval { require Graph::Easy::As_svg; };

  skip ('Graph::Easy::As_svg not installed', 2)
    unless defined $Graph::Easy::As_svg::VERSION;

  $rc = `$cmd '[Bonn]->[Berlin]' 'utf-8' 'svg'`;
  like ($rc, qr/svg/, 'render graph as svg');
  like ($rc, qr/Bonn/, 'render graph as svg');
  unlike ($rc, qr/^\s/m, 'no leading spaces');
  unlike ($rc, qr/\n\n/, 'no empty lines');
  };


