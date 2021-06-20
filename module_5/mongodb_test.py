# Assignee: Skyler Millburn
# Assignment: 5.2
# Description: Test connection to MongoDB
from pymongo import MongoClient

url = "mongodb+srv://admin:admin@cluster0.gs5ga.mongodb.net/pytech"

client = MongoClient(url)
db = client.pytech

print(db.list_collection_names())
