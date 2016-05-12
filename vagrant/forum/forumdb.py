# Database access functions for the web forum.

from psycopg2 import connect
from psycopg2.extras import (DictCursor,)


# Get posts from database.
def GetAllPosts():
    '''Get all the posts from the database, sorted with the newest first.

    Returns:
      A list of dictionaries, where each dictionary has a 'content' key
      pointing to the post content, and 'time' key pointing to the time
      it was posted.
    '''
    psql_conn = connect('dbname=forum')
    query = 'SELECT content, time FROM posts ORDER BY time DESC'

    dict_curs = psql_conn.cursor(cursor_factory=DictCursor)
    dict_curs.execute(query)
    posts = dict_curs.fetchall()
    psql_conn.close()
    return posts


# Add a post to the database.
def AddPost(content):
    '''Add a new post to the database.

    Args:
      content: The text content of the new post.
    '''
    psql_conn = connect('dbname=forum')
    query = "INSERT INTO posts (content) VALUES ('%s')" % content
    curs = psql_conn.cursor()
    curs.execute(query)
    psql_conn.commit()
    psql_conn.close()
