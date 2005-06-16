#!/usr/bin/perl -w

# some basic tests of graphcnv

use Test::More;

BEGIN
  {
  plan tests => 7;
  chdir 't' if -d 't';
  }

my $rc = `../graphcnv`;
like ($rc, qr/Usage:/, 'usage instruction');

$rc = `../graphcnv '[Bonn]->[Berlin]' 'utf-8'`;
like ($rc, qr/Bonn/, 'render graph');
like ($rc, qr/<table/, 'render graph as html');

$rc = `../graphcnv '[Bonn]->[Berlin]' 'utf-8' 'ascii'`;
like ($rc, qr/\| Bonn/, 'render graph as ascii');
unlike ($rc, qr/<table/, 'render graph not as html');

$rc = `../graphcnv '[Bonn]->[Berlin]' 'utf-8' 'svg'`;
like ($rc, qr/svg/, 'render graph as svg');
like ($rc, qr/Bonn/, 'render graph as svg');

