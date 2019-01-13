#!/usr/bin/env bash

# doi2db.sh - fill the database with doi's

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January 11, 2019 - first cut but need to escape the input


# configure
DB='./etc/library.db'
IFS=$'\t'
RESULTS='./results/*.tsv'
TRANSACTIONS='./sql/initialize-bibliographics.sql'

# initialize
echo "BEGIN TRANSACTION;" > $TRANSACTIONS

# process each tsv file in the results directory
for FILE in $RESULTS; do

	# process each line (record) in the given file
	while read RECORD; do
	
		# parse
		FIELDS=($RECORD)
		NETID="${FIELDS[0]}"
		WOSID="${FIELDS[1]}"
		DOI="${FIELDS[2]}"
		
		# check for doi and re-initialize sql
		if [[ $DOI > '' ]]; then
			SQL="INSERT INTO bibliographics ( 'netid', 'wosid', 'doi' ) VALUES ( '$NETID', '$WOSID', '$DOI' );"
		else
			SQL="INSERT INTO bibliographics ( 'netid', 'wosid' ) VALUES ( '$NETID', '$WOSID' );"
		fi
		
		# debug and update
		echo $SQL >&2
		echo $SQL >> $TRANSACTIONS
		
	done < $FILE
	
done

# close transaction
echo "END TRANSACTION;" >> $TRANSACTIONS

# do the work and done
cat $TRANSACTIONS | sqlite3 $DB
exit