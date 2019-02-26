#!/usr/bin/perl

# search.cgi - CGI interface to search a solr instance

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# February 26, 2019 - first cut


# configure
use constant ROWS       => 199;
use constant SOLR       => 'http://localhost:8983/solr/citations';
use constant FACETFIELD => ( 'facet_author', 'facet_title_journal', 'facet_department' );
use constant RESOLVER   => 'http://dx.doi.org';

# require
use CGI;
use CGI::Carp qw( fatalsToBrowser );
use HTML::Entities;
use strict;
use WebService::Solr;
use URI::Encode qw( uri_encode uri_decode );

# initialize
my $cgi      = CGI->new;
my $query    = $cgi->param( 'query' );
my $html     = &template;
my $solr     = WebService::Solr->new( SOLR );

# sanitize query
my $sanitized = HTML::Entities::encode( $query );

# display the home page
if ( ! $query ) {

	$html =~ s/##QUERY##//;
	$html =~ s/##RESULTS##//;

}

# search
else {
	
	# build the search options
	my %search_options                   = ();
	$search_options{ 'facet.field' }     = [ FACETFIELD ];
	$search_options{ 'facet' }           = 'true';
	$search_options{ 'rows' }            = ROWS;

	# search
	my $response = $solr->search( $query, \%search_options );

	# build a list of author facets
	my @facet_author = ();
	my $author_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_author } );
	foreach my $facet ( sort { $$author_facets{ $b } <=> $$author_facets{ $a } } keys %$author_facets ) {
	
		my $encoded = uri_encode( $facet );
		my $link = qq(<a href='./index.cgi?query=$sanitized AND author:"$encoded"'>$facet</a>);
		push @facet_author, $link . ' (' . $$author_facets{ $facet } . ')';
		
	}

	# build a list of journal facets
	my @facet_journal = ();
	my $journal_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_title_journal } );
	foreach my $facet ( sort { $$journal_facets{ $b } <=> $$journal_facets{ $a } } keys %$journal_facets ) {
	
		my $encoded = uri_encode( $facet );
		my $link = qq(<a href='./index.cgi?query=$sanitized AND title_journal:"$encoded"'>$facet</a>);
		push @facet_journal, $link . ' (' . $$journal_facets{ $facet } . ')';
		
	}

	# build a list of department facets
	my @facet_department = ();
	my $department_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_department } );
	foreach my $facet ( sort { $$department_facets{ $b } <=> $$department_facets{ $a } } keys %$department_facets ) {
	
		my $encoded = uri_encode( $facet );
		my $link = qq(<a href='./index.cgi?query=$sanitized AND department:"$encoded"'>$facet</a>);
		push @facet_department, $link . ' (' . $$department_facets{ $facet } . ')';
		
	}

	# get the total number of hits
	my $total = $response->content->{ 'response' }->{ 'numFound' };

	# get number of hits
	my @hits = $response->docs;

	# loop through each item
	my $items = '';
	for my $doc ( $response->docs ) {
	
		# parse
		my $author        = $doc->value_for( 'author' );
		my $doi           = $doc->value_for( 'doi' );
		my $title_article = $doc->value_for( 'title_article' );
		my $title_journal = $doc->value_for( 'title_journal' );
		my $department    = $doc->value_for( 'department' );
											
		# build a url to the article
		my $url = RESOLVER . "/$doi";
		
		# create a item
		my $item =  qq(<li class='item'>##AUTHORS## (##DEPARTMENT##) wrote "##TITLE##" in <cite>##JOURNAL##</cite> (<a href="##URL##">##DOI##</a>));
		$item    =~ s/##JOURNAL##/$title_journal/g;
		$item    =~ s/##DEPARTMENT##/$department/g;
		$item    =~ s/##URL##/$url/g;
		$item    =~ s/##DOI##/$doi/g;
		$item    =~ s/##TITLE##/$title_article/g;
		$item    =~ s/##AUTHORS##/$author/eg;

		# update the list of items
		$items .= $item;
					
	}	

	# build the html
	$html =  &results_template;
	$html =~ s/##RESULTS##/&results/e;
	$html =~ s/##QUERY##/$sanitized/e;
	$html =~ s/##TOTAL##/$total/e;
	$html =~ s/##HITS##/scalar( @hits )/e;
	$html =~ s/##FACETSAUTHOR##/join( '; ', @facet_author )/e;
	$html =~ s/##FACETSJOURNAL##/join( '; ', @facet_journal )/e;
	$html =~ s/##FACETSDEPARTMENT##/join( '; ', @facet_department )/e;
	$html =~ s/##ITEMS##/$items/e;

}

