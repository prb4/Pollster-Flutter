import database
import pdb

db = database.Database(database.host, database.user, database.password, "Pollster")
#db.create_database("Pollster")


user_id = db.convert_username_to_id("user2")
print(user_id)
