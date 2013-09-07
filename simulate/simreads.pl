#!/usr/bin/env perl
use strict;
use warnings;

use Data::Dumper;
use Getopt::Long;
use YAML qw(LoadFile);

my $config = LoadFile($ARGV[0]);
my @tests = sort(keys(%$config));
foreach my $testlabel(@tests)
{
  mkdir($testlabel);
  my $testdata = $config->{ $testlabel };
  my @experiments = sort(keys(%$testdata));
  foreach my $explabel(@experiments)
  {
    mkdir("$testlabel/$explabel");
    process_experiment($testlabel, $explabel, $testdata->{$explabel});
  }
}

sub process_experiment
{
  my $testlabel = shift(@_);
  my $explabel  = shift(@_);
  my $expdata   = shift(@_);
  my $seed      = $expdata->{"seed"};

  my @samples = sort(keys(%{$expdata->{"samples"}}));
  foreach my $samplelabel(@samples)
  {
    my $readsets = $expdata->{"samples"}->{$samplelabel};
    my $rscounter = 0;
    foreach my $readset(@$readsets)
    {
      my $numreadpairs = $expdata->{"baseline"} * $readset->{"abundance"};
      my $infile = $readset->{"sequence"};
      my $command = "wgsim -1 100 -2 100 -d 270 -s 40 -N $numreadpairs";
      $command .= " -S $seed seqs/$infile";
      $command .= " $testlabel/$explabel/$samplelabel.readset$rscounter.1.fq";
      $command .= " $testlabel/$explabel/$samplelabel.readset$rscounter.2.fq";
      $command .= " > $testlabel/$explabel/log.$samplelabel.readset$rscounter 2>&1";
      system($command) == 0 or die("failed command: $command");
      $rscounter++;
    }
    system("cat $testlabel/$explabel/$samplelabel.readset*.1.fq > $testlabel/$explabel/$samplelabel.1.fq");
    system("cat $testlabel/$explabel/$samplelabel.readset*.2.fq > $testlabel/$explabel/$samplelabel.2.fq");
    system("rm $testlabel/$explabel/$samplelabel.readset*.*.fq");
  }
}
