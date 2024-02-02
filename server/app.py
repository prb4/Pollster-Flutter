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

    #TODO - add new poll to database


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
    polls = mid.get_open_polls(data['user_id'])
    #TODO - add a return code
    return jsonify(polls)

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
