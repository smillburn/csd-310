# Assignee: Skyler Millburn
# Assignment: 6.2
# Description: Update documents in mongoDB

from pymongo import MongoClient
url = "mongodb+srv://admin:admin@cluster0.gs5ga.mongodb.net/pytech"

client = MongoClient(url)
pytech = client.pytech
students = pytech.students

print("-- DISPLAYING STUDENTS DOCUMENTS FROM find() QUERY --")
for x in students.find():
    print(f"Student ID: {x['student_id']}\nFirst Name: {x['first_name']}\nLast Name: {x['last_name']}\n")

students.insert_one({"student_id": 1010, "first_name": "John", "last_name": "Doe"})

print("-- DISPLAYING STUDENT TEST DOCUMENT --")
doc = students.find_one({"student_id": 1010})
print(f"Student ID: {doc['student_id']}\nFirst Name: {doc['first_name']}\nLast Name: {doc['last_name']}\n")

students.delete_one({"student_id": 1010})

print("-- DISPLAYING STUDENTS DOCUMENTS FROM find() QUERY --")
for x in students.find():
    print(f"Student ID: {x['student_id']}\nFirst Name: {x['first_name']}\nLast Name: {x['last_name']}\n")