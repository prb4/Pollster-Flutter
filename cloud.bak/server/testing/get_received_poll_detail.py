#!/usr/local/bin/python3
import requests
from pprint import pprint

ip = "192.168.1.151"

user_id=1
poll_id="9585f045-e103-41b1-88c2-a7c3e1fdbc41"

resp = requests.get("http://"+ip+":5000/poll/received?user_id={}&poll_id={}".format(user_id, poll_id))
print(resp.json())
