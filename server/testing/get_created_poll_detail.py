#!/usr/local/bin/python3
import requests
from pprint import pprint

ip = "192.168.1.174"

user_id=4
poll_id="6afed495-ceef-43e2-8562-930d3d1d1c53"

resp = requests.get("http://"+ip+":5000/poll?user_id={}&poll_id={}&created=True".format(user_id, poll_id))
pprint(resp.json())
