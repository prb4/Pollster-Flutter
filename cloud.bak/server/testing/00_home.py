#!/usr/local/bin/python3
import requests
from pprint import pprint

ip = "192.168.11.48"

user_id=1
poll_id="0bc94cca-80a1-4e14-9f28-d3bed1bdc7c7"

#Create new poll

#Get open polls
received_poll_id = "4f8dc343-9e92-4ae4-a489-6254da2b90cd"
resp = requests.get("http://"+ip+":5000/polls?user_id=1&open=True&created=False&received=True")
pprint(resp.json())

#Get historical polls
resp = requests.get("http://"+ip+":5000/polls?user_id=1&created=True&received=False")
pprint(resp.json())

resp = requests.get("http://"+ip+":5000/polls?user_id=1&created=False&received=True")
pprint(resp.json())

