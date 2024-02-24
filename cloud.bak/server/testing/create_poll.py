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

def create_polls(email: str, contacts: list):
    creator_id = email.split("@")[0][-1]

    print("[-] Creator ID: {}".format(creator_id))

    question1 = {'prompt': "Question 1 from user {}".format(creator_id),
            'choices': ["answer1", "answer2", "answer3"]
            }

    question2 = {'prompt': "Question 2 from user {}".format(creator_id),
            'choices': ["answer2", "answer3", "answer4"]
            }


    question3 = {'prompt': "Question 3 from user {}".format(creator_id),
            'choices': ["answer3", "answer4", "answer5"]
            }

    question4 = {'prompt': "Question 4 from user {}".format(creator_id),
            'choices': ["answer4", "answer5", "answer6"]
            }


    contact_ids = [db.convert_email_to_id(contact) for contact in contacts]

    poll = {'title':"Poll title user {}".format(creator_id),
            'contacts':contact_ids,
            'poll_id': str(uuid.uuid4()),
            'questions':[question1, question2, question3, question4]
            }


    user_id = db.convert_email_to_id(email)
    mid.add_new_poll(user_id, poll, contact_ids)
    #uuid = db.add_poll_to_polls_table(creator_id, polls)

    #for contact in contacts:
    #    recipient_id = db.convert_username_to_id(contact)
    #    db.add_poll_recipient(recipient_id, creator_id, uuid)

create_polls("user1@email.com", ["user2@email.com", "user3@email.com", "user4@email.com"])
create_polls("user2@email.com", ["user1@email.com", "user3@email.com", "user4@email.com"])
create_polls("user3@email.com", ["user2@email.com", "user1@email.com", "user4@email.com"])
create_polls("user4@email.com", ["user2@email.com", "user3@email.com", "user1@email.com"])
