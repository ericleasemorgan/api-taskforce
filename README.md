# API Taskforce

This is a "suite" of scripts used to query bibliographic databases (indexes) and cache the results for various reporting purposes. 

As of right now, there are only four "movements" in the suite. The first one reads a specifically shaped tab-delimited text file and fills up a simple &amp; rudimentary but relational SQLite database. The second one is more sophisticated. Given a password, it opens up a session to Web of Science's backend, queries the index for names, closes the session, and populates the database with the set of found DOI's. The third movement resolves the DOI's, parses out bibliographics, and updates the database. The fourth, and as of now, final movement is a set of SQL queries used to query the resulting database.

## Performance

To "play" the suite, the following "score" is provided, but your milage will probably vary.

### First movemenet - "Initialization"
  * ./bin/clean.sh - erase any work done previously
  * ./bin/db-create.sh - generate an empty database
  * ./bin/db-initialize.sh - fill the database with NetId's
  * ./bin/faculty2db.sh - update the database with names, departments, colleges, etc.
 
### Second movement - "The Search"
  * ./bin/wos-open.py &lt;password&gt; - initialize a connection to Web of Science
  * ./bin/wos-search.sh &lt;sid&gt; - find all citations for the faculty
  * ./bin/wos-close.py &lt;sid&gt; - be polite; terminate the Web of Science connection
  * ./bin/doi2db.sh - fill the database with the cited identifiers (DOI's)

### Third movement - "Resolutions"
  * echo "select netid, doi from bibliographics where doi>'';" | sqlite3 ./etc/library.db | parallel ./bin/doi2bibliographics.sh {} - acquire as bibliogrpahic data assoicated with each DOI
  * ./bin/bibliographics2db.sh - update the database accordingly
  
### Fourth movement - "Summarization"
  * cat ./etc/reports.sql | sqlite3 ./etc/library.db - generate a set of reports against the database
 
 ## To do
 There are a number of things to do, listed in no priority order:
 
   * create a more accurate &amp; comprehensive list of faculty
   * 
  
---
Eric Lease Morgan &lt;emorgan@nd.edu&gt;  
January 13, 2019

