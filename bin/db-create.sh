#!/usr/bin/env bash

# db-create.sh - given pre-configured schema and database name, create a database

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January 11, 2019 - first cut


# configure
DB='./etc/library.db'
SCHEMA='./etc/schema.sql'

# delete the database; dangerous
rm -rf $DB

# do the work and done
cat ./etc/schema.sql | sqlite3 ./etc/library.db
exit