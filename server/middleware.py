import database
import pprint
import json
import pdb

def validate_login(username:str, hashed_password:str) -> bool:

    db = database.Database(database.host, database.user, database.password, "Pollster")

    user_id = db.convert_username_to_id(username)

    password = db.get_password(user_id)

    if password == hashed_password:
        return True
    else:
        return False

def get_open_polls(user_id: str):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    _polls = db.get_open_polls(str(user_id))

    polls = []
    for _poll in _polls:
        poll_id = _poll[0]
        title = _poll[1]

        _questions = db.get_questions(poll_id)

        poll = {}
        poll['title'] = title
        poll['poll_id'] = poll_id
        poll['questions'] = []
 
        for _question in _questions:
            question_id = _question[0]
            poll_id = _question[1]
            question_answer = json.loads(_question[2])

            question = {}
            question['question_id'] = question_id
            question['question'] = question_answer['question']
            question['answers'] = question_answer['answers']

            poll['questions'].append(question)

        polls.append(poll)

    pprint.pprint(polls)
    return polls

#    polls = []
#    pdb.set_trace()
#    for poll in _polls:
#        uuid = poll[0]

#        if uuid not in polls.keys():
#            polls[uuid] = {}
#            polls[uuid]['title'] = poll[1]
#            polls[uuid]['polls'] = []

#        poll = json.loads(poll[2])
#        polls[uuid]['polls'].append(poll)
#
#    final_polls = []
#    for key in polls.keys():
#        tmp = {}
#        tmp['uuid'] = key
#        tmp['polls'] = polls[key]['polls']
#        tmp['title'] = polls[key]['title']
#
#        final_polls.append(tmp)
#
#    pprint.pprint(final_polls)
#    return final_polls

def mark_poll_as_answered(pollUUID: str, username: str):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    user_id = db.convert_username_to_id(username)

    return db.update_answered_poll(user_id, pollUUID)

def add_new_poll(creator_username: str, recipients, poll):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    user_id = db.convert_username_to_id(creator_username)

    recipient_ids = [db.convert_username_to_id(recipient) for recipient in recipients]

    for question in poll['poll']:
        questions = db.add_question(json.dumps(question), poll['poll_id'])

    db._add_poll_to_polls_table(user_id, poll)

    for recipient_id in recipient_ids:
        db.add_poll_recipient(recipient_id, user_id, poll['poll_id'])
