#!/usr/bin/env bash

# faculty2db.sh - given a pre-configured database and tsv file, update a database

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January 11, 2019 - first cut but need to escape the input
# January 12, 2019 - moved to update, but still need to escape input


# configure
DB='./etc/library.db'
IFS=$'\t'
TRANSACTIONS='./sql/update-faculty.sql'
TSV='./etc/faculty.tsv'

# initialize
echo "BEGIN TRANSACTION;" > $TRANSACTIONS

# process each line in the tsv file
while read RECORD; do
  
	# parse
	FIELDS=($RECORD)
	NETID="${FIELDS[0]}"
	FIRSTNAME="${FIELDS[3]}"
	LASTNAME="${FIELDS[4]}"
	DEPARTMENT="${FIELDS[5]}"
	COLLEGE="${FIELDS[6]}"
	
	# escape
	COLLEGE=$( echo $COLLEGE | sed "s/'/''/g" )
	DEPARTMENT=$( echo $DEPARTMENT | sed "s/'/''/g" )
	FIRSTNAME=$( echo $FIRSTNAME | sed "s/'/''/g" )
	LASTNAME=$( echo $LASTNAME | sed "s/'/''/g" )
	
	# re-initialize, debug, and update
	SQL="UPDATE faculty SET firstname='$FIRSTNAME', lastname='$LASTNAME', college='$COLLEGE', department='$DEPARTMENT' WHERE netid='$NETID';"
	echo $SQL >&2
	echo $SQL >> $TRANSACTIONS
	
done < $TSV

# close transaction
echo "END TRANSACTION;" >> $TRANSACTIONS

# do the work and done
cat $TRANSACTIONS | sqlite3 $DB
exit