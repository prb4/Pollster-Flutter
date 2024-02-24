#!/usr/local/bin/python3
import requests
from pprint import pprint

ip = "192.168.1.174"

user_id=1
poll_id="b5271778-10fb-447a-9319-c95099e6d08a"

resp = requests.get("http://"+ip+":5000/poll?user_id={}&poll_id={}&created=True".format(user_id, poll_id))
pprint(resp.json())
