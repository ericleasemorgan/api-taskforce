#!/usr/bin/env bash

# bibliographics2db.sh - an front-end to bibliographics2db.pl

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January 11, 2019 - first cut but need to escape the input


# configure
DB='./etc/library.db'
RESULTS='./caches/bibliographics/*.tsv'
TRANSACTIONS='./sql/update-bibliographics.sql'
BIBLIOGRAPHICS2DB='./bin/bibliographics2db.pl'

# initialize
echo "BEGIN TRANSACTION;" > $TRANSACTIONS

# process each tsv file in the results directory
for FILE in $RESULTS; do

	echo $FILE >&2
	$BIBLIOGRAPHICS2DB $FILE >> $TRANSACTIONS
	
done

# close transaction
echo "END TRANSACTION;" >> $TRANSACTIONS

# do the work and done
#cat $TRANSACTIONS | sqlite3 $DB
exit