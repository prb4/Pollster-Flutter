from flask import Flask, jsonify, request, make_response
from pprint import pprint
import pdb

import middleware as mid

app = Flask(__name__)

@app.route("/answer", methods=['POST'])
def answer():
    if request.method == 'POST':
        #Create a poll
        data = request.json
        pprint(data)

        #data['poll_id']
        #data['username']
        #data['user_id']
        #data['answers']
        #ret = mid.mark_poll_as_answered(data['poll_id'], data['username'])

        ret = mid.answer_poll(data['poll_id'], data['user_id'], data['answers'])

        return make_response(jsonify(message="OK"), 200)

@app.route("/password/forgot", methods=['POST'])
def forgot_password():
    data = request.get_json()
    pprint(data)

    ret = mid.initiate_password_reset(data['email'])
    return make_response(jsonify(message=ret), 200)

@app.route("/password/reset", methods=['POST'])
def reset_password():
    data = request.get_json()
    pprint(data)

    ret = mid.reset_password(data['email'])
    if ret:
        return make_response(jsonify({"message":"Confirmed email", "status": "ok"}), 200)
    else:
        return make_response(jsonify({"message":"Failed to find email", "status": "fail"}), 200)




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

@app.route("/poll", methods=['GET', 'POST'])
def poll():

    resp = {}

    if request.method == 'GET':
        data = request.args

        try:
            if "True" == data['created']:
                #Get a poll that the user created
                resp = mid.get_poll_created(data['user_id'], data['poll_id'])
            else:
                #Get a poll that the user recieved
                if "True" == data['open']:
                    pass
                else:
                    #Get an answered poll
                    resp['answeredQuestions'] = mid.get_poll_answered(data['user_id'], data['poll_id'])
                    resp['pollId'] = data['poll_id']
                    resp['recipient'] = data['user_id']
        except KeyError:
            resp = mid.get_answer_poll(data['user_id'], data['poll_id'])


        pprint(resp)
        return make_response(jsonify(resp), 200)

    elif request.method == 'POST':
        #Create a poll
        data = request.json
        pprint(data)

        #TODO - fix to get around the contacts data structure from flutter
        contacts = [contact['id'] for contact in data['recipients']]
        mid.add_new_poll(data['user_id'], data, contacts)

        return make_response(jsonify(message="OK"), 200)

@app.route("/polls", methods=['GET'])
#This end point only returns metadata on a poll
def polls():
    data = request.args
    #data['user_id']

    resp = {}

    if "True" == data['created']:
        #Get polls that the user created
        created_polls = mid.get_polls_created(data['user_id'])
        resp['createdPollsMetadata'] = created_polls

    else:
        #Get polls that the user received
        try:
            if "True" == data['open']:
                #Get the polls that have NOT been answered
                open_polls = mid.get_polls_open(data['user_id'])
                resp['openPollsMetadata'] = open_polls
        except KeyError:
            #Get the polls that have been answered
            received_polls = mid.get_polls_closed_received(data['user_id'])
            resp['receivedPollsMetadata'] = received_polls

    pprint(resp)

    return make_response(jsonify(resp), 200)

#@app.route("/history/created", methods=['GET'])
#def history_created():
#    data = request.args
#
#    created_polls = mid.get_all_created_polls_metadata(data['user_id'])
#
#    resp = {}
#    resp['pollMetadata'] = created_polls
#    pprint(resp)
#
#    return make_response(jsonify(resp), 200)
#
#@app.route("/history/received", methods=['GET'])
#def history_received():
#    data = request.args
#
#    received_polls = mid.get_all_received_polls_metadata(data['user_id'])
#
#    resp = {}
#    resp['pollMetadata'] = received_polls
#    pprint(resp)
#
#    return make_response(jsonify(resp), 200)

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
