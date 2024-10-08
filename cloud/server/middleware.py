import database
import pprint
import json
import pdb
import redis
import os
import uuid

def redis_connect():
    storage = redis.Redis(host=os.getenv("REDIS_SERVER"), port=6379, decode_responses=True)
    return storage

def validate_session(user_id: str, accessToken: str) -> bool:
    storage = redis_connect()
    token = storage.get(user_id)
    print("Token: {}\n Access Token: {}".format(token, accessToken))
    if token == accessToken:
        return True
    else:
        return False

def validate_login(email:str, hashed_password:str):

    db = database.Database(database.host, database.user, database.password, "Pollster")

    user_id = db.convert_email_to_id(email)

    password = db.get_password(user_id)

    if password == hashed_password:
        return create_token(user_id), user_id
    else:
        return None, None

def logout(user_id):
    storage = redis_connect()
    ret = storage.delete(user_id)
    return ret
    
def create_token(user_id: str, expire=60*60*24):
    storage = redis_connect()
    key = user_id
    value = str(uuid.uuid4())
    print("Creating token: {} {} {}".format(key, expire, value))
    ret = storage.setex(key, expire, value)
    #TODO - check ret value
    return value

def submit_feedback(user_id: str, feedback: str):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    db.submit_feedback(user_id, feedback)

    
   
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

def answer_poll(poll_id: str, user_id: int, answers):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    for answer in answers:
        ret = db.insert_answer(user_id, answer['question_id'], poll_id, answer['answer'])

    return db.update_poll_as_answered(user_id, poll_id)

def add_new_poll(creator_id: str, poll, recipient_ids: list):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    recipients = None

    for question in poll['questions']:
        questions = db.insert_new_question(json.dumps(question['prompt']), json.dumps(question['choices']), poll['poll_id'])

    db.insert_new_poll(creator_id, poll['poll_id'], poll['title'])

    for recipient in recipient_ids:
        db.insert_recipient(recipient, creator_id, poll['poll_id'])

def get_created_polls_metadata(user_id: int) -> list:
    db = database.Database(database.host, database.user, database.password, "Pollster")

    created_polls = db.get_polls_created(user_id)
    #for i in range(len(created_polls)):
        #questions = db.get_questions(created_polls[i]['poll_id'])
        #created_polls[i]['questions'] = questions

    #    recipients = db.get_recipient_table(created_polls[i]['poll_id'], user_id)
    
    return created_polls

def get_createdPollMetadata(user_id: int, poll_id: str):
    created_poll = db.get_poll_created(user_id, poll_id) 
    return created_poll[0]

def get_all_received_polls_metadata(user_id: int) -> list:
    db = database.Database(database.host, database.user, database.password, "Pollster")

    receieved_polls = db.get_polls_received(user_id)
    return receieved_polls

def add_user(email: str, password: str, phoneNumber: str):
    db = database.Database(database.host, database.user, database.password, "Pollster")
    msg, ret = db.add_user(email, password, phoneNumber)
    #TODO - validate email is legit
    #TODO - valid password meets length check
    #TODO - validate phone number is good
    return msg, ret

def reset_password(email: str):
    db = database.Database(database.host, database.user, database.password, "Pollster")
    confirmation = db.confirm_email(email)
    if [] == confirmation:
        return None
    else:
        return confirmation[0]

def initiate_password_reset(email: str):
    return {}

def get_poll_created(user_id: str, poll_id: str):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    questions = db.get_questions(poll_id)
    #TODO - this will need to go once the type of question_id is stabilized
    for i in range(len(questions)):
        questions[i]['question_id'] = str(questions[i]['question_id'])

    recipients = db.get_recipients(poll_id, creator=user_id)
    for i in range(len(recipients)):
        if 1 == recipients[i]['answered']:
            #Recipient has answered the poll, get the answers
            recipients[i]['answers'] = db.get_answers(recipients[i]['recipient'], poll_id)
        else:
            recipients[i]['answers'] = []

    resp = {}
    resp['questions'] = questions
    resp['recipients'] = recipients

    return resp

def get_answer_poll(user_id: int, poll_id: str):
    #Based on user id and poll id, return the entire poll (with answers) for answering
    db = database.Database(database.host, database.user, database.password, "Pollster")

    poll_metadata = get_poll(user_id, poll_id)

    if str(poll_metadata['creator']) == str(poll_id):
        #This should not happen, as <user id> is trying to answer this poll
        return -1

    questions = db.get_questions(poll_id)
    recipients = db.get_recipients(poll_id, recipient = user_id)

    data = {}
    data['pollMetadata'] = poll_metadata
    data['questions'] = questions
    data['recipients'] = recipients

    for i in range(len(data['questions'])):
        if isinstance(data['questions'][i]['prompt'], str):
            continue
        else:
            data['questions'][i]['prompt'] = json.loads(data['questions'][i]['prompt'])

    return data

def get_poll(user_id: int, poll_id: str):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    poll = db.get_poll(user_id, poll_id)

    return poll

def get_poll_answered(user_id: int, poll_id: str):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    poll = db.get_poll_answered(user_id, poll_id)

    return poll 

def get_polls_created(user_id: int):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    return db.get_polls_created(user_id)

def get_polls_closed_received(user_id: int):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    return db.get_polls_received(user_id, answered = True) 

def get_polls_received(user_id: int):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    return db.get_polls_received(user_id) 

def get_polls_open(user_id: str):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    return db.get_polls_open(str(user_id))
