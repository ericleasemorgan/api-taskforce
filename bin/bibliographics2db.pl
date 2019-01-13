#!/usr/bin/env perl

# bibliographics2db.pl - given file name, output an SQL statement

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January 13, 2019 - fist cut


# require
use strict;

# get input
my $file = $ARGV[ 0 ];
if ( ! $file ) { die "Usage: $0 <tsv>\n" }

# initialize; parse the input
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
		
	# look the canonical uri
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

# conditionally, output an update statement and done
if ( $canonical ) { print "UPDATE bibliographics SET url='$canonical' WHERE netid='$netid' AND doi='$doi';\n" }
exit;

# read a file at one go
sub slurp {

	my $f = shift;
	open ( F, $f ) or die "Can't open $f: $!\n";
	my $r = do { local $/; <F> };
	close F;
	return $r;

}