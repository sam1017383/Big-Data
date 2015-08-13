import pymongo

from pymongo import MongoClient
client= MongoClient()
	# O utilizar client = MongoClient('localhost', 27017)  o  
	# client = MongoClient('mongodb://localhost:27017/')


#Obteniendo una base de datos
db=client.tweets
	
coleccion = db.primera_coleccion


#Asi luce un documento:
tweet = {
"text": "@Lamb2ja Hey James! How odd :/ Please call our Contact Centre on 02392441234 and we will be able to assist you :) Many thanks!",
"genero": "hombre"
}
post_id = coleccion.insert_one(tweet).inserted_id

tweet = {
"text": "oh god, my babies' faces :( https://t.co/9fcwGvaki0",
"genero": "hombre"
}
post_id = coleccion.insert_one(tweet).inserted_id

tweet = {
"text": "I'm so tired hahahah :(",
"genero": "hombre"
}
post_id = coleccion.insert_one(tweet).inserted_id

tweet = {
"text": "Hello I need to know something can u fm me on Twitter?? \u2014 sure thing :) dm me x http://t.co/W6Dy130BV7",
"genero": "hombre"}
post_id = coleccion.insert_one(tweet).inserted_id

tweet = {
"text": "Hello :) Get Youth Job Opportunities follow &gt;&gt; @tolajobjobs @maphisa301",
"genero": "hombre"}
post_id = coleccion.insert_one(tweet).inserted_id

tweet = {
"text": "@johngutierrez1 hope the rest of your night goes by quickly... I am off to bed... got my music fix and now it is time to dream  :)",
"genero": "mujer"}
post_id = coleccion.insert_one(tweet).inserted_id

tweet = {
"text": "choreographing is hard : (",
"genero": "mujer"}
post_id = coleccion.insert_one(tweet).inserted_id


tweet = {
"text": "@oohdawg_ Hi liv :))",
"genero": "mujer"}
post_id = coleccion.insert_one(tweet).inserted_id


tweet = {
"text": "@izzkamilhalda lols. :D",
"genero": "mujer"}
post_id = coleccion.insert_one(tweet).inserted_id


tweet = {
"text": "@Charliescoco @reeceftcharliie @SimonCowell too late :(",
"genero": "mujer"}
post_id = coleccion.insert_one(tweet).inserted_id


tweet = {
"text": "i went in the sea and now have a massive fucking rash all over my body and it's the most painful thing ever i want to go home :((",
"genero": "hombre"}
post_id = coleccion.insert_one(tweet).inserted_id


tweet = {
"text": "@Mess0019 Well I am sure your work day is over before mine :(",
"genero": "mujer"}
post_id = coleccion.insert_one(tweet).inserted_id


tweet = {
"text": "@sehunshinedaily if it makes u feel better i never have nor will see anyone in kpop in the flesh :D",
"genero": "mujer"}
post_id = coleccion.insert_one(tweet).inserted_id


tweet = {
"text": "HUNGRY :-(",
"genero": "mujer"}
post_id = coleccion.insert_one(tweet).inserted_id


tweet = {
"text": "so i'll be getting my cement cast tomorrow :(",
"genero": "hombre"}
post_id = coleccion.insert_one(tweet).inserted_id


tweet = {
"text": "Heyyyyy i wanted to see yeols solo danceeeeee :((((((((((((",
"genero": "mujer"}
post_id = coleccion.insert_one(tweet).inserted_id


tweet = {
"text": "@Uber all ice cream vehicles are busy :(",
"genero": "mujer"}
post_id = coleccion.insert_one(tweet).inserted_id


tweet = {
"text": "@1DMspree @njhla omfg harry pls bae :( don't ignore me",
"genero": "hombre"}
post_id = coleccion.insert_one(tweet).inserted_id


tweet = {
"text": "harumph it's all soggy here :( was hoping to go do some more weeding",
"genero": "mujer"}
post_id = coleccion.insert(tweet).inserted_id


tweet = {
"text": "@NintendoUK @InTheLittleWood I want his game!!! But the last Nintendo I bought was a wii :(",
"genero": "mujer"}
post_id = coleccion.insert(tweet).inserted_id


tweet = {
"text": "look at his cheeks so squishy :( \ncutest ;( http://t.co/qEV0hix7JZ",
"genero": "mujer"}
post_id = coleccion.insert(tweet).inserted_id


tweet = {
"text": "@IncreaseEnergy Thank you :)",
"genero": "hombre"}
post_id = coleccion.insert(tweet).inserted_id


tweet = {
"text": "I like your style sumedh ..  @Beatking_Sumedh :)",
"genero": "mujer"}
post_id = coleccion.insert(tweet).inserted_id


tweet = {
"text": "English weather needs to fix up :((",
"genero": "mujer"}
post_id = coleccion.insert(tweet).inserted_id


tweet = {
"text": "I'm not ready to work yet :(",
"genero": "mujer"}
post_id = coleccion.insert(tweet).inserted_id

tweet = {
"text": "the weather is set for more sleep but responsibilities. :-(",
"genero": "hombre"}
post_id = coleccion.insert(tweet).inserted_id


tweet = {
"text": "@batesm0t3l Hi there, I've spoken with the store who have advised they do have a PayPoint and that card can be topped up :) Thanks, Beth",
"genero": "mujer"}
post_id = coleccion.insert(tweet).inserted_id


tweet = {
"text": "Happy happy birthday TO ME!! \nHappy happy birthday To ME!! :) https://t.co/2cgXNdP00h",
"genero": "hombre"}
post_id = coleccion.insert(tweet).inserted_id


tweet = {
"text": "i think someone hacked my other acc :(",
"genero": "hombre"}
post_id = coleccion.insert(tweet).inserted_id


#Verificar que se creo la coleccion al enlistar las colecciones en la base de datos
nombres = db.collection_names(include_system_collections=False)

#Consultar un documento con find_one()
uno = coleccion.find({"genero": "mujer"})

print uno