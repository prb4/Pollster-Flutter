import mysql.connector
import json
import uuid
import datetime
import pdb

# docker run --network host --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql
# mysql -h127.0.0.1 -u root -p

host = "localhost"
user = "root"
password = "my-secret-pw"

class Database():
    dataBase = None
    cursor = None

    def __init__(self, host, user, password, database=None):
        if database:
            self.dataBase = mysql.connector.connect(
                host = host,
                user = user,
                passwd = password,
                database = database
            )
        else:
            self.dataBase = mysql.connector.connect(
                host = host,
                user = user,
                passwd = password
            )

    def create_database(self, database_name: str):
        cursor = self.dataBase.cursor()
        cursor.execute("CREATE DATABASE IF NOT EXISTS {}".format(database_name))
        self.dataBase.close()

    def create_table(self, statement):
        cursor = self.dataBase.cursor()
        cursor.execute(statement)

    def add_user(self, email, password, phonenumber, username):
        '''
        For when a user has signed up for the first time
        '''
        last_access = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        start_date = last_access.split(" ")[0] #Only want the date

        sql = "INSERT INTO USERS (EMAIL, PASSWORD, PHONENUMBER, USERNAME, START_DATE, LAST_ACCESS) VALUES (%s, %s, %s, %s, %s, %s)"
        val = (email, password, phonenumber, username, start_date, last_access)


        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)
        self.dataBase.commit()

    def _validate_polls(self, polls: list):
        #Dont need contacts anymore, get ride of it
        polls.pop('contacts')
        for poll in polls['polls']:
            if not isinstance(poll['question'], str):
                print("Question failed validation: {}".format(poll['question']))
                return None

            if not isinstance(poll['answers'], list):
                print("Answers failed validation: {}".format(poll['answers']))
                return None

        return polls

    def _normalize_polls(self, polls: list):
        contact_ids = []
        #Convert the username / phonenumbers to the internal user_id value
        for contact in polls['contacts']:
            contact_id = self.convert_username_to_id(contact)
            contact_ids.append(contact_id)

        polls = self._validate_polls(polls)
        return contact_ids, polls


    def add_poll_creator(self, creator: str, polls) -> str:
        '''
        For when a poll is created. Store the poll in the creator table. There will be a seperate table for recipeints. A poll with 3 questions will have 3 entries in this table, 1 for each poll
        creator - id of the person that created the poll (not the username, but the int/uuid value)
        polls - the actual poll question(s)
            poll = [
                    {'contacts': [contacts],
                     'question': question,
                     'answers': [answers]
                    }
                   ]
        recipients - id's of the people that the poll is being sent to

        returns the uuid of the poll
        '''

        created = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

        contacts, polls = self._normalize_polls(polls)
        
        if not polls:
            return None

        poll_uuid = str(uuid.uuid4())
        #Add creator's id in front of poll id number to prevent collisions
        poll_uuid = poll_uuid + "-" + str(creator)

        sql = "INSERT INTO CREATOR (POLL_UUID, CREATOR, POLL, CREATED) VALUES (%s, %s, %s, %s)"

        for poll in polls['polls']:
            val = (poll_uuid, creator, json.dumps(poll), created)

            cursor = self.dataBase.cursor()
            cursor.execute(sql, val)
            self.dataBase.commit()

        return poll_uuid

    def add_poll_recipient(self, recipient: str, poll_uuid: str, answered: bool = False):
        '''
        For when a new poll gets created, a way to track who the polls should be pushed to and if they are answered. When called, the poll will be marked as unanswered.

        recipient: the ID of someone to answer the poll. Not the username, but the int/uuid value
        poll_uuid: The id to find the poll question(s) in the CREATOR table
        answered: Tracks if this poll has been answered by the <reciepient>
        '''

        sql = "INSERT INTO RECIPIENT (RECIPIENT, POLL_UUID, ANSWERED) VALUES (%s, %s, %s)"

        val = (recipient, poll_uuid, False)

        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)
        self.dataBase.commit()

        #TODO - send push notification notifying about poll


    def answered_poll(self, recipient_id: int, poll_uuid: str):
        '''
        For when a poll gets answered, update it in the recipient poll
        '''

        sql = "UPDATE RECIPIENT SET ANSWERED = 1 WHERE RECIPIENT = %s AND POLL_UUID = %s"
        val = (recipient_id, poll_uuid)

        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)
        self.dataBase.commit()

    def _convert_to_id(self, sql: str, val: tuple):
        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)

        matching_rows = cursor.fetchall()
        if len(matching_rows) > 1:
            print("[!] Found too many users: {}".format(username))
            return None

        elif len(matching_rows) == 0:
            print("[!] Didn't find any users: {}".format(username))
            return None

        return matching_rows[0][0]


    def convert_username_to_id(self, username: str) -> int: 
        '''
        Convert username to id
        '''
        sql = "SELECT USER_ID FROM USERS WHERE USERNAME = %s"
        val = (username,)

        return self._convert_to_id(sql, val)

    def convert_phonenumber_to_id(self, phonenumber: str) -> int: 
        '''
        Convert phonenumber to id
        '''
        sql = "SELECT USER_ID FROM PHONENUMBER WHERE USERNAME = %s"
        val = (username,)

        return self._convert_to_id(sql, val)

    def _get_polls(self, sql, val):
        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)

        matching_rows = cursor.fetchall()
        return matching_rows


    def get_open_polls(self, user_id: int):
        '''
        Returns open polls that a user needs to answer

        user_id: the unique user_id value
        '''
        sql = "SELECT CREATOR.POLL FROM CREATOR JOIN RECIPIENT ON CREATOR.POLL_UUID = RECIPIENT.POLL_UUID WHERE RECIPIENT.RECIPIENT = %s AND ANSWERED = False"
        val = (user_id,)

        return self._get_polls(sql, val)

    def get_all_polls(self, user_id: int):
        '''
        Returns open polls that a user needs to answer

        user_id: the unique user_id value
        '''
        sql = "SELECT CREATOR.POLL FROM CREATOR JOIN RECIPIENT ON CREATOR.POLL_UUID = RECIPIENT.POLL_UUID WHERE RECIPIENT.RECIPIENT = %s"
        val = (user_id,)

        return self._get_polls(sql, val)

    def get_password(self, user_id: int):
        '''
        Returns open polls that a user needs to answer

        user_id: the unique user_id value
        '''
        sql = "SELECT PASSWORD FROM USERS WHERE USER_ID = %s"
        val = (user_id,)

        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)

        matching_rows = cursor.fetchall()
        return matching_rows[0][0]

