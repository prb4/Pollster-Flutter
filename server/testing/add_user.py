import pdb
import hashlib
import sys
import os

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)

import database


def hash_password(plaintext: str) -> str:
    sha256_hash = hashlib.sha256()
    sha256_hash.update(plaintext.encode('utf-8'))
    hashed_result = sha256_hash.hexdigest()

    return hashed_result

def main():
    db = database.Database(database.host, database.user, database.password, "Pollster")
    #db.create_database("Pollster")

    #echo -n pass123 | sha256sum

    #db.add_user("user1@email.com", "9b8769a4a742959a2d0298c36fb70623f2dfacda8436237df08d8dfd5b37374c", "18675309", "user1")
    #db.add_user("user2@email.com", "3c8b8ed3401c4b9b261a52277e6a18cb44e13bdbb13f8e0ddf5dcfa29035340d", "28675309", "user2")
    #db.add_user("user3@email.com", "c7cc9c9911b3221c6222b213f37acf1a75e75b02f392488ae481ec6721c7a6cd", "38675309", "user3")
    #db.add_user("user4@email.com", "1d4598d1949b47f7f211134b639ec32238ce73086a83c2f745713b3f12f817e5", "48675309", "user4")

    db.add_user("user1@email.com", hash_password("1"), "18675309", "user1")
    db.add_user("user2@email.com", hash_password("2"), "28675309", "user2")
    db.add_user("user3@email.com", hash_password("3"), "38675309", "user3")
    db.add_user("user4@email.com", hash_password("4"), "48675309", "user4")


if __name__ == "__main__":
    main()
