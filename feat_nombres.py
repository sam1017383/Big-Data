#!/usr/bin/env python

import matplotlib.pyplot as plt



names = [
"ADELFRIED",
"BERNADETTE",
"CARLEIGH",
"DAGOBERT",
"ELISABETH",
"FLOY",
"GILBERT",
"HASTINGS",
"ILSE",
"JOHANN",
"KELLEN",
"LORING",
"MAUD",
"NEVIN",
"ODELL",
"PENROD",
"RITTER",
"STEIN",
"THEOBOLD",
"ULBRECHT",
"VILHELM",
"WARNER",
"ZELIG"
]

nombres = [
"FABIOLA",
"FEDERICO",
"ADOLFO",
"ALEJANDRO",
"ARACELI",
"AURORA",
"CAMILA",
"CONSUELO",
"GUILLERMO",
"GLORIA",
"MATEO",
"MAXIMILIANO",
"WILFREDO",
"DANIEL",
"DOLORES",
"JACINTO",
"JAIME",
"JULIANA",
"REBECA",
"RODRIGO",
"ELENA",
"VALERIA",
"ERNESTO",

]


def obtener_caracteristicas(lista_nombres):
	X = []
	Y = []
	for cada_nombre in lista_nombres:
		print "cada nombre: ", cada_nombre
		#longitud = 
		#vocales = 
		#print "VOCALES: ", vocales
		
		#X.append(longitud)
		#Y.append(voc_con)
	return X, Y


X_e, Y_e = obtener_caracteristicas(nombres)
X_a, Y_a = obtener_caracteristicas(names)

print "coeficiente de espanol: ", Y_e
print "coeficiente de aleman: ", Y_a

print 2 in [1,2,3,4,5]
print 6 in [1,2,3,4,5]

plt.plot(X_e, Y_e, 'bo')
plt.plot(X_a, Y_a, 'ro')
plt.axis([0, 15, -3, 3])
plt.show()


