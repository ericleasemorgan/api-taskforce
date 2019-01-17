#!/usr/bin/env bash

# resolve.sh - a front-end to doi2bibliographics.sh

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January 13, 2019 - first cut


# configure
SQL="SELECT netid, doi FROM bibliographics WHERE doi > '';"
DB='./etc/library.db'
DOI2BIBLIOGRAPHICS='./bin/doi2bibliographics.sh'

# do the work and done
echo $SQL | sqlite3 $DB | parallel $DOI2BIBLIOGRAPHICS {}
exit
