from math import log10

print "HOLA".lower()

for car in "HOLA":
	print car

nom_l = list("LALO")

for i in range(0,len(nom_l)-1):
	print "primero: ", nom_l[i], "segundo: ", nom_l[i+1]

print log10(0.00001)

a = {"a": 0, "b":1, "etc":2}


print "-------------------------------"
for cada_llave in a.keys():
	print "llave: ", cada_llave, "valor: ", a[cada_llave]