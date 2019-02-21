#!/usr/bin/env bash

# db-initialize.sh - given a specifically shaped tsv file, create skeleton records in a database

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January 12, 2019 - first cut


# configure
DB='./etc/library.db'
TSV='./etc/patron_data.psv'
TRANSACTIONS='./sql/initialize-faculty.sql'
IFS='|'

# initialize
echo "BEGIN TRANSACTION;" > $TRANSACTIONS

# Process each record in the tsv file
while read RECORD; do

	# parse
	FIELDS=($RECORD)
	NETID="${FIELDS[8]}"
		
	# re-initialize, debug, and update
	SQL="INSERT INTO faculty ( 'netid' ) VALUES ( '$NETID' );"
	echo $SQL >&2
	echo $SQL >> $TRANSACTIONS
	
done < $TSV

# close transaction
echo "END TRANSACTION;" >> $TRANSACTIONS

# do the work and done
cat $TRANSACTIONS | sqlite3 $DB
exit