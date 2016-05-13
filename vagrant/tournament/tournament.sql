-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP TABLE IF EXISTS players, matches;

CREATE TABLE players(
    id   SERIAL PRIMARY KEY,
    name TEXT
);

CREATE TABLE matches(
    id     SERIAL PRIMARY KEY,
    p1_id  INTEGER REFERENCES players(id),
    p2_id  INTEGER REFERENCES players(id),
    winner INTEGER REFERENCES players(id)
);

CREATE VIEW registered_player_count AS
    SELECT COUNT(*)
    FROM players