# done
print $cgi->header( -type => 'text/html', -charset => 'utf-8');
print $html;
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


# search results template
sub results {

	return <<EOF
	<p>Your search found ##TOTAL## item(s) and ##HITS## item(s) are displayed.</p>
		
	<h3>Items</h3><ol>##ITEMS##</ol>
EOF

}


# root template
sub template {

	return <<EOF
<html>
<head>
	<title>Project Citations</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="./etc/style.css">
	<style>
		.item { margin-bottom: 1em }
	</style>
</head>
<body>
<div class="header">
	<h1>Project Citations - Search</h1>
</div>

<div class="col-3 col-m-3 menu">
  <ul>
    <li><a href="./index.cgi">Home</a></li>
 </ul>
</div>

<div class="col-9 col-m-9">

	<p>Given a query, this page will return a relevancy ranked list of results.</p>
	<p>
	<form method='GET' action='./index.cgi'>
	Query: <input type='text' name='query' value='##QUERY##' size='50' autofocus="autofocus"/>
	<input type='submit' value='Search' />
	</form>

<p>Don't know what to search for? Try any one of these department queries:</p>
<p>
 * <a href='./index.cgi?query=department:"Accountancy"'>Accountancy</a>
 * <a href='./index.cgi?query=department:"Aerospace and Mechanical Engr"'>Aerospace and Mechanical Engr</a>
 * <a href='./index.cgi?query=department:"American Studies"'>American Studies</a>
 * <a href='./index.cgi?query=department:"Anthropology"'>Anthropology</a>
 * <a href='./index.cgi?query=department:"Art, Art History, and Design"'>Art, Art History, and Design</a>
 * <a href='./index.cgi?query=department:"Biological Sciences"'>Biological Sciences</a>
 * <a href='./index.cgi?query=department:"Center for Low Energy Systems Tech"'>Center for Low Energy Systems Tech</a>
 * <a href='./index.cgi?query=department:"Center for Research Computing"'>Center for Research Computing</a>
 * <a href='./index.cgi?query=department:"Chemical and Biomolecular Engr"'>Chemical and Biomolecular Engr</a>
 * <a href='./index.cgi?query=department:"Chemistry and Biochemistry"'>Chemistry and Biochemistry</a>
 * <a href='./index.cgi?query=department:"Classics"'>Classics</a>
 * <a href='./index.cgi?query=department:"Clinical Law Center"'>Clinical Law Center</a>
 * <a href='./index.cgi?query=department:"Computer Science and Engineering"'>Computer Science and Engineering</a>
 * <a href='./index.cgi?query=department:"Department of Economics"'>Department of Economics</a>
 * <a href='./index.cgi?query=department:"ESTEEM Graduate Program"'>ESTEEM Graduate Program</a>
 * <a href='./index.cgi?query=department:"East Asian Languages and Cultures"'>East Asian Languages and Cultures</a>
 * <a href='./index.cgi?query=department:"Eck Institute for Global Health"'>Eck Institute for Global Health</a>
 * <a href='./index.cgi?query=department:"Economics and Policy Studies"'>Economics and Policy Studies</a>
 * <a href='./index.cgi?query=department:"Electrical Engineering"'>Electrical Engineering</a>
 * <a href='./index.cgi?query=department:"English"'>English</a>
 * <a href='./index.cgi?query=department:"Finance"'>Finance</a>
 * <a href='./index.cgi?query=department:"Global Health Masters"'>Global Health Masters</a>
 * <a href='./index.cgi?query=department:"Harper Cancer Research Institute"'>Harper Cancer Research Institute</a>
 * <a href='./index.cgi?query=department:"Hesburgh Libraries"'>Hesburgh Libraries</a>
 * <a href='./index.cgi?query=department:"History"'>History</a>
 * <a href='./index.cgi?query=department:"IT Analytics and Operations"'>IT Analytics and Operations</a>
 * <a href='./index.cgi?query=department:"Inst for Educational Initiatives"'>Inst for Educational Initiatives</a>
 * <a href='./index.cgi?query=department:"Kaneb Ctr for Teaching and Learning"'>Kaneb Ctr for Teaching and Learning</a>
 * <a href='./index.cgi?query=department:"Keough School of Global Affairs"'>Keough School of Global Affairs</a>
 * <a href='./index.cgi?query=department:"Marketing"'>Marketing</a>
 * <a href='./index.cgi?query=department:"Mathematics"'>Mathematics</a>
 * <a href='./index.cgi?query=department:"ND Environmental Change Initiative"'>ND Environmental Change Initiative</a>
 * <a href='./index.cgi?query=department:"ND Integrated Imaging Facility"'>ND Integrated Imaging Facility</a>
 * <a href='./index.cgi?query=department:"ND NANO"'>ND NANO</a>
 * <a href='./index.cgi?query=department:"Notre Dame Research"'>Notre Dame Research</a>
 * <a href='./index.cgi?query=department:"Philosophy"'>Philosophy</a>
 * <a href='./index.cgi?query=department:"Physics"'>Physics</a>
 * <a href='./index.cgi?query=department:"Political Science"'>Political Science</a>
 * <a href='./index.cgi?query=department:"Preprofessional Studies"'>Preprofessional Studies</a>
 * <a href='./index.cgi?query=department:"Program of Liberal Studies"'>Program of Liberal Studies</a>
 * <a href='./index.cgi?query=department:"Provost Office"'>Provost Office</a>
 * <a href='./index.cgi?query=department:"Psychology"'>Psychology</a>
 * <a href='./index.cgi?query=department:"Radiation Laboratory"'>Radiation Laboratory</a>
 * <a href='./index.cgi?query=department:"Sociology"'>Sociology</a>
 * <a href='./index.cgi?query=department:"Turbomachinery Facility"'>Turbomachinery Facility</a>
 * <a href='./index.cgi?query=department:"UNDERC"'>UNDERC</a>
 * <a href='./index.cgi?query=department:"WM Keck Ctr for Transgene Research"'>WM Keck Ctr for Transgene Research</a>

</p>
 
	##RESULTS##

	<div class="footer">
		<p style='text-align: right'>
		Eric Lease Morgan &amp; Team API Taskforce<br />
		February 26, 2019
		</p>
	</div>

</div>

</body>
</html>
EOF

}


# results template
sub results_template {

	return <<EOF
<html>
<head>
	<title>Project Citations</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="./etc/style.css">
	<style>
		.item { margin-bottom: 1em }
	</style>
</head>
<body>
<div class="header">
	<h1>Project Citations - Search results</h1>
</div>

<div class="col-3 col-m-3 menu">
	<ul>
    <li><a href="./index.cgi">Home</a></li>
	</ul>
</div>

	<div class="col-6 col-m-6">
		<p>
		<form method='GET' action='./index.cgi'>
		Query: <input type='text' name='query' value='##QUERY##' size='50' autofocus="autofocus"/>
		<input type='submit' value='Search' />
		</form>
		
		
		##RESULTS##
		
	</div>
	
	<div class="col-3 col-m-3">
	<h3>Departments</h3><p>##FACETSDEPARTMENT##</p>
	<h3>Authors</h3><p>##FACETSAUTHOR##</p>
	<h3>Journals</h3><p>##FACETSJOURNAL##</p>
	</div>

</body>
</html>
EOF

}

