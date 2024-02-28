from flask import Flask, jsonify, request, make_response
import base64
from flask_cors import CORS
import os
from pprint import pprint
import pdb

import middleware as mid

app = Flask(__name__)
CORS(app)

def validate_session(data):
    print("[-] Validating token: {} for user: {}".format(data['accessToken'], data['user_id']))
    ret = mid.validate_session(data['user_id'], data['accessToken'])
    
    if ret:
        return True, None
    else:
        data = {}
        data['message'] = "Error"
        data['detail'] = "Invalid session"

        resp = make_response(jsonify(data), 200)
        return False, resp

@app.route("/api/v1/answer", methods=['POST'])
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

        valid, resp = validate_session(data)
        if not valid:
            return resp

        ret = mid.answer_poll(data['poll_id'], data['user_id'], data['answers'])

        return make_response(jsonify(message="OK"), 200)

@app.route("/api/v1/feedback", methods=['POST'])
def feedback():
    if request.method == 'POST':
        #Create a poll
        data = request.json
        pprint(data)

        #data['poll_id']
        #data['username']
        #data['user_id']
        #data['answers']
        #ret = mid.mark_poll_as_answered(data['poll_id'], data['username'])

        valid, resp = validate_session(data)
        if not valid:
            return resp

        pprint(data)

        if data['encoded'] == True:
            decoded_msg = base64.b64decode(data['message']).decode()
            print("Decoded message: {}".format(decoded_msg))
        else:
            decoded_msg = data['message']

        ret = mid.submit_feedback(str(data['user_id']), decoded_msg)
            
        return make_response(jsonify(message="OK"), 200)


@app.route("/api/v1/password/forgot", methods=['POST'])
def forgot_password():
    data = request.get_json()
    pprint(data)
    
    valid, resp = validate_session(data)
    if not valid:
        return resp


    ret = mid.initiate_password_reset(data['email'])

    pprint(ret)
    return make_response(jsonify(message=ret), 200)

@app.route("/api/v1/password/reset", methods=['POST'])
def reset_password():
    data = request.get_json()
    pprint(data)

    valid, resp = validate_session(data)
    if not valid:
        return resp


    ret = mid.reset_password(data['email'])
    if ret:
        return make_response(jsonify({"message":"Confirmed email", "status": "ok"}), 200)
    else:
        return make_response(jsonify({"message":"Failed to find email", "status": "fail"}), 200)

@app.route("/api/v1/login", methods=['POST'])
def login():
    data = request.get_json()
    pprint(data)

    accessToken, user_id = mid.validate_login(data['username'], data['password'])
    if user_id:
        data = {}
        data['message'] = "OK"
        data['user_id'] = user_id
        data['accessToken'] = accessToken
        pprint("Sending response: {}".format(data))
        return make_response(jsonify(data), 200)
    else:
        return make_response(jsonify(message="Login failure"), 200)

@app.route("/api/v1/logout", methods=['POST'])
def logout():
    data = request.get_json()
    pprint(data)

    valid, resp = validate_session(data)
    if not valid:
        return resp

    ret = mid.logout(data['user_id'])
    data = {}
    if ret:
        data['message'] = "OK"
        data['detail'] = str(ret)
        return make_response(jsonify(data), 200)
    else:
        data['message'] = "Error"
        data['detail'] = "Logout failure: {}".format(str(ret))
        return make_response(jsonify(data), 200)


@app.route("/api/v1/signup", methods=['POST'])
def signup():
    data = request.get_json()
    pprint(data)

    msg, ret = mid.add_user(data['email'], data['password'], data['phoneNumber'])

    resp = {}
    resp['detail'] = msg['message']

    if ret:
        resp["message"] = "User added"
        resp["status"] = "ok"
    else:
        resp["message"] = "Failed to add user"
        resp["status"] = "fail"

    pprint(resp)
    return make_response(jsonify(resp), 200)


    
@app.route("/api/v1/fetch", methods=['GET'])
def fetch():
    data = request.args

    valid, resp = validate_session(data)
    if not valid:
        return resp

    polls = mid.get_polls_open(data['user_id'])
    #TODO - add a return code
    return jsonify(polls)

@app.route("/api/v1/poll", methods=['GET', 'POST'])
def poll():

    resp = {}

    if request.method == 'GET':
        data = request.args

        valid, resp = validate_session(data)
        if not valid:
            return resp

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

        valid, resp = validate_session(data)
        if not valid:
            return resp


        #TODO - fix to get around the contacts data structure from flutter
        contacts = [contact['id'] for contact in data['recipients']]
        mid.add_new_poll(data['user_id'], data, contacts)

        return make_response(jsonify(message="OK"), 200)

@app.route("/api/v1/polls", methods=['GET'])
#This end point only returns metadata on a poll
def polls():
    data = request.args
    #data['user_id']

    valid, resp = validate_session(data)
    if not valid:
        return resp


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

if __name__ == "__main__":
    server_port = int(os.getenv("SERVER_PORT"))
    print("[-] Running on port: {}".format(str(server_port)))
    app.run(host='0.0.0.0', port=server_port, debug=True)
