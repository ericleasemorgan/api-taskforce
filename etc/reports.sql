-- reports.sql - a set of example queries that can be applied to the database
-- usage: cat ./etc/reports.sql | sqlite3 ./etc/library.db

-- Eric Lease Morgan <emorgan@nd.edu>
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


-- all faculty from a given college (College of Science); another directory
SELECT "All faculty in a given college (College of Science)";
SELECT "---------------------------------------------------";
SELECT lastname || ', ' || firstname || ' (' || netid || ')' FROM faculty WHERE college='College of Science' ORDER BY lastname;
SELECT '';
SELECT '';


-- all faculty from a given department (Electrical Engineering); yet another directory
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


-- count & tabulate the number of citations for each netid
SELECT "Number of citations for each netid";
SELECT "----------------------------------";
SELECT COUNT( netid ) AS c, netid FROM bibliographics GROUP BY netid ORDER BY c DESC;
SELECT '';
SELECT '';


-- count & tabulate the number of citations for each faculty member
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


-- count & tabulate the number of citations for faculty member in a given department (Electrical Engineering)
SELECT "Number of citations for each faculty member in a given department (Electrical Engineering)";
SELECT "------------------------------------------------------------------------------------------";
SELECT COUNT( b.netid ) AS c, f.lastname || ', ' || f.firstname
FROM bibliographics AS b, faculty AS f
WHERE f.netid = b.netid AND f.department='Electrical Engineering'
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
SELECT "Top 10 journal titles written by faculty in a given college (College of Science)";
SELECT "--------------------------------------------------------------------------------";
SELECT COUNT( b.title_journal ) AS c, b.title_journal
FROM bibliographics AS b, faculty AS f
WHERE f.netid = b.netid AND f.college='College of Science'
GROUP BY b.title_journal
ORDER BY c desc
LIMIT 10;
SELECT '';
SELECT '';


-- all about a specific netid
SELECT "All about a given NetId (tfuja)";
SELECT "-------------------------------";
SELECT '';
SELECT "                 Name: " || firstname || ' ' || lastname || ' <' || netid || '@nd.edu>'
FROM faculty
WHERE netid = 'tfuja';
SELECT "           Department: " || department
FROM faculty
WHERE netid = 'tfuja';
SELECT "              College: " || college
FROM faculty
WHERE netid = 'tfuja';
SELECT "  Number of citations: " || COUNT( doi ) FROM bibliographics WHERE netid = 'tfuja';
SELECT '';
SELECT "  Bibliography";
SELECT '';
SELECT '  * ' || b.title_article || ' by ' || f.firstname || ' ' || f.lastname || ' in ' || b.title_journal || ' (' || b.url || ')' || char(10)
FROM bibliographics AS b, faculty AS f
WHERE f.netid = b.netid AND f.netid = 'tfuja'
ORDER BY b.title_journal, b.title_article;
SELECT '';


-- signature
SELECT "--";
SELECT "Eric Lease Morgan <emorgan@nd.edu>";
SELECT "January 13, 2019";
SELECT '';
SELECT '';


