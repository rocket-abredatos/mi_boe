#!/usr/bin/env perl

use BOEScraper;
use SendToSolr;
use Date::Manip;
use POSIX qw/strftime/;

if ($#ARGV != 2 ) {
  print "Usage: boes_since.pl <start day> <start month> <start year>\n";
  print "Downloads all the BOE's articles since the provided date until current date\n";
}
else
{
  my $startDay = $ARGV[0];
  my $startMonth = $ARGV[1];
  my $startYear = $ARGV[2];
  
  my $startDate = $startYear.'-'.$startMonth.'-'.$startDay;
  my $endDate = strftime('%Y-%m-%d', localtime);

  my @dates = ParseRecur('0:0:0:1:0:0:0', $startDate, $startDate, $endDate);

  for my $date (@dates) {
    my $year = UnixDate($date, '%Y');
    my $month = UnixDate($date, '%m');
    my $day = UnixDate($date, '%d');
    print 'Retrieving BOE for '.$day.'/'.$month.'/'.$year;
    my $documents = BOEScraper::getBOEOfTheDay($day, $month, $year);
    print "Got ".scalar(@{$documents})." documents\n";
    SendToSolr::storeDocuments($documents);
  }
}