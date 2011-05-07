#!/usr/bin/env perl

use BOEScraper;
use SendToSolr;
use POSIX qw/strftime/;

sub storeDocuments {
  my $documents = shift @_;
  
  for my $document (@{$documents}) {
    my $xml = SendToSolr::createDocument($document);
    SendToSolr::sendToSolR($xml);
    SendToSolr::sendToSolR('<commit></commit>');
  }
  print 'Done!';
}

if ($#ARGV != 2 ) {
  my $year = strftime('%Y',localtime);
  my $month = strftime('%m',localtime);
  my $day = strftime('%d',localtime);
  my $documents = BOEScraper::getBOEOfTheDay($day, $month, $year);
  print "Got ".scalar(@{$documents})." documents\n";
  storeDocuments($documents);
}
else {
  my $documents = BOEScraper::getBOEOfTheDay($ARGV[0], $ARGV[1], $ARGV[2]);
  print "Got ".scalar(@{$documents})." documents\n";
  storeDocuments($documents);
}