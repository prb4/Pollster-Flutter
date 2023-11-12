import database
import pdb

db = database.Database(database.host, database.user, database.password, "Pollster")
#db.create_database("Pollster")

db.add_user("tes@email.com", "pass123", "8675309")
