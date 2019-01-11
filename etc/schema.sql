-- api taskforce
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

create table dois (
    netid  TEXT,
    wosid  TEXT,
    doi    TEXT
);