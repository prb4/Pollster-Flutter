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

    polls = {}
    for poll in _polls:
        uuid = poll[0]

        if uuid not in polls.keys():
            polls[uuid] = {}
            polls[uuid]['title'] = poll[1]
            polls[uuid]['polls'] = []

        poll = json.loads(poll[2])
        polls[uuid]['polls'].append(poll)

    final_polls = []
    for key in polls.keys():
        tmp = {}
        tmp['uuid'] = key
        tmp['polls'] = polls[key]['polls']
        tmp['title'] = polls[key]['title']

        final_polls.append(tmp)

    pprint.pprint(final_polls)
    return final_polls

def mark_poll_as_answered(pollUUID: str, username: str):
    db = database.Database(database.host, database.user, database.password, "Pollster")

    user_id = db.convert_username_to_id(username)

    return db.update_answered_poll(user_id, pollUUID)

