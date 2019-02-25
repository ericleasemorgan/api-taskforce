#!/usr/bin/env bash

# bibliographics2db.sh - a client application for bibliographics2db.pl

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January  11, 2019 - first cut but need to escape the input
# February 24, 2019 - tweaked to take advantage of server implementation; three times faster!


# configure
DB='./etc/library.db'
RESULTS='./caches/bibliographics/*.tsv'
TRANSACTIONS='./sql/update-bibliographics.sql'
HOST='localhost'
PORT=7890
SERVER='./bin/bibliographics2db.pl'

# start the server and capture the process id
$SERVER &
PID=$!

# initialize sql
echo "BEGIN TRANSACTION;" > $TRANSACTIONS

# process each tsv file in the results directory
for FILE in $RESULTS; do
	
	echo $FILE >&2
	( echo "$FILE" | nc $HOST $PORT ) >> $TRANSACTIONS
	
done

# terminate the server
kill $PID

# close transaction
echo "END TRANSACTION;" >> $TRANSACTIONS

# do the work and done
cat $TRANSACTIONS | sqlite3 $DB
exit