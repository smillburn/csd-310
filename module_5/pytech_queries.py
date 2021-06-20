# Assignee: Skyler Millburn
# Assignment: 5.3
# Description: query student documents from collection

from pymongo import MongoClient
url = "mongodb+srv://admin:admin@cluster0.gs5ga.mongodb.net/pytech"

client = MongoClient(url)
pytech = client.pytech
students = pytech.students

print("-- DISPLAYING STUDENTS DOCUMENTS FROM find() QUERY --")
for x in students.find():
    print(f"Student ID: {x['student_id']}\nFirst Name: {x['first_name']}\nLast Name: {x['last_name']}\n")

print("-- DISPLAYING STUDENT DOCUMENTS FROM find_one() QUERY --")
doc = students.find_one({"student_id": "1007"})
print(f"Student ID: {doc['student_id']}\nFirst Name: {doc['first_name']}\nLast Name: {doc['last_name']}\n")
