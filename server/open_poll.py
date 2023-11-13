import database
import pprint
import pdb

db = database.Database(database.host, database.user, database.password, "Pollster")

username = "user2"

user_id = db.convert_username_to_id(username)
print("Username: {}\n User ID: {}".format(username, user_id))

polls = db.open_polls(user_id)
pprint.pprint(polls)
