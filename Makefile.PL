use 5.006001;
use ExtUtils::MakeMaker;
use strict;

sub MY::metafile {
  package MY;
  my $self = shift;
  if (!eval { require YAML; 1 })
  {
    warn ("YAML not installed, 'make dist' will not override 'META.yml'.");
    return $self->SUPER::metafile_target(@_);
  };

  require YAML::Node;
  my $node = YAML::Node->new({});

  $node->{name}                 = $self->{DISTNAME};
  $node->{abstract}		= $self->{ABSTRACT};
  $node->{version}              = $self->{VERSION};
  $node->{version_from}         = $self->{VERSION_FROM};
  $node->{license}              = 'gpl';
  $node->{distribution_type}    = 'module';
  $node->{generated_by}         = "$self->{DISTNAME} version $self->{VERSION}";
  $node->{installdirs}          = 'site';
  $node->{requires}             = $self->{PREREQ_PM};

  my $dump = YAML::Dump( $node );

  $dump =~ s/^(.*)$/\t\$(NOECHO) \$(ECHO) "$1" >>META.yml/gm;
  $dump =~ s/>>META\.yml/>META.yml/;

  return "metafile:\n$dump";
}

# svg is done via dot, too.
eval { require Graph::Easy::As_svg; };

my $ver = $Graph::Easy::As_svg::VERSION;

if (!defined $ver)
  {
  print "\n************\nWARNING: ";
  print "You do not seem to have Graph::Easy::As_svg installed.\n";
  print "         SVG output (without dot) is not possible until you install it afterwards.\n\n";
  }
elsif ($ver <= 0.16)
  {
  print "\n************\n";
  print "Warning: Your Graph::Easy::As_svg version is outdated.\n";
  print "         Please upgrade it after installing this package.\n\n";
  }

WriteMakefile(
    NAME		=> 'wikimedia-graph',
    VERSION_FROM	=> 'graphcnv',
    PREREQ_PM		=> {
	'Graph::Easy' => 0.40,
	'Config::Tiny' => 2.02,
	'Digest::SHA1' => 2.10,
	},
    ABSTRACT		=> 'Integrate Graph::Easy into Wikimedia',
    AUTHOR		=> 'Tels <nospam-abuse@bloodgate.com>',
    PREREQ_FATAL	=> 1,  # can't work w/o proper prereqs
);
