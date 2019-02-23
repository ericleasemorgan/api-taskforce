#!/usr/bin/env perl

# search.pl - command-line interface to search a solr instance

# Eric Lease Morgan <emorgan@nd.edu>
# February 23, 2019 - first cut; based on other work


# configure
use constant ROWS       => 3;
use constant SOLR       => 'http://localhost:8983/solr/citations';
use constant FACETFIELD => ( 'facet_author', 'facet_title_journal', 'facet_department' );

# require
use strict;
use WebService::Solr;

# get input; sanity check
my $query  = $ARGV[ 0 ];
if ( ! $query ) { die "Usage: $0 <query>\n" }

# initialize
my $solr =  WebService::Solr->new( SOLR );
my $rows = ROWS;

# build the search options
my %search_options = ();
$search_options{ 'rows' }        = $rows;
$search_options{ 'facet.field' } = [ FACETFIELD ];
$search_options{ 'facet' }       = 'true';

# search
my $response = $solr->search( $query, \%search_options );

# build a list of author facets
my @facet_author = ();
my $author_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_author } );
foreach my $facet ( sort { $$author_facets{ $b } <=> $$author_facets{ $a } } keys %$author_facets ) { push @facet_author, $facet . ' (' . $$author_facets{ $facet } . ')'; }

# build a list of journal title facets
my @facet_title_journal = ();
my $title_journal_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_title_journal } );
foreach my $facet ( sort { $$title_journal_facets{ $b } <=> $$title_journal_facets{ $a } } keys %$title_journal_facets ) { push @facet_title_journal, $facet . ' (' . $$title_journal_facets{ $facet } . ')'; }

# build a list of department facets
my @facet_department = ();
my $department_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_department } );
foreach my $facet ( sort { $$department_facets{ $b } <=> $$department_facets{ $a } } keys %$department_facets ) { push @facet_department, $facet . ' (' . $$department_facets{ $facet } . ')'; }


# get the total number of hits
my $total = $response->content->{ 'response' }->{ 'numFound' };

# get number of hits returned
my @hits = $response->docs;

print "Your search found $total item(s) and " . scalar( @hits ) . " items(s) are displayed.\n\n";
print '      authors: ', join( '; ', @facet_author ), "\n\n";
print '     journals: ', join( '; ', @facet_title_journal ), "\n\n";
print '  departments: ', join( '; ', @facet_department ), "\n\n";

# loop through each document
for my $doc ( $response->docs ) {

	# parse
	my $bid           = $doc->value_for(  'bid' );
	my $author        = $doc->value_for(  'author' );
	my $date          = $doc->value_for(  'date' );
	my $doi           = $doc->value_for(  'doi' );
	my $title_article = $doc->value_for(  'title_article' );
	my $title_journal = $doc->value_for(  'title_journal' );
	my $department    = $doc->value_for(  'department' );

	print "   author: $author ($department)\n";
	print "    title: $title_article\n";
	print "  journal: $title_journal\n";
	print "     date: $date\n";
	print "      doi: $doi\n";
	print "      bid: $bid\n";
	print "\n";

}

# done
exit;


# convert an array reference into a hash
sub get_facets {

	my $array_ref = shift;
	
	my %facets;
	my $i = 0;
	foreach ( @$array_ref ) {
	
		my $k = $array_ref->[ $i ]; $i++;
		my $v = $array_ref->[ $i ]; $i++;
		next if ( ! $v );
		$facets{ $k } = $v;
	 
	}
	
	return \%facets;
	
}

