#!/bin/bash

docker container rm -f some-mysql
docker run --network host -v ./mysqld:/var/run/mysqld --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql
sleep 15

python3 ./database.py

#python3 ./testing/add_user.py

#python3 ./testing/create_poll.py
