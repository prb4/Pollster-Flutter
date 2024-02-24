#!/usr/local/bin/python3
import requests
from pprint import pprint

ip = "192.168.11.48"

user_id=1
created_poll_id = "ef15f629-cece-40b6-8ebf-07dc6ea1ce93"
received_poll_id = "4f8dc343-9e92-4ae4-a489-6254da2b90cd"

resp = requests.get("http://"+ip+":5000/poll/created?user_id=1&poll_id={}".format(created_poll_id))
pprint(resp.json())

resp = requests.get("http://"+ip+":5000/poll/received?user_id=1&poll_id".format(received_poll_id))
pprint(resp.json())

