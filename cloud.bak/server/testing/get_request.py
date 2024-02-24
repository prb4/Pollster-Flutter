#!/usr/local/bin/python3
import requests

ip = "192.168.1.151"

print(requests.get("http://"+ip+":5000/fetch?user_id=1"))
