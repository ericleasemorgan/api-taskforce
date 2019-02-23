#!/usr/bin/env bash

# faculty2db.sh - given a pre-configured database and tsv file, update a database

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January  11, 2019 - first cut but need to escape the input
# January  12, 2019 - moved to update, but still need to escape input
# February 23, 2019 - skipped over empty netid's


# configure
DB='./etc/library.db'
IFS=$'|'
TRANSACTIONS='./sql/update-faculty.sql'
TSV='./etc/patron_data.psv'

# initialize
echo "BEGIN TRANSACTION;" > $TRANSACTIONS

# process each line in the tsv file
while read RECORD; do
  
	# parse
	FIELDS=($RECORD)
	NDID="${FIELDS[0]}"
	TYPE="${FIELDS[1]}"
	NAME_PREFIX="${FIELDS[2]}"
	FIRST_NAME="${FIELDS[3]}"
	MIDDLE_NAME="${FIELDS[4]}"
	LAST_NAME="${FIELDS[5]}"
	NAME_SUFFIX="${FIELDS[6]}"
	DEPARTMENT="${FIELDS[7]}"
	NETID="${FIELDS[8]}"
	EMAIL="${FIELDS[9]}"
	
	# do not process null identifiers
	if [[ -z $NETID ]]; then continue; fi

	# escape
	DEPARTMENT=$( echo $DEPARTMENT | sed "s/'/''/g" )
	FIRST_NAME=$( echo $FIRST_NAME | sed "s/'/''/g" )
	LAST_NAME=$( echo $LAST_NAME | sed "s/'/''/g" )
	TYPE=$( echo $TYPE | sed "s/'/''/g" )
	
	# re-initialize, debug, and update
	SQL="UPDATE faculty SET firstname='$FIRST_NAME', lastname='$LAST_NAME', department='$DEPARTMENT', type='$TYPE' WHERE netid='$NETID';"
	echo $SQL >&2
	echo $SQL >> $TRANSACTIONS
	
done < $TSV

# close transaction
echo "END TRANSACTION;" >> $TRANSACTIONS

# do the work and done
cat $TRANSACTIONS | sqlite3 $DB
exit