# API Taskforce

This is a "suite" of scripts used to query bibliographic databases (indexes) and cache the results for various reporting purposes. 

As of right now, there is only four "movements" in this suite. The first one reads a specifically shaped tab-delimited text file and fills up a simple &amp; rudimentary SQLite database. The second one is more sophisticated. Given a password, it opens up a session to Web of Science's backend, queries the index for names found in the database, closes the session, and populates the database with the set of found DOI's. The third movement resolves the DOI's, parses out bibliographics, and updates the database. The fourth, and as of now, final movement is a set of SQL queries used to query the resulting database.

## Performance

To "play" the suite, the following commands are recommended, but as of right now, your milage may vary:

  * ./bin/clean.sh
  * ./bin/db-create.sh
  * ./bin/db-initialize.sh
  * ./bin/faculty2db.sh
  * ./bin/wos-open.py &lt;password&gt;
  * ./bin/wos-search.sh &lt;sid&gt;
  * ./bin/wos-close.py &lt;sid&gt;
  * ./bin/doi2db.sh
  * echo "select netid, doi from bibliographics where doi>'';" | sqlite3 ./etc/library.db | parallel ./bin/doi2bibliographics.sh {}
  * ./bin/bibliographics2db.sh
  
Once you get this far, you ought to be run some simple reports against the resulting database:

  * cat ./etc/reports.sql | sqlite3 ./etc/library.db | less
  
---
Eric Lease Morgan &lt;emorgan@nd.edu&gt;  
January 13, 2019

