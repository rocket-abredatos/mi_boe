#!/usr/bin/env perl

package SendToSolr;
use strict;
use Carp;
use Data::Dumper;
use Encode;
use DBI;
use URI;
use LWP::UserAgent;
use HTTP::Request::Common;
use HTTP::Lite;
use BOEScraper;
use Digest::MD5 qw(md5 md5_hex md5_base64);

my $solrURL = 'http://mcdemo01:8090/solr/update?';

sub storeDocuments {
  my $documents = shift @_;
  
  for my $document (@{$documents}) {
    my $xml = createDocument($document);
    sendToSolR($xml);
    sendToSolR('<commit></commit>');
  }
  print 'Done!';
}

sub sendToSolR {
	my $message = shift @_;
	my $response;
	my $userAgent = LWP::UserAgent->new( agent => 'perl post' );

	$response = $userAgent->request( POST $solrURL, Content_Type => 'text/xml', Content => $message );

	if ( defined $response && $response->is_success ) {
		print "Indexed!\n";
	}
	else {
		print "ERROR: " . $response->as_string . "\n";
	}
	return $response;
}

# Creates a valid XML ready to be used by Solr from a BOE document
sub createDocument {
	# Hash with each field content
	my $document = shift @_;
	my $message = "<add>\n<doc>\n";

	my @fields = keys( %{$document} );

	foreach my $field (@fields) {
		$message .= "<field name=\"" . $field . "\"><![CDATA[" . $document->{$field} . "]]></field>\n";
	}
	$message .= "</doc>\n</add>\n";
	return $message;
}

1;