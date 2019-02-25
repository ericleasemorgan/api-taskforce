#!/usr/bin/env perl

# doi2bibliographics.pl - given a netid and a doi, resolve the doi and output bibliographics

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January  12, 2019 - first cut
# February 24, 2019 - added some error checking; this script could be "server-ized" and thus sped up


# configure
use constant RESOLVER => 'http://dx.doi.org';
use constant MIMETYPE => 'application/rdf+xml';

# require
use strict;
use LWP;

my $netid = $ARGV[ 0 ];
my $doi   = $ARGV[ 1 ];
if ( ! $netid or ! $doi ) { die "Usage: $0 <netid> <doi>\n" }

# initialize
my $useragent = LWP::UserAgent->new;
my $request   = HTTP::Request->new( GET => RESOLVER . "/$doi" );
$request->header( Accept => MIMETYPE );

# request the data
my $response = $useragent->request( $request );

# if success, parse the result
if ( $response->is_success ) {

	# get the link header; easy
	my $link = $response->headers->header( 'Link' );
	
	# get the content and unwrap it
	my $content =  $response->content;
	$content    =~ s/ +/ /g;
	$content    =~ s/\n+//g;
	$content    =~ s/> </></g;
	
	# output, conditionally
	if ( $content ) { print join( "\t", ( $netid, $doi, $link, $content ) ) . "\n" }
	else { warn "Content error: No RDF found in $doi\n" }
	
}

# HTTP error
else { warn "HTTP error for $doi: " . $response->content }

# done
exit;
