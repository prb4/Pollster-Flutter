#!/usr/local/bin/python3
import requests
from pprint import pprint

ip = "192.168.1.151"

user_id=1
poll_id="0bc94cca-80a1-4e14-9f28-d3bed1bdc7c7"

resp = requests.get("http://"+ip+":5000/poll/created?user_id={}&poll_id={}".format(user_id, poll_id))
pprint(resp.json())
