-- cool-queries.sql - a set of "reports"
-- usage: cat ./etc/reports.sql | sqlite3 ./etc/library.db

-- Eric Lease Morgan <emorgan@nd.edu>
-- (c) University of Notre Dame; distributed under a GNU Public License

-- January 13, 2019 - first cut


-- get the number of people in the database
SELECT "Number of faculty";
SELECT "-----------------";
SELECT COUNT( netid ) FROM faculty;
SELECT '';
SELECT '';

-- list all netid's
SELECT "All netids";
SELECT "----------";
SELECT netid FROM faculty ORDER BY netid ASC;
SELECT '';
SELECT '';

-- create a list of faculty; a simple directory
SELECT "All faculty";
SELECT "-----------";
SELECT lastname || ', ' || firstname || ' (' || netid || ')' FROM faculty ORDER BY lastname;
SELECT '';
SELECT '';

-- count & tabulate the number of faculty in each college
SELECT "Number of faculty in each college";
SELECT "---------------------------------";
SELECT COUNT( college ) AS c, college FROM faculty GROUP BY college ORDER BY c DESC;
SELECT '';
SELECT '';

-- count & tabulate the number of faculty in each department
SELECT "Number of faculty in each department";
SELECT "------------------------------------";
SELECT COUNT( department ) AS c, department FROM faculty GROUP BY department ORDER BY c DESC;
SELECT '';
SELECT '';

-- create a directory of faculty from a given college (College of Science)
SELECT "All faculty in a given college (College of Science)";
SELECT "---------------------------------------------------";
SELECT lastname || ', ' || firstname || ' (' || netid || ')' FROM faculty WHERE college='College of Science' ORDER BY lastname;
SELECT '';
SELECT '';

-- create a directory of faculty from a given department (Electrical Engineering)
SELECT "All faculty in a given department (Electrical Engineering)";
SELECT "----------------------------------------------------------";
SELECT lastname || ', ' || firstname || ' (' || netid || ')' FROM faculty WHERE department='Electrical Engineering' ORDER BY lastname;
SELECT '';
SELECT '';

-- number of citations
SELECT "Number of citations in the database";
SELECT "-----------------------------------";
SELECT COUNT( doi ) FROM bibliographics;
SELECT '';
SELECT '';

-- count & tabulate the top 10 journal titles
SELECT "Top 10 journal titles";
SELECT "---------------------";
SELECT COUNT( title_journal ) AS c, title_journal FROM bibliographics GROUP BY title_journal ORDER BY c DESC LIMIT 10;
SELECT '';
SELECT '';

-- count & tabulate the number of citations for each netid
SELECT "Number of citations for each netid";
SELECT "----------------------------------";
SELECT COUNT( netid ) AS c, netid FROM bibliographics GROUP BY netid ORDER BY c DESC;
SELECT '';
SELECT '';

-- count & tabulate the number of citations for faculty member
SELECT "Number of citations for each faculty member";
SELECT "-------------------------------------------";
SELECT COUNT( b.netid ) AS c, f.lastname || ', ' || f.firstname
FROM bibliographics AS b, faculty AS f
WHERE f.netid = b.netid
GROUP BY f.lastname, f.firstname
ORDER BY c desc, f.lastname ASC;
SELECT '';
SELECT '';

-- count & tabulate the number of citations for faculty member in a given college (College of Science)
SELECT "Number of citations for each faculty member in a given college (College of Science)";
SELECT "-----------------------------------------------------------------------------------";
SELECT COUNT( b.netid ) AS c, f.lastname || ', ' || f.firstname
FROM bibliographics AS b, faculty AS f
WHERE f.netid = b.netid AND f.college='College of Science'
GROUP BY f.lastname, f.firstname
ORDER BY c desc, f.lastname ASC;
SELECT '';
SELECT '';

-- count & tabulate the number of citations for faculty member in a given department (College of Science)
SELECT "Number of citations for each faculty member in a given department (Electrical Engineering)";
SELECT "------------------------------------------------------------------------------------------";
SELECT COUNT( b.netid ) AS c, f.lastname || ', ' || f.firstname
FROM bibliographics AS b, faculty AS f
WHERE f.netid = b.netid AND f.department='Electrical Engineering'
GROUP BY f.lastname, f.firstname
ORDER BY c desc, f.lastname ASC;
SELECT '';
SELECT '';