def setup_database():
    db = Database(host, user, password)
    return db

if __name__ == "__main__":
    db_name = "Pollster"

    database = Database(host, user, password)
    database.create_database(db_name)

    database = Database(host, user, password, db_name)
    users_table_statement = """CREATE TABLE IF NOT EXISTS USERS (
                        USER_ID INT AUTO_INCREMENT PRIMARY KEY,
                        EMAIL VARCHAR(50) NOT NULL,
                        PASSWORD VARCHAR(50) NOT NULL,
                        PHONENUMBER VARCHAR(15) NOT NULL,
                        USERNAME VARCHAR(20) NOT NULL,
                        START_DATE DATE NOT NULL,
                        LAST_ACCESS DATETIME NOT NULL
                        )"""
    database.create_table(users_table_statement)

    creator_table_statement = """CREATE TABLE IF NOT EXISTS CREATOR (
                        POLL_ID INT AUTO_INCREMENT PRIMARY KEY,
                        POLL_UUID VARCHAR(50) NOT NULL,
                        CREATOR INT NOT NULL,
                        POLL VARCHAR(500) NOT NULL,
                        CREATED DATE NOT NULL
                        )"""
    database.create_table(creator_table_statement)

    recipient_table_statement = """CREATE TABLE IF NOT EXISTS RECIPIENT (
                        RECIPIENT_ID INT AUTO_INCREMENT PRIMARY KEY,
                        RECIPIENT INT NOT NULL,
                        POLL_UUID VARCHAR(50) NOT NULL,
                        ANSWERED BOOLEAN NOT NULL
                        )"""
    database.create_table(recipient_table_statement)

