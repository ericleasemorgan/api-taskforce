-- library.sql - a simple bibliographic database

-- Eric Lease Morgan (emorgan@nd.edu)
-- (c) University of Notre Dame; distributed under a GNU Public License

-- January 11, 2019 - first cut
-- January 13, 2019 - changed dois to bibliographics and enhanced


-- faculty
create table faculty (
    id          INTEGER PRIMARY KEY,
    netid       TEXT,
    firstname   TEXT,
    lastname    TEXT,
    department  TEXT,
    type        TEXT
);

-- bibliographics
create table bibliographics (
    authors        TEXT,
    date           TEXT,
    doi            TEXT,
    netid          TEXT,
    title_article  TEXT,
    title_journal  TEXT,
    url            TEXT,
    wosid          TEXT
);
