import database
import pdb

db = database.Database(database.host, database.user, database.password, "Pollster")
#db.create_database("Pollster")

db.add_user("user1@email.com", "pass123", "18675309", "user1")
db.add_user("user2@email.com", "pass234", "28675309", "user2")
db.add_user("user3@email.com", "pass345", "38675309", "user3")
db.add_user("user4@email.com", "pass456", "48675309", "user4")
