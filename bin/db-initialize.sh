#!/usr/bin/env bash

# db-initialize.sh - create an SQLite database

# Eric Lease Morgan <emorgan@nd.edu>
# January 11, 2019 - first cut


# configure
DB='./etc/library.db'
SCHEMA='./etc/schema.sql'

# delete the database; dangerous
rm -rf $DB

# do the work and done
cat ./etc/schema.sql | sqlite3 ./etc/library.db
exit