DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament

CREATE TABLE players(
    id         SERIAL PRIMARY KEY,
    name       TEXT,
    registered BOOLEAN DEFAULT FALSE NOT NULL
);

CREATE TABLE matches(
    id     SERIAL PRIMARY KEY,
    winner INTEGER REFERENCES players(id),
    loser  INTEGER REFERENCES players(id)
);

CREATE VIEW registered_player_count AS
    SELECT COUNT(*)
    FROM players;

/* CREATE VIEW player_standings AS */
/*     SELECT p.id, p.name, COUNT(m.winner) AS wins, */
/*            COUNT(m.winner) + COUNT(m.loser) AS match_count */
/*         FROM players AS p */
/*             LEFT JOIN matches AS m */
/*             ON p.id = m.winner */
/*             GROUP BY p.id */
/*             ORDER BY wins DESC; */

CREATE VIEW player_standings AS
    SELECT id, name,
           (SELECT COUNT(*) FROM matches WHERE p.id = matches.winner) AS wins,
           (SELECT COUNT(*) FROM matches WHERE p.id = matches.winner OR p.id = matches.loser) AS matches /* TODO: optimize this? */
    FROM players AS p
        ORDER BY wins DESC;


/* IF NOT EXISTS players, matches */
/* INSERT INTO "players" (id,name) VALUES (10,'Winifred Williamson'); */
/* INSERT INTO "players" (id,name) VALUES (11,'Asher Lynch'); */
/* INSERT INTO "players" (id,name) VALUES (12,'Mary Camacho'); */
/* INSERT INTO "players" (id,name) VALUES (13,'Carl Ruiz'); */
/* INSERT INTO "players" (id,name) VALUES (13,'Dorian Quinn'); */
/* INSERT INTO "players" (id,name) VALUES (14,'Avram Gonzales'); */
/* INSERT INTO "players" (id,name) VALUES (15,'Graiden King'); */
/* INSERT INTO "players" (id,name) VALUES (16,'Tucker Joyner'); */
/* INSERT INTO "players" (id,name) VALUES (17,'Wade George'); */
/* INSERT INTO "players" (id,name) VALUES (18,'Riley Cooley'); */
/* INSERT INTO "matches" (id,p1_id,p2_id,winner) VALUES (6,1,2,1); */
/* INSERT INTO "matches" (id,p1_id,p2_id,winner) VALUES (7,3,4,1); */
/* INSERT INTO "matches" (id,p1_id,p2_id,winner) VALUES (8,5,6,1); */
/* INSERT INTO "matches" (id,p1_id,p2_id,winner) VALUES (9,7,8,3); */
/* INSERT INTO "matches" (id,p1_id,p2_id,winner) VALUES (10,9,10,3); */
/* INSERT INTO "matches" (id,p1_id,p2_id,winner) VALUES (11,9,10,4); */
