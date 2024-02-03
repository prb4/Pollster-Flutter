#!/usr/local/bin/python3
import requests
from pprint import pprint

ip = "192.168.1.151"

resp = requests.get("http://"+ip+":5000/history?user_id=1")
pprint(resp.json())
