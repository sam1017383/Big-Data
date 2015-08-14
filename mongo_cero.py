
import pymongo

from pymongo import MongoClient
client= MongoClient()
	# O utilizar client = MongoClient('localhost', 27017)  o  
	# client = MongoClient('mongodb://localhost:27017/')


#Obteniendo una base de datos
db = client.test_database
	
collection=db.test_collection


post = {
"author": "Mike",
"text": "@PexDesigns @TheAnimeBible I know that feel man :(",
"date": "13 de agosto 2015"
}

post_id = collection.insert(post)


uno = collection.find({"author": "Miguel", })
print uno