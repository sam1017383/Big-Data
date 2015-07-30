from imdb import IMDb
ia = IMDb()

the_matrix = ia.get_movie('0133093')
print the_matrix['director']

for person in ia.search_person('Mel Gibson'):
	print person.personID, person['name']
