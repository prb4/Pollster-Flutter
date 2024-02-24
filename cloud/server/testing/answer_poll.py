import pprint
import pdb

import sys
import os

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)

import database


db = database.Database(database.host, database.user, database.password, "Pollster")

username = "user2"

user_id = db.convert_username_to_id(username)
print("Username: {}\n User ID: {}".format(username, user_id))

db.update_answered_poll(user_id, "a6aaf0a9-15f4-4277-abc3-f2e6f72880fd-1")
