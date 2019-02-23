# API Taskforce

This is a "suite" of scripts used to query bibliographic databases (indexes) and cache the results for various reporting purposes. 

As of right now, there are only four "movements" in the suite. The first one reads a specifically shaped tab-delimited text file and fills up a simple &amp; rudimentary but relational SQLite database. The second one is more sophisticated. Given a password, it opens up a session to Web of Science's backend, queries the index for names, closes the session, and populates the database with the set of found DOI's. The third movement resolves the DOI's, parses out bibliographics, and updates the database. The fourth, and as of now, final movement is a set of SQL queries used to query the resulting database.

## Instrumentation

This suite is written for a number of "instruments", including: Linux, Bash, Python, Perl, the SQLite dialect of SQL, and bits of XPath. It also requires a password to the Web of Science backend.

## Performance

To "play" the suite, the following "score" is provided, but like any performance, playing the suite requires practice!

### First Movement - "Prelude"
  * `./bin/clean.sh` - erase any work done previously
  * `./bin/db-create.sh` - generate an empty database
  * `./bin/db-initialize.sh` - fill the database with NetId's
  * `./bin/faculty2db.sh` - update the database with names, departments, colleges, etc.
 
### Second Movement - "The Search"
  * `./bin/wos-open.py <password>` - initialize a connection to Web of Science
  * `./bin/wos-search.sh <sid>` - find all citations for the faculty
  * `./bin/wos-close.py <sid>` - be polite; terminate the Web of Science connection
  * `./bin/doi2db.sh` - fill the database with the cited identifiers (DOI's)

### Third Movement - "Resolutions"
  * `./bin/resolve.sh` - acquire bibliographic data assoicated with each DOI
  * `./bin/bibliographics2db.sh` - update the database accordingly
  
### Fourth Movement - "The Reports"
  * `cat ./etc/reports.sql | sqlite3 ./etc/library.db` - generate a set of reports against the database, and a sample report is located at [etc/report.txt](./etc/report.txt)
  * `./bin/db2solr.sh` - after using `./etc/schema.xml` to configure &amp; start-up a Solr instance, index the bibliographics
  * `./bin/search.pl` - query the index

## To do
There are a number of things to do, listed in no priority order:
 
   * create a Web-based Solr interface
   * do author disambiguation
   * refine the indexing process
   * refine the list of faculty &amp; staff
   * refine the terminal-based Solr interface
   * save more-comprehensive bibliographic data
   * tweak the Second Movement so the SID is shared between processes
   * write "one script to rule the all"; make everything go with one command
   * other duties as assigned
  
## Epilogue

*"Writing a system of software can be as creative as writing a symphony."*

---
Eric Lease Morgan &lt;emorgan@nd.edu&gt;  
February 23, 2019

