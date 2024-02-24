#!/bin/bash

sudo snap install core; sudo snap refresh core
sudo apt remove certbot
sudo snap install --classic certbot
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo certbot --nginx -d example.com -d www.example.com
