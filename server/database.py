import mysql.connector
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

    def add_user(self, email, password, phonenumber):
        last_access = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        start_date = last_access.split(" ")[0] #Only want the date

        sql = "INSERT INTO USERS (EMAIL, PASSWORD, PHONENUMBER, START_DATE, LAST_ACCESS) VALUES (%s, %s, %s, %s, %s)"
        val = (email, password, phonenumber, start_date, last_access)


        cursor = self.dataBase.cursor()
        cursor.execute(sql, val)
        self.dataBase.commit()



def setup_database():
    db = Database(host, user, password)
    return db

if __name__ == "__main__":
    db_name = "Pollster"

    database = Database(host, user, password)
    database.create_database(db_name)

    database = Database(host, user, password, db_name)
    table_statement = """CREATE TABLE USERS (
                        USER_ID INT AUTO_INCREMENT PRIMARY KEY,
                        EMAIL VARCHAR(50) NOT NULL,
                        PASSWORD VARCHAR(50) NOT NULL,
                        PHONENUMBER VARCHAR(15) NOT NULL,
                        START_DATE DATE NOT NULL,
                        LAST_ACCESS DATETIME NOT NULL
                        )"""
    database.create_table(table_statement)



