#!/usr/bin/env bash

# wos-search.sh - a front-end to wos-search.py

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January 11, 2019 - first cut


# configure
DB='./etc/library.db'
SQL="SELECT netid, firstname, lastname FROM faculty;"
IFS='|'
WOSSEARCH='./bin/wos-search.py'
WOSRESULTS='./results'
WOSLOGS='./logs'

# sanity check
if [[ -z "$1" ]]; then
	echo "Usage: $0 <sid>" >&2
	exit
fi

# get input
SID=$1

# process each record from the sql query
echo $SQL | sqlite3 $DB | while read RECORD; do
   
	# parse
	FIELDS=($RECORD)
	NETID="${FIELDS[0]}"
	FIRSTNAME="${FIELDS[1]}"
	LASTNAME="${FIELDS[2]}"

	# re-configure
	OUTPUT="$WOSRESULTS/$NETID.tsv"
	LOG="$WOSLOGS/$NETID.log"
	
	# debug and do the work
	echo $SID $NETID "'$LASTNAME, $FIRSTNAME'" >&2
	$WOSSEARCH $SID $NETID "'$LASTNAME, $FIRSTNAME'" > $OUTPUT 2> $LOG

done

# finished
exit