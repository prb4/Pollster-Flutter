import pdb

import uuid
import sys
import os

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)

import database
import middleware as mid


db = database.Database(database.host, database.user, database.password, "Pollster")
#db.create_database("Pollster")

def create_polls(username: str, contacts: list):
    creator_id = username[-1]
    print("[-] Creator ID: {}".format(creator_id))

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


    poll = {'title':"Poll title user {}".format(creator_id),
            'contacts':contacts,
            'poll_id': str(uuid.uuid4()),
            'votes':[poll1, poll2, poll3, poll4]
            }


    mid.add_new_poll(username, poll, contacts, True)
    #uuid = db.add_poll_to_polls_table(creator_id, polls)

    #for contact in contacts:
    #    recipient_id = db.convert_username_to_id(contact)
    #    db.add_poll_recipient(recipient_id, creator_id, uuid)

create_polls("user1", ["user2", "user3", "user4"])
create_polls("user2", ["user1", "user3", "user4"])
create_polls("user3", ["user2", "user1", "user4"])
create_polls("user4", ["user2", "user3", "user1"])
