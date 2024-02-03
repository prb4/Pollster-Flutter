import database
import pprint
import json
import pdb

def validate_login(username:str, hashed_password:str):

    db = database.Database(database.host, database.user, database.password, "Pollster")

    user_id = db.convert_username_to_id(username)

    password = db.get_password(user_id)

    if password == hashed_password:
        return user_id
    else:
        return None

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
        poll['votes'] = []
 
        for _question in _questions:
            question_id = _question[0]
            poll_id = _question[1]
            question_answer = json.loads(_question[2])

            question = {}
            question['question_id'] = question_id
            question['question'] = question_answer['question']
            question['answers'] = question_answer['answers']

            poll['votes'].append(question)

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

def answer_poll(poll_id: str, user_id: int, votes):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    for vote in votes:
        db.insert_answer(user_id, vote['question_id'], poll_id, vote['answer'])

    return db.update_poll_as_answered(user_id, poll_id)

def add_new_poll(creator_username: str, poll, recipient_input, is_username:bool):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    user_id = db.convert_username_to_id(creator_username)

    recipients = None
    if is_username:
        recipients = [db.convert_username_to_id(recipient) for recipient in recipient_input]
    else:
        recipients = recipient_input

    for question in poll['votes']:
        questions = db.add_question(json.dumps(question), poll['poll_id'])

    db._add_poll_to_polls_table(user_id, poll)

    for recipient in recipients:
        db.add_poll_recipient(recipient, user_id, poll['poll_id'])
