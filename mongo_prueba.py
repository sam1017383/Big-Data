
import pymongo

from pymongo import MongoClient
client= MongoClient()
	# O utilizar client = MongoClient('localhost', 27017)  o  
	# client = MongoClient('mongodb://localhost:27017/')


#Obteniendo una base de datos
db=client.test_database
	
collection=db.test_collection


#Asi luce un documento:
post = {
"author": "Mike",
"text": "My first blog post!",
"tags": ["mongodb", "python", "pymongo"],
"date": "13 de agosto 2015"
}


#Insertar un documento con metodo insert_one()
posts = db.posts
post_id = posts.insert(post)

#Verificar que se creo la coleccion al enlistar las colecciones en la base de datos
nombres = db.collection_names(include_system_collections=False)

#Consultar un documento con find_one()
uno = posts.find_one()
print uno
