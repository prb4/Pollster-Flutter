import pdb

import sys
import os

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)

import database


db = database.Database(database.host, database.user, database.password, "Pollster")
#db.create_database("Pollster")


user_id = db.convert_username_to_id("user2")
print(user_id)
