#!/usr/bin/perl

# db2solr.pl - make content searchable

# Eric Lease Morgan <emorgan@nd.edu>
# February 23, 2019 - first cut; I've really only written a dozen programs


# configure
use constant DATABASE => './etc/library.db';
use constant DRIVER   => 'SQLite';
use constant SOLR     => 'http://localhost:8983/solr/citations';

# require
use DBI;
use strict;
use WebService::Solr;

# sanity check
my $bid  = $ARGV[ 0 ];
if ( ! $bid ) { die "Usage: $0 <bid>\n" }

# initialize
my $database = DATABASE;
my $driver   = DRIVER; 
my $dbh      = DBI->connect( "DBI:$driver:dbname=$database", '', '', { RaiseError => 1 } ) or die $DBI::errstr;

# find the given title
my $handle = $dbh->prepare( qq(SELECT b.*, f.department FROM bibliographics as b, faculty as f WHERE b.bid='$bid' AND ( f.netid is b.netid) ;) );
$handle->execute() or die $DBI::errstr;

# process each record
while ( my $results = $handle->fetchrow_hashref ) {

	# parse the data
	my $bid           = $$results{ 'bid' };
	my $author        = $$results{ 'netid' };
	my $date          = $$results{ 'date' };
	my $doi           = $$results{ 'doi' };
	my $title_article = $$results{ 'title_article' };
	my $title_journal = $$results{ 'title_journal' };
	my $department    = $$results{ 'department' };
	
	# debug; dump
	binmode( STDOUT, ':utf8' );
	warn "         bid: $bid\n";
	warn "      author: $author\n";
	warn "        date: $date\n";
	warn "         doi: $doi\n";
	warn "     article: $title_article\n";
	warn "     journal: $title_journal\n";
	warn "  department: $department\n";
	warn "\n";
		
	# initialize indexing
	my $solr                     = WebService::Solr->new( SOLR );
	my $solr_author              = WebService::Solr::Field->new( 'author'              => $author );
	my $solr_bid                 = WebService::Solr::Field->new( 'bid'                 => $bid );
	my $solr_date                = WebService::Solr::Field->new( 'date'                => $date );
	my $solr_department          = WebService::Solr::Field->new( 'department'          => $department );
	my $solr_doi                 = WebService::Solr::Field->new( 'doi'                 => $doi );
	my $solr_facet_author        = WebService::Solr::Field->new( 'facet_author'        => $author );
	my $solr_facet_department    = WebService::Solr::Field->new( 'facet_department'    => $department );
	my $solr_facet_title_journal = WebService::Solr::Field->new( 'facet_title_journal' => $title_journal );
	my $solr_title_article       = WebService::Solr::Field->new( 'title_article'       => $title_article );
	my $solr_title_journal       = WebService::Solr::Field->new( 'title_journal'       => $title_journal );

	# fill a solr document with simple fields
	my $doc = WebService::Solr::Document->new;
	$doc->add_fields( $solr_author, $solr_bid, $solr_date, $solr_doi, $solr_title_article, $solr_title_journal, $solr_facet_author, $solr_facet_title_journal, $solr_department, $solr_facet_department );

	# save/index
	$solr->add( $doc );

}

# done
exit;

