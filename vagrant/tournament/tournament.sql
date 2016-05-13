DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament

CREATE TABLE players(
    id         SERIAL PRIMARY KEY,
    name       TEXT,
);

CREATE TABLE matches(
    id     SERIAL PRIMARY KEY,
    winner INTEGER REFERENCES players(id),
    loser  INTEGER REFERENCES players(id)
);


CREATE VIEW player_standings AS
    SELECT id, name,
           (SELECT COUNT(*) FROM matches WHERE p.id = matches.winner) AS wins,
           (SELECT COUNT(*) FROM matches WHERE p.id = matches.winner OR p.id = matches.loser) AS matches
    FROM players AS p
        ORDER BY wins DESC;

