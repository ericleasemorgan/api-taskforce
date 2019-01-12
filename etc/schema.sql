-- library.sql - a simple bibliographic database

-- Eric Lease Morgan (emorgan@nd.edu)
-- (c) University of Notre Dame; distributed under a GNU Public License

-- January 11, 2019 - first cut


-- faculty
create table faculty (
    id          INTEGER PRIMARY KEY,
    netid       TEXT,
    center      TEXT,
    type        TEXT,
    firstname   TEXT,
    lastname    TEXT,
    department  TEXT,
    college     TEXT,
    title       TEXT,
    status      TEXT
);

-- document identifiers
create table dois (
    netid  TEXT,
    wosid  TEXT,
    doi    TEXT
);
