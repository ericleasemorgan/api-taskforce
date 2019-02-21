#!/usr/bin/env bash

# clean.sh - delete the database, logs, and all caches; dangerous!

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# January 13, 2019 - first cut; brain-dead


# do the work
rm -rf ./caches/bibliographics
rm -rf ./caches/results
mkdir  ./caches/bibliographics
mkdir  ./caches/results
rm -rf ./etc/library.db
rm -rf ./logs/*.log
rm -rf ./sql/*.sql

# done
exit
