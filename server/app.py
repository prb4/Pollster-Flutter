from flask import Flask, jsonify, request, make_response
from pprint import pprint
import pdb

import middleware as mid

app = Flask(__name__)

@app.route("/submit/answer", methods=['POST'])
def submitAnswer():
    data = request.get_json()
    print(data['answer'])

    return make_response(jsonify(message="OK"), 200)

@app.route("/submit/poll", methods=['POST'])
def submitQuestion():
    data = request.get_json()
    pprint(data)

    return make_response(jsonify(message="OK"), 200)

@app.route("/login", methods=['POST'])
def login():
    data = request.get_json()
    pprint(data)

    logged_in = mid.validate_login(data['username'], data['password'])
    if logged_in:
        return make_response(jsonify(message="OK"), 200)
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
