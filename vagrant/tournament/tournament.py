#!/usr/bin/env python
#
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2


def connect():
    """Connect to the PostgreSQL database.  Returns a database connection."""
    return psycopg2.connect("dbname=tournament")


def register_player(name):
    """Adds a player to the tournament database.

    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)

    Args:
      name: the player's full name (need not be unique).
    """
    conn = connect()
    curs = conn.cursor()
    curs.execute('INSERT INTO players (name, registered) VALUES (%s, TRUE)',
            (name,))
    conn.commit()
    conn.close()


def delete_players():
    """Remove all the player records from the database."""
    conn = connect()
    curs = conn.cursor()
    curs.execute('DELETE FROM players')
    conn.commit()
    conn.close()


def delete_matches():
    """Remove all the match records from the database."""
    conn = connect()
    curs = conn.cursor()
    curs.execute('DELETE FROM matches')
    conn.commit()
    conn.close()


def count_players():
    """Returns the number of players currently registered."""
    conn = connect()
    curs = conn.cursor()
    curs.execute('SELECT COUNT(*) FROM players')
    result = curs.fetchone()
    conn.close()
    return result[0]


def player_standings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    conn = connect()
    curs = conn.cursor()
    curs.execute('SELECT * FROM player_standings')
    result = curs.fetchall()
    conn.close()
    return result


def report_match(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    conn = connect()
    curs = conn.cursor()
    curs.execute('INSERT INTO matches (winner, loser) VALUES (%s, %s)',
            ((winner,), (loser,)))
    conn.commit()
    conn.close()


def swiss_pairings():
    """Returns a list of pairs of players for the next round of a match.

    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.

    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
    pairings = []
    standings = player_standings()

    for i in xrange(0, len(standings), 2):
        id1   = standings[i][0]
        name1 = standings[i][1]
        id2   = standings[i+1][0]
        name2 = standings[i+1][1]
        pairings.append((id1, name1, id2, name2))

    return pairings
