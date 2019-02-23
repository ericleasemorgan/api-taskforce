#!/usr/bin/env bash

# db2solr.sh - given a file name, run db2solr.pl

# Eric Lease Morgan <eric_morgan@infomotions.com>
# February 23, 2019 - first cut


SQL="select b.bid from bibliographics as b, faculty as f where ( f.department is 'Biological Sciences' OR f.department is 'Physics' OR f.department is 'Chemistry and Biochemistry' ) AND b.doi > '' AND f.netid is b.netid ORDER by f.netid;"
DATABASE='./etc/library.db'
DB2SOLR='./bin/db2solr.pl'

echo $SQL | sqlite3 $DATABASE | while read BID; do

	echo "$BID" >&2
	$DB2SOLR $BID
	
done

