#!/usr/bin/env perl

use BOEScraper;
use SendToSolr;
use POSIX qw/strftime/;

if ($#ARGV != 2 ) {
  my $year = strftime('%Y',localtime);
  my $month = strftime('%m',localtime);
  my $day = strftime('%d',localtime);
  my $documents = BOEScraper::getBOEOfTheDay($day, $month, $year);
  print "Got ".scalar(@{$documents})." documents\n";
  SendToSolr::storeDocuments($documents);
}
else {
  my $documents = BOEScraper::getBOEOfTheDay($ARGV[0], $ARGV[1], $ARGV[2]);
  print "Got ".scalar(@{$documents})." documents\n";
  SendToSolr::storeDocuments($documents);
}