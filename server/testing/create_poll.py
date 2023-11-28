import pdb

import sys
import os

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)

import database


db = database.Database(database.host, database.user, database.password, "Pollster")
#db.create_database("Pollster")

def create_polls(creator_id: int, contacts: list):
    poll1 = {'question': "Question 1 from user {}".format(creator_id),
            'answers': ["answer1", "answer2", "answer3"]
            }

    poll2 = {'question': "Question 2 from user {}".format(creator_id),
            'answers': ["answer2", "answer3", "answer4"]
            }


    poll3 = {'question': "Question 3 from user {}".format(creator_id),
            'answers': ["answer3", "answer4", "answer5"]
            }

    poll4 = {'question': "Question 4 from user {}".format(creator_id),
            'answers': ["answer4", "answer5", "answer6"]
            }


    polls = {'title':"Poll title user {}".format(creator_id),
            'contacts':contacts,
            'polls':[poll1, poll2, poll3, poll4]
            }

    uuid = db.add_poll_to_polls_table(creator_id, polls)

    for contact in contacts:
        recipient_id = db.convert_username_to_id(contact)
        db.add_poll_recipient(recipient_id, uuid)

create_polls(1, ["user2", "user3", "user4"])
create_polls(2, ["user1", "user3", "user4"])
create_polls(3, ["user2", "user1", "user4"])
create_polls(4, ["user2", "user3", "user1"])
