-- cool-queries.sql - a set of "reports"
-- usage: cat ./etc/reports.sql | sqlite3 ./etc/library.db

-- Eric Lease Morgan <emorgan@nd.edu>
-- (c) University of Notre Dame; distributed under a GNU Public License

-- January 13, 2019 - first cut


-- get the number of people in the database
SELECT COUNT( netid ) FROM faculty;

-- list all netid's
SELECT netid FROM faculty ORDER BY netid ASC;

-- create a list of faculty; a simple directory
SELECT lastname || ', ' || firstname || ' (' || netid || ')' FROM faculty ORDER BY lastname;

-- count & tabulate the number of faculty in each college
SELECT COUNT( college ) AS c, college FROM faculty GROUP BY college ORDER BY c DESC;

-- count & tabulate the number of faculty in each department
SELECT COUNT( department ) AS c, department FROM faculty GROUP BY department ORDER BY c DESC;

-- create a directory of faculty in a given college (College of Science)
SELECT lastname || ', ' || firstname || ' (' || netid || ')' FROM faculty WHERE college='College of Science' ORDER BY lastname;

-- create a directory of faculty in a given department (Electrical Engineering)
SELECT lastname || ', ' || firstname || ' (' || netid || ')' FROM faculty WHERE department='Electrical Engineering' ORDER BY lastname;

