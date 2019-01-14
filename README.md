# API Taskforce

This is a "suite" of scripts used to query bibliographic databases (indexes) and cache the results for various reporting purposes. 

As of right now, there are only four "movements" in the suite. The first one reads a specifically shaped tab-delimited text file and fills up a simple &amp; rudimentary but relational SQLite database. The second one is more sophisticated. Given a password, it opens up a session to Web of Science's backend, queries the index for names, closes the session, and populates the database with the set of found DOI's. The third movement resolves the DOI's, parses out bibliographics, and updates the database. The fourth, and as of now, final movement is a set of SQL queries used to query the resulting database.

## Performance

To "play" the suite, the following "score" is provided, but your milage will probably vary.

### First movemenet - "Initialization"
  * ./bin/clean.sh
  * ./bin/db-create.sh
  * ./bin/db-initialize.sh
  * ./bin/faculty2db.sh
 
### Second movement - "The Search"
  * ./bin/wos-open.py &lt;password&gt;
  * ./bin/wos-search.sh &lt;sid&gt;
  * ./bin/wos-close.py &lt;sid&gt;
  * ./bin/doi2db.sh

### Third movement - "Resolutions"
  * echo "select netid, doi from bibliographics where doi>'';" | sqlite3 ./etc/library.db | parallel ./bin/doi2bibliographics.sh {}
  * ./bin/bibliographics2db.sh
  
### Fourth movement - "Summarization"
  * cat ./etc/reports.sql | sqlite3 ./etc/library.db | less
  
---
Eric Lease Morgan &lt;emorgan@nd.edu&gt;  
January 13, 2019

