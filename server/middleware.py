import database

def validate_login(username:str, hashed_password:str) -> bool:

    db = database.Database(database.host, database.user, database.password, "Pollster")

    user_id = db.convert_username_to_id(username)
    print("Username: {}".format(username))
    print("user id: {}".format(user_id))
    password = db.get_password(user_id)

    print("Hashed password: {}".format(hashed_password))
    print("Password: {}".format(password))

    if password == hashed_password:
        return True
    else:
        return False
