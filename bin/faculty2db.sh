#!/usr/bin/env bash

# faculty2db.sh - given a file of faculty names, etc, fill a database

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January 11, 2019 - first cut but need to escape the input


# configure
DB='./etc/library.db'
TSV='./etc/faculty.tsv'
IFS=$'\t'

# process each line in the database
while read RECORD; do
  
	# parse
	FIELDS=($RECORD)
	NETID="${FIELDS[0]}"
	FIRSTNAME="${FIELDS[3]}"
	LASTNAME="${FIELDS[4]}"
		
	# re-initailize
	SQL="INSERT INTO faculty ( 'netid', 'firstname', 'lastname' ) VALUES ( '$NETID', '$FIRSTNAME', '$LASTNAME' );"
	
	# debug and do the work
	printf "$SQL\n" >&2
	echo $SQL | sqlite3 $DB
	
done < $TSV
