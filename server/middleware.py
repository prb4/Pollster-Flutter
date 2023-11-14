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
            polls[uuid] = []

        poll = json.loads(poll[1])
        polls[uuid].append(poll)

    pprint.pprint(polls)
    return polls

