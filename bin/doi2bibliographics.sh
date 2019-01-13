#!/usr/bin/env bash

# doi2bibliographics.sh - a front-end to doi2bibliographics.pl
# usage: echo "select netid, doi from dois;" | sqlite3 ./etc/library.db | parallel ./bin/doi2bibliographics.sh {}

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January 11, 2019 - first cut


# configure
IFS='|'
DOI2BIBLIOGRAPHICS='./bin/doi2bibliographics.pl'
BIBLIOGRAPHICS='./caches/bibliographics'

# sanity check
if [[ -z "$1" ]]; then
	echo "Usage: $0 <'netid|doi'>" >&2
	exit
fi

# parse
FIELDS=($1)
NETID="${FIELDS[0]}"
DOI="${FIELDS[1]}"

# re-initialize
FILE="$NETID-$DOI"	

# configure
FILE=$( echo $FILE | tr -d ' ' | tr '.' '-' | tr '/' '_' | tr '+' '_' )
OUTPUT="$BIBLIOGRAPHICS/$FILE.tsv"

# debug and do the work, conditionally
printf "$NETID\t$DOI\t$OUTPUT\n" >&2
if [[ ! -f $OUTPUT ]]; then
	$DOI2BIBLIOGRAPHICS $NETID $DOI > $OUTPUT
fi

# finished
exit
