import mysql.connector
from typing import Union
import json
import uuid
import datetime
import pdb

# docker run --network host --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql
# mysql -h127.0.0.1 -u root -p

#host = "localhost"
#host = "10.17.0.5"
#host = "143.198.13.195"
host = "database"
user = "root"
password = "DatabasePassword8675309"

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

    def add_user(self, email, password, phonenumber):
        '''
        For when a user has signed up for the first time
        '''
        sql = "SELECT JSON_OBJECT('email', EMAIL, 'phonenumber', PHONENUMBER) AS JSON_OUTPUT FROM USERS WHERE EMAIL = %s OR PHONENUMBER = %s"
        val = (email, phonenumber,)

        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)

        email_flag = False
        phone_flag = False

        matching_rows = cursor.fetchall()
        for row in matching_rows:
            data = json.loads(row[0])
            if email == data['email']:
                email_flag = True
            if phonenumber == data['phonenumber']:
                phone_flag = True

        if phone_flag and email_flag:
            return {'message' : "Phone number and email already exist"}, False
        elif phone_flag:
            return {'message' : "Phone number already exists"}, False
        elif email_flag:
            return {"message" : "Email already exists"}, False

        last_access = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        start_date = last_access.split(" ")[0] #Only want the date


        sql = "INSERT INTO USERS (EMAIL, PASSWORD, PHONENUMBER, START_DATE, LAST_ACCESS) VALUES (%s, %s, %s, %s, %s)"
        val = (email, password, phonenumber, start_date, last_access)


        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)
        self.dataBase.commit()

        return {"message" : "User created"}, True

    def insert_new_question(self, prompt, choices, poll_id):
        #add_question(s)
        sql = "INSERT INTO QUESTIONS (POLL_ID, PROMPT, CHOICES) VALUES (%s, %s, %s)"

        val = (poll_id, prompt, choices)

        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)
        self.dataBase.commit()

        return poll_id

    def insert_new_poll(self, creator: str, poll_id: str, poll_title: str):
    #def _add_poll_to_polls_table(self, creator: str, poll: dict) -> str:
        '''
        For when a poll is created. Store the poll in the POLLS table. There will be a seperate table for recipeints. A poll with 3 questions will have 3 entries in this table, 1 for each question
        creator - id of the person that created the poll (not the username, but the int/uuid value)
        recipients - id's of the people that the poll is being sent to

        returns the uuid of the poll
        '''

        created = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

        sql = "INSERT INTO POLLS (POLL_ID, CREATOR, TITLE, CREATED) VALUES (%s, %s, %s, %s)"

        val = (poll_id, creator, poll_title, created)

        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)
        self.dataBase.commit()

        return poll_id

    def insert_recipient(self, recipient: str, creator: str, poll_id: str, answered: bool = False):
        '''
        For when a new poll gets created, a way to track who the polls should be pushed to and if they are answered. When called, the poll will be marked as unanswered.

        recipient: the ID of someone to answer the poll. Not the username, but the int/uuid value
        creator: The ID of the poll creator
        poll_uuid: The id to find the poll question(s) in the POLLS table
        answered: Tracks if this poll has been answered by the <reciepient>
        '''

        sql = "INSERT INTO RECIPIENT (RECIPIENT, CREATOR, POLL_ID, ANSWERED) VALUES (%s, %s, %s, %s)"

        val = (recipient, creator, poll_id, False)

        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)
        self.dataBase.commit()

        #TODO - send push notification notifying about poll

    def insert_answer(self, recipient_id: int, question_id: int, poll_id: str, answer: str):
        '''
        When a poll gets submitted with an answer, update the CHOICES table with the correct anser
        '''
        sql = "INSERT INTO ANSWERS (QUESTION_ID, RECIPIENT, POLL_ID, ANSWER) VALUES (%s, %s, %s, %s)"
        val = (question_id, recipient_id, poll_id, answer)

        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)
        self.dataBase.commit()


    def update_poll_as_answered(self, recipient_id: int, poll_id: str):
        '''
        For when a poll gets answered, update it in the recipient poll
        '''

        print("[-] Updating {}: {} as answered".format(str(recipient_id), poll_id))
        sql = "UPDATE RECIPIENT SET ANSWERED = 1 WHERE RECIPIENT = %s AND POLL_ID = %s"
        val = (recipient_id, poll_id)

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


    def convert_email_to_id(self, email: str) -> int: 
        '''
        Convert email to id
        '''
        sql = "SELECT USER_ID FROM USERS WHERE EMAIL = %s"
        val = (email,)

        print("[-] Converting email: {}".format(email))

        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)

        matching_rows = cursor.fetchall()
        if len(matching_rows) > 1:
            print("[!] Found too many users: {}".format(email))
            return None

        elif len(matching_rows) == 0:
            print("[!] Didn't find any users: {}".format(email))
            return None

        return matching_rows[0][0]

    def confirm_email(self, email: str):
        sql = "SELECT * from USERS where EMAIL = %s"
        val = (email,)

        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)

        matching_rows = cursor.fetchall()
        return matching_rows

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


    def get_questions(self, poll_id: str):
        sql = "SELECT JSON_OBJECT('question_id', QUESTION_ID, 'poll_id', POLL_ID, 'prompt', PROMPT, 'choices', CHOICES) as JSON_OUTPUT from QUESTIONS where POLL_ID = %s"
        val = (poll_id,)

        questions = self._get_polls(sql, val)
        questions = [json.loads(question[0]) for question in questions]

        for i in range(len(questions)):
            questions[i]['choices'] = json.loads(questions[i]['choices'])
            questions[i]['prompt'] = json.loads(questions[i]['prompt'])

        return questions

    def get_recipients(self, poll_id: str, creator: Union[str, None] = None, recipient: Union[str, None] = None):
        sql = "SELECT JSON_OBJECT('recipient', RECIPIENT, 'creator', CREATOR, 'poll_id', POLL_ID, 'answered', ANSWERED) as JSON_OUTPUT from RECIPIENT where POLL_ID = %s"
        val = (poll_id, )

        if creator:
            sql += "and CREATOR = %s"
            val = (poll_id, creator, )

        elif recipient:
            sql += "and RECIPIENT = %s"
            val = (poll_id, recipient)

        recipients = self._get_polls(sql, val)
        recipients = [json.loads(recipient[0]) for recipient in recipients]

        return recipients

    def get_poll(self, user_id: int, poll_id: str):
        sql = "SELECT JSON_OBJECT('poll_id', POLL_ID, 'title', TITLE, 'created', CREATED, 'creator', CREATOR) as JSON_OUTPUT from POLLS where POLL_ID = %s"
        val = (poll_id, )

        poll_metadata = self._get_polls(sql, val)
        poll_metadata = [json.loads(poll[0]) for poll in poll_metadata]
        poll_metadata = poll_metadata[0]

        if str(poll_metadata['creator']) == str(user_id):
            pass
        sql = ""
        val = ()

        #pdb.set_trace()
        return poll_metadata

    def get_answers(self, user_id: str, poll_id: str):
        '''Get just the answers'''
        sql = "select JSON_OBJECT('answer', ANSWERS.ANSWER, 'question_id', QUESTIONS.QUESTION_ID) as JSON_OUTPUT from QUESTIONS JOIN ANSWERS on ANSWERS.QUESTION_ID = QUESTIONS.QUESTION_ID WHERE ANSWERS.POLL_ID = %s and ANSWERS.RECIPIENT = %s"
        val = (poll_id, user_id)

        poll = self._get_polls(sql, val)
        poll = [json.loads(_poll[0]) for _poll in poll]

        return poll

   
    def get_poll_answered(self, user_id: str, poll_id: str):
        sql = "select JSON_OBJECT('answer', ANSWERS.ANSWER, 'question_id', QUESTIONS.QUESTION_ID, 'prompt', QUESTIONS.PROMPT, 'choices', QUESTIONS.CHOICES) as JSON_OUTPUT from QUESTIONS JOIN ANSWERS on ANSWERS.QUESTION_ID = QUESTIONS.QUESTION_ID WHERE ANSWERS.POLL_ID = %s and ANSWERS.RECIPIENT = %s"
        val = (poll_id, user_id)

        poll = self._get_polls(sql, val)
        poll = [json.loads(_poll[0]) for _poll in poll]

        for i in range(len(poll)):
            poll[i]['choices'] = json.loads(poll[i]['choices'])
            poll[i]['prompt'] = json.loads(poll[i]['prompt'])

        return poll


    def get_polls_created(self, user_id: int):
        sql = "SELECT JSON_OBJECT('poll_id', POLL_ID, 'title', TITLE, 'creator', CREATOR, 'created', created) as JSON_OUTPUT from POLLS where CREATOR = %s"
        val = (user_id, )

        created_polls = self._get_polls(sql, val)
        created_polls = [json.loads(poll[0]) for poll in created_polls]
        return created_polls

    def get_polls_closed(self, user_id: int):
        return self.get_polls_received(user_id, answered=True)

    def get_polls_open(self, user_id: int):
        '''
        Returns open polls that a user needs to answer

        user_id: the unique user_id value
        '''
        return self.get_polls_received(user_id, answered=False)

    def get_polls_received(self, user_id: int, answered: Union[bool, None] = None):
        '''
        Returns open polls that a user needs to answer

        user_id: the unique user_id value
        '''

        sql = "SELECT JSON_OBJECT('poll_id', POLLS.POLL_ID, 'title', POLLS.TITLE, 'creator', POLLS.CREATOR, 'created', POLLS.CREATED) as JSON_OUTPUT from POLLS JOIN RECIPIENT ON POLLS.POLL_ID = RECIPIENT.POLL_ID WHERE RECIPIENT.RECIPIENT = %s"

        if answered == False:
            sql += "and ANSWERED = False"

        elif answered == True:
            sql += "and ANSWERED = True"

        val = (user_id,)

        received_polls = self._get_polls(sql, val)
        received_polls = [json.loads(poll[0]) for poll in received_polls]

        return received_polls

    def get_recipient_table(self, poll_id: str, creator: int):
        '''
        Get data from recipient data based on poll_id
        '''
        sql = "SELECT JSON_OBJECT('recipient', RECIPIENT, 'answered', ANSWERED, 'poll_id', POLL_ID, 'creator', CREATOR) as JSON_OUTPUT from RECIPIENT where POLL_ID = %s and CREATOR = %s"
        val = (poll_id, creator,)

        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)

        matching_rows = cursor.fetchall()
        rows = [json.loads(row[0]) for row in matching_rows]
        return rows

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
                        START_DATE DATE NOT NULL,
                        LAST_ACCESS DATETIME NOT NULL
                        )"""
    database.create_table(users_table_statement)

    polls_table_statement = """CREATE TABLE IF NOT EXISTS POLLS (
                        POLL_AUTO_ID INT AUTO_INCREMENT PRIMARY KEY,
                        POLL_ID VARCHAR(50) NOT NULL,
                        CREATOR INT NOT NULL,
                        TITLE VARCHAR(100) NOT NULL,
                        CREATED DATE NOT NULL
                        )"""
    database.create_table(polls_table_statement)

    questions_table_statement = """CREATE TABLE IF NOT EXISTS QUESTIONS (
                        QUESTION_ID INT AUTO_INCREMENT PRIMARY KEY,
                        POLL_ID VARCHAR(50) NOT NULL,
                        PROMPT VARCHAR(500) NOT NULL,
                        CHOICES VARCHAR(500) NOT NULL
                        )"""
    database.create_table(questions_table_statement)

    answers_table_statement = """CREATE TABLE IF NOT EXISTS ANSWERS (
                        ANSWER_ID INT AUTO_INCREMENT PRIMARY KEY,
                        QUESTION_ID VARCHAR(50) NOT NULL,
                        POLL_ID VARCHAR(50) NOT NULL,
                        RECIPIENT INT NOT NULL,
                        ANSWER VARCHAR(500) NOT NULL
                        )"""
    database.create_table(answers_table_statement)


    recipient_table_statement = """CREATE TABLE IF NOT EXISTS RECIPIENT (
                        ID INT AUTO_INCREMENT PRIMARY KEY,
                        RECIPIENT INT NOT NULL,
                        CREATOR INT NOT NULL,
                        POLL_ID VARCHAR(50) NOT NULL,
                        ANSWERED BOOLEAN NOT NULL
                        )"""
    database.create_table(recipient_table_statement)

