# Assignee: Skyler Millburn
# Assignment: 5.3
# Description: insert data into student collection

from pymongo import MongoClient


fred = {
	"student_id": 1007,
	"first_name": "Fred",
    "last_name": "Bob",
}
bert = {
	"student_id": 1008,
	"first_name": "Bert",
    "last_name": "Buffalo",
    
}
martha = {
	"student_id": 1009,
	"first_name": "Martha",
    "last_name": "Ruha",	
}

url = "mongodb+srv://admin:admin@cluster0.gs5ga.mongodb.net/pytech"

client = MongoClient(url)
pytech = client.pytech
students = pytech.students

print("-- Insert Statements --")
id1 = students.insert_one(fred)
print(f"Inserted Student Record Fred Bob into the students collection with document_id {id1.inserted_id}")

id2 = students.insert_one(bert)
print(f"Inserted Student Record Bert Buffalo into the students collection with document_id {id2.inserted_id}")

id3 = students.insert_one(martha)
print(f"Inserted Student Record Martha Ruha into the students collection with document_id {id3.inserted_id}")
