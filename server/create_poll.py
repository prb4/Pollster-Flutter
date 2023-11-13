import database
import pdb

db = database.Database(database.host, database.user, database.password, "Pollster")
#db.create_database("Pollster")

creator_id = 1

contacts = ["user2", "user3", "user4"]

poll1 = {'contacts' : contacts,
        'question': "This is a question",
        'answers': ["answer1", "answer2", "answer3"]
        }

poll2 = {'contacts' : contacts,
        'question': "This is question 2",
        'answers': ["answer2", "answer3", "answer4"]
        }

poll3 = {'contacts' : contacts,
        'question': "This is question 3",
        'answers': ["answer3", "answer4", "answer5"]
        }

polls=[poll1, poll2, poll3]

uuid = db.add_poll_creator(creator_id, polls)

for contact in poll1['contacts']:
    db.add_poll_recipient(contact, uuid)
