#!/usr/bin/env perl

# bibliographics2db.pl - start a server, listen for connections, and given a file name, output a set of SQL statements

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January  13, 2019 - first cut
# February 24, 2019 - re-wrote as a server application; tricky!


# configure
use constant HOST     => 'localhost';
use constant PORT     => 7890;
use constant PROTOCOL => 'tcp';

# require
use IO::Socket::INET;
use strict;
use XML::XPath;

# initialize
my $socket = IO::Socket::INET->new( LocalHost => HOST, LocalPort => PORT, Proto => PROTOCOL, Listen => 1, Reuse => 1 ) or die "Can't create socket ($!)\n";

# listen, forever
while ( my $client = $socket->accept() ) {

	# configure
	binmode( $client, ':utf8' );
	
	# get input and parse
	my $file = <$client>;
	my ( $netid, $doi, $header, $rdf ) = split( "\t", &slurp( $file ) );

	# extract the "canonical" link
	my $canonical = '';
	my @links     = split( ', ', $header );
	foreach my $link ( @links ) {

		# parse the link
		my @items = split( '; ', $link );
	
		# get the uri
		my $uri =  $items[ 0 ];
		$uri    =~ s/<//;
		$uri    =~ s/>//;
		
		# look for the canonical uri
		my $found = 0;
		for ( my $i = 1; $i < scalar( @items ); $i++ ) {
	
			# parse
			my ( $name, $value ) = split( '=', $items[ $i ] );
		
			# normalize/clean
			$value =~ s/"//g;
		
			# look for specific name/value pair; can look for other cool uri's here
			if ( $name eq 'rel' and $value eq 'canonical' ) {
		
				# update and exit
				$canonical = $uri;
				$found     = 1;
				last;
			
			}
			
		}
	
		# don't do unnecessary work
		last if ( $found );
		
	}

	# extract the desired bibliographics
	if ( $rdf ) {

 		# re-initialize
 		my $rdf = XML::XPath->new( xml => $rdf ); 
		
		# parse; article title
		my $title_article =  $rdf->find( '/rdf:RDF/rdf:Description/j.0:title' )->string_value;
		$title_article    =~ s/'/''/g;

		# journal title
		my $title_journal =  $rdf->find( '/rdf:RDF/rdf:Description/j.0:isPartOf/j.2:Journal/j.0:title' )->string_value;
		$title_journal    =~ s/'/''/g;

		# date
		my $date =  $rdf->find( '/rdf:RDF/rdf:Description/j.0:date' )->string_value;
		$date    =~ s/'/''/g;

		# output, conditionally
		if ( $canonical )     { print $client "UPDATE bibliographics SET url='$canonical' WHERE netid='$netid' AND doi='$doi';\n\n" }
		if ( $title_article ) { print $client "UPDATE bibliographics SET title_article='$title_article' WHERE netid='$netid' AND doi='$doi';\n\n" }
		if ( $title_journal ) { print $client "UPDATE bibliographics SET title_journal='$title_journal' WHERE netid='$netid' AND doi='$doi';\n\n" }
		if ( $date )          { print $client "UPDATE bibliographics SET date='$date' WHERE netid='$netid' AND doi='$doi';\n\n" }
	   
	}
	
}



# read a file all at one go
sub slurp {

	my $f = shift;
	open ( F, $f ) or die "Can't open $f: $!\n";
	my $r = do { local $/; <F> };
	close F;
	return $r;

}