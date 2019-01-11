#!/usr/bin/env bash

# doi2db.sh - fill the database with doi's

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January 11, 2019 - first cut but need to escape the input


# configure
DB='./etc/library.db'
IFS=$'\t'
RESULTS='./results/*.tsv'

# process each tsv file in the results directory
for FILE in $RESULTS; do

	while read RECORD; do
	
		# parse
		FIELDS=($RECORD)
		NETID="${FIELDS[0]}"
		WOSID="${FIELDS[1]}"
		DOI="${FIELDS[2]}"
		
		# build the sql, debug, and to the work
		SQL="INSERT INTO dois ( 'netid', 'wosid', 'doi' ) VALUES ( '$NETID', '$WOSID', '$DOI' );"
		printf "$SQL\n" >&2
		echo $SQL | sqlite3 $DB
		
	done < $FILE
	
done

# finished
exit
