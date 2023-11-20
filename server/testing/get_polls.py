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

polls = db.get_open_polls(user_id)
pprint.pprint(polls)

print("#"*30)
polls = db.get_all_polls(user_id)
pprint.pprint(polls)
