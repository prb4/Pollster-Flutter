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

    return get_polls(_polls)

def get_all_polls(user_id: str):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    _polls = db.get_all_polls(str(user_id))

    return get_polls(_polls)

def get_polls(_polls):
    db = database.Database(database.host, database.user, database.password, "Pollster")

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
        if not is_username:
            question.pop("question_id")
        questions = db.add_question(json.dumps(question), poll['poll_id'])

    db._add_poll_to_polls_table(user_id, poll)

    for recipient in recipients:
        db.add_poll_recipient(recipient, user_id, poll['poll_id'])

def get_all_created_polls_metadata(user_id: int) -> list:
    db = database.Database(database.host, database.user, database.password, "Pollster")

    created_polls = db.get_created_polls(user_id)
    for i in range(len(created_polls)):
        #questions = db.get_questions(created_polls[i]['poll_id'])
        #created_polls[i]['questions'] = questions

        recipients = db.get_recipient_table(created_polls[i]['poll_id'], user_id)
        created_polls[i]['recipients'] = recipients
    
    return created_polls

def get_all_received_polls_metadata(user_id: int) -> list:
    db = database.Database(database.host, database.user, database.password, "Pollster")

    receieved_polls = db.get_all_received_polls_metadata(user_id)
    return receieved_polls
