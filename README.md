# API Taskforce

This is a suite of scripts used to query bibliographic databases (indexes) and cache the results for a repository. 

As of right now, there is only two "movements" in this suite. The first one reads a specifically shaped tab-delimited text file and fills up a simple &amp; rudimentary SQLite database. The second one is more sophisticated. Given a password, it opens up a session to Web of Science's backend, queries the index for names found in the database, closes the session, and populates the database with the results.

'More later.

---
Eric Lease Morgan &lt;emorgan@nd.edu&gt;  
January 11, 2019

