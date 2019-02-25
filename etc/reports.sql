-- reports.sql - a set of example queries that can be applied to the database
-- usage: cat ./etc/reports.sql | sqlite3 ./etc/library.db

-- Eric Lease Morgan <GBELOVSK@nd.edu>
-- (c) University of Notre Dame; distributed under a GNU Public License

-- January 13, 2019 - first cut


-- prelude
SELECT '';
SELECT '';
SELECT "Reports";
SELECT "=======";
SELECT "This is a set of simple & example reports that have be applied to the API Taskforce database.";
SELECT '';
SELECT '';


-- get the number of people in the database
SELECT "Number of records in the database";
SELECT "----------------------------------";
SELECT COUNT( * ) FROM faculty;
SELECT '';
SELECT '';

-- count & tabulate the different types of people
SELECT "Count & tabulate different types of people";
SELECT "-----------------------------------";
SELECT COUNT( type ) AS c, type FROM faculty GROUP BY type ORDER BY c DESC;
SELECT '';
SELECT '';


-- create a random list of faculty; a simple directory
SELECT "A random list of faculty";
SELECT "------------------------";
SELECT lastname || ', ' || firstname || ' (' || netid || ')' FROM faculty WHERE type IS 'Faculty' AND netid > '' ORDER BY RANDOM(), lastname LIMIT 25;
SELECT '';
SELECT '';

-- count & tabulate the number of faculty in each department
SELECT "Number of faculty in each department";
SELECT "------------------------------------";
SELECT COUNT( department ) AS c, department FROM faculty WHERE type IS 'Faculty' GROUP BY department ORDER BY c DESC;
SELECT '';
SELECT '';


-- all faculty from a given department (Electrical Engineering); yet another directory
SELECT "Random list of faculty in a given department (Biological Sciences)";
SELECT "------------------------------------------------------------------";
SELECT lastname || ', ' || firstname || ' (' || netid || ')' FROM faculty WHERE department='Biological Sciences' ORDER BY RANDOM(), lastname LIMIT 25;
SELECT '';
SELECT '';

-- number of citations
SELECT "Number of (faculty) citations in the database";
SELECT "----------------------------------------------";
SELECT COUNT( doi ) FROM bibliographics;
SELECT '';
SELECT '';


-- count & tabulate the number of citations for each netid
SELECT "Most frequently authored netids";
SELECT "--------------------------------";
SELECT COUNT( netid ) AS c, netid FROM bibliographics GROUP BY netid ORDER BY c DESC LIMIT 50;
SELECT '';
SELECT '';

-- count & tabulate the number of citations for each faculty member
SELECT "Number of citations for each faculty member";
SELECT "-------------------------------------------";
SELECT COUNT( b.netid ) AS c, f.lastname || ', ' || f.firstname
FROM bibliographics AS b, faculty AS f
WHERE f.netid = b.netid
GROUP BY f.lastname, f.firstname
ORDER BY c desc, f.lastname ASC
LIMIT 50;
SELECT '';
SELECT '';

-- count & tabulate the number of citations for faculty member in a given department (Electrical Engineering)
SELECT "Number of citations for each faculty member in a given department (Biological Sciences)";
SELECT "------------------------------------------------------------------------------------------";
SELECT COUNT( b.netid ) AS c, f.lastname || ', ' || f.firstname
FROM bibliographics AS b, faculty AS f
WHERE f.netid = b.netid AND f.department='Biological Sciences'
GROUP BY f.lastname, f.firstname
ORDER BY c desc, f.lastname ASC;
SELECT '';
SELECT '';

-- count & tabulate the top 10 journal titles
SELECT "Top 10 journal titles";
SELECT "---------------------";
SELECT COUNT( title_journal ) AS c, title_journal FROM bibliographics GROUP BY title_journal ORDER BY c DESC LIMIT 10;
SELECT '';
SELECT '';

-- count & tabulate the number of journal titles in a given college (College of Science)
SELECT "Top 25 journal titles written by faculty in a given department (Biological Sciences)";
SELECT "--------------------------------------------------------------------------------";
SELECT COUNT( b.title_journal ) AS c, b.title_journal
FROM bibliographics AS b, faculty AS f
WHERE f.netid = b.netid AND f.department='Biological Sciences'
GROUP BY b.title_journal
ORDER BY c desc
LIMIT 25;
SELECT '';
SELECT '';

SELECT "All faculty who have published in Science or Nature";
SELECT "---------------------------------------------------";
SELECT count( f.netid ) as c, lastname || ', ' || firstname || ' (' || f.department || ')'
FROM bibliographics AS b, faculty AS f
WHERE f.netid = b.netid AND ( b.title_journal='Science' OR b.title_journal='Nature' )
GROUP BY f.netid order by c desc;
SELECT '';
SELECT '';

-- all about a specific netid
SELECT "All about a given NetId (GBELOVSK)";
SELECT "-------------------------------";
SELECT '';
SELECT "                 Name: " || firstname || ' ' || lastname || ' <' || netid || '@nd.edu>'
FROM faculty
WHERE netid = 'GBELOVSK';
SELECT "           Department: " || department
FROM faculty
WHERE netid = 'GBELOVSK';
SELECT "  Number of citations: " || COUNT( doi ) FROM bibliographics WHERE netid = 'GBELOVSK';
SELECT '';
SELECT "  Bibliography";
SELECT '  * ' || b.title_article || ' by ' || f.firstname || ' ' || f.lastname || ' in ' || b.title_journal || ' (' || b.url || ')' || char(10)
FROM bibliographics AS b, faculty AS f
WHERE f.netid = b.netid AND f.netid = 'GBELOVSK'
ORDER BY b.title_journal, b.title_article;
SELECT '';

-- signature
SELECT "--";
SELECT "Eric Lease Morgan <GBELOVSK@nd.edu>";
SELECT "February 5, 2019";
SELECT '';
SELECT '';



