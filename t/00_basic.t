#!/usr/bin/perl -w

# some basic tests of graphcnv

use Test::More;

my $out;

BEGIN
  {
  plan tests => 13;
  chdir 't' if -d 't';

  use File::Spec;

  $out = File::Spec->catfile('images','graph','4f03986d082bb194583e50624debc5208491be5b.svg');
  }

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

$rc = `$cmd '[Bonn]->[Berlin]' 'utf-8' 'boxart'`;
like ($rc, qr/│ Bonn/, 'render graph as boxart');
unlike ($rc, qr/<table/, 'render graph not as html');

SKIP:
  {
  eval { require Graph::Easy::As_svg; };

  skip ('Graph::Easy::As_svg not installed', 6)
    unless defined $Graph::Easy::As_svg::VERSION;

  mkdir 'images';
  mkdir File::Spec->catdir('images','graph');

  # clean up
  my $out = File::Spec->catfile('images','graph','4f03986d082bb194583e50624debc5208491be5b.svg');
  unlink $out if -f $out; 
 
  $rc = `$cmd '[Bonn]->[Berlin]' 'utf-8' 'svg'`;
  like ($rc, qr/<object/, 'included as object tag');
  like ($rc, qr/<a title=.* href=/, 'included alt text');
  unlike ($rc, qr/^\s/m, 'no leading spaces');
  unlike ($rc, qr/\n\n/, 'no empty lines');

  like ($rc, qr/4f03986d082bb194583e50624debc5208491be5b\.svg/,
    'sample graph hashed to 4f03986d082bb194583e50624debc5208491be5b');

  ok (-f File::Spec->catfile('images','graph','4f03986d082bb194583e50624debc5208491be5b.svg'), 'output file exists');

  };

END
  {
  unlink $out if -f $out;
  }
