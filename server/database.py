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
        for poll in polls['poll']:
            if not isinstance(poll['question'], str):
                print("Question failed validation: {}".format(poll['question']))
                return None

            if not isinstance(poll['answers'], list):
                print("Answers failed validation: {}".format(poll['answers']))
                return None

        return polls

    def _normalize_polls(self, poll):
        contact_ids = []
        #Convert the username / phonenumbers to the internal user_id value

        poll = self._validate_polls(poll)
        return poll


    def add_question(self, question, poll_id):
        sql = "INSERT INTO QUESTIONS (POLL_UUID, QUESTION) VALUES (%s, %s)"

        val = (poll_id, question)

        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)
        self.dataBase.commit()

        return poll_id

    def _add_poll_to_polls_table(self, creator: str, poll: dict) -> str:
        '''
        For when a poll is created. Store the poll in the POLLS table. There will be a seperate table for recipeints. A poll with 3 questions will have 3 entries in this table, 1 for each question
        creator - id of the person that created the poll (not the username, but the int/uuid value)
        polls - the actual poll question(s)
        polls:  {
                    'title':title,
                    'contacts':contats,
                    'polls':[poll]
                }
        poll =  {
                 'question': question,
                 'answers': [answers]
                }
               
        recipients - id's of the people that the poll is being sent to

        returns the uuid of the poll
        '''

        created = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

        poll = self._normalize_polls(poll)
        
        if not poll:
            return None

        sql = "INSERT INTO POLLS (POLL_UUID, CREATOR, TITLE, CREATED) VALUES (%s, %s, %s, %s)"

        val = (poll['poll_id'], creator, poll['title'], created)

        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)
        self.dataBase.commit()

        return poll['poll_id']

    def add_poll_recipient(self, recipient: str, originator: str, poll_uuid: str, answered: bool = False):
        '''
        For when a new poll gets created, a way to track who the polls should be pushed to and if they are answered. When called, the poll will be marked as unanswered.

        recipient: the ID of someone to answer the poll. Not the username, but the int/uuid value
        originator: The ID of the poll creator
        poll_uuid: The id to find the poll question(s) in the POLLS table
        answered: Tracks if this poll has been answered by the <reciepient>
        '''

        sql = "INSERT INTO RECIPIENT (RECIPIENT, ORIGINATOR, POLL_UUID, ANSWERED) VALUES (%s, %s, %s, %s)"

        val = (recipient, originator, poll_uuid, False)

        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)
        self.dataBase.commit()

        #TODO - send push notification notifying about poll


    def update_answered_poll(self, recipient_id: int, poll_uuid: str):
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

        print("[-] Converting username: {}".format(username))

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
        sql = "SELECT POLLS.POLL_UUID, POLLS.TITLE FROM POLLS JOIN RECIPIENT ON POLLS.POLL_UUID = RECIPIENT.POLL_UUID WHERE RECIPIENT.RECIPIENT = %s AND ANSWERED = False"
        val = (user_id,)

        return self._get_polls(sql, val)

    def get_all_polls(self, user_id: int):
        '''
        Returns open polls that a user needs to answer

        user_id: the unique user_id value
        '''
        sql = "SELECT POLLS.POLL_UUID, POLLS.TITLE, POLLS.POLL FROM POLLS JOIN RECIPIENT ON POLLS.POLL_UUID = RECIPIENT.POLL_UUID WHERE RECIPIENT.RECIPIENT = %s"
        val = (user_id,)

        return self._get_polls(sql, val)

    def get_questions(self, poll_id: str):
        '''
        Returns questions associated with a poll id

        poll_id = ID of a poll
        '''

        sql = "SELECT QUESTIONS.QUESTION_ID, QUESTIONS.POLL_UUID, QUESTIONS.QUESTION FROM QUESTIONS WHERE QUESTIONS.POLL_UUID = %s"
        val = (poll_id,)

        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)

        matching_rows = cursor.fetchall()
        return matching_rows


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
                        EMAIL VARCHAR(100) NOT NULL,
                        PASSWORD VARCHAR(100) NOT NULL,
                        PHONENUMBER VARCHAR(15) NOT NULL,
                        USERNAME VARCHAR(20) NOT NULL,
                        START_DATE DATE NOT NULL,
                        LAST_ACCESS DATETIME NOT NULL
                        )"""
    database.create_table(users_table_statement)

    polls_table_statement = """CREATE TABLE IF NOT EXISTS POLLS (
                        POLL_ID INT AUTO_INCREMENT PRIMARY KEY,
                        POLL_UUID VARCHAR(50) NOT NULL,
                        CREATOR INT NOT NULL,
                        TITLE VARCHAR(100) NOT NULL,
                        CREATED DATE NOT NULL
                        )"""
    database.create_table(polls_table_statement)

    questions_table_statement = """CREATE TABLE IF NOT EXISTS QUESTIONS (
                        QUESTION_ID INT AUTO_INCREMENT PRIMARY KEY,
                        POLL_UUID VARCHAR(50) NOT NULL,
                        QUESTION VARCHAR(500) NOT NULL
                        )"""
    database.create_table(questions_table_statement)

    recipient_table_statement = """CREATE TABLE IF NOT EXISTS RECIPIENT (
                        ID INT AUTO_INCREMENT PRIMARY KEY,
                        RECIPIENT INT NOT NULL,
                        ORIGINATOR INT NOT NULL,
                        POLL_UUID VARCHAR(50) NOT NULL,
                        ANSWERED BOOLEAN NOT NULL
                        )"""
    database.create_table(recipient_table_statement)

