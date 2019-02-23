#!/usr/bin/env bash

# db2solr.sh - given a file name, run db2solr.pl

# Eric Lease Morgan <eric_morgan@infomotions.com>
# February 23, 2019 - first cut


SQL="SELECT b.bid FROM bibliographics AS b, faculty AS f WHERE b.doi > '' AND f.netid IS b.netid ORDER BY f.netid;"
DATABASE='./etc/library.db'
DB2SOLR='./bin/db2solr.pl'

echo $SQL | sqlite3 $DATABASE | while read BID; do

	echo "$BID" >&2
	$DB2SOLR $BID
	
done

