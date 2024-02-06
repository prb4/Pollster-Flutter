from flask import Flask, jsonify, request, make_response
from pprint import pprint
import pdb

import middleware as mid

app = Flask(__name__)

@app.route("/submit/answer", methods=['POST'])
def submitAnswer():
    try:
        data = request.get_json()
        pprint(data)

        #data['poll_id']
        #data['username']
        #data['user_id']
        #data['answers']
        #ret = mid.mark_poll_as_answered(data['poll_id'], data['username'])
        ret = mid.answer_poll(data['poll_id'], data['user_id'], data['votes'])

        return make_response(jsonify(message="OK"), 200)
    except Exception:
        return make_response(jsonify(message="Error"), 200)

@app.route("/submit/poll", methods=['POST'])
def submitQuestion():
    data = request.get_json()
    pprint(data)

    #TODO - fix to get around the contacts data structure from flutter
    contacts = [contact['id'] for contact in data['contacts']]
    mid.add_new_poll(data['username'], data, contacts, False)


    return make_response(jsonify(message="OK"), 200)

@app.route("/login", methods=['POST'])
def login():
    data = request.get_json()
    pprint(data)

    user_id = mid.validate_login(data['username'], data['password'])
    if user_id:
        data = {}
        data['message'] = "OK"
        data['user_id'] = user_id
        return make_response(jsonify(data), 200)
    else:
        return make_response(jsonify(message="Login failure"), 200)


@app.route("/signup", methods=['POST'])
def signup():
    data = request.get_json()
    pprint(data)

    return make_response(jsonify(message="OK"), 200)

@app.route("/fetch", methods=['GET'])
def fetch():
    data = request.args
    polls = mid.get_polls_open(data['user_id'])
    #TODO - add a return code
    return jsonify(polls)

@app.route("/polls", methods=['GET'])
#This end point only returns metadata on a poll
def polls():
    data = request.args
    #data['user_id']

    resp = {}

    if "True" == data['created']:
        created_polls = mid.get_polls_created(data['user_id'])
        resp['createdPollsMetadata'] = created_polls

    elif "True" == data['received']:
        try:
            if "True" == data['open']:
                open_polls = mid.get_polls_open(data['user_id'])
                resp['openPollsMetadata'] = open_polls
        except KeyError:
            received_polls = mid.get_polls_received(data['user_id'])
            resp['receivedPollsMetadata'] = received_polls

    pprint(resp)

    return make_response(jsonify(resp), 200)

@app.route("/poll", methods=['GET'])
def poll():
    data = request.args

@app.route("/history/created", methods=['GET'])
def history_created():
    data = request.args

    created_polls = mid.get_all_created_polls_metadata(data['user_id'])

    resp = {}
    resp['pollMetadata'] = created_polls
    pprint(resp)

    return make_response(jsonify(resp), 200)

@app.route("/history/received", methods=['GET'])
def history_received():
    data = request.args

    received_polls = mid.get_all_received_polls_metadata(data['user_id'])

    resp = {}
    resp['pollMetadata'] = received_polls
    pprint(resp)

    return make_response(jsonify(resp), 200)

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
