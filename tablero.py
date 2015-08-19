
tablero_inicial = {
"A": {"A":7, "B":2, "C":4},
"B": {"A":5, "B":0, "C":6},
"C": {"A":8, "B":3, "C":1},
}

tablero_inicial_copia = {
"A": {"A":7, "B":2, "C":4},
"B": {"A":5, "B":0, "C":6},
"C": {"A":8, "B":3, "C":1},
}

tablero_final = {
"A": {"A":0, "B":1, "C":2},
"B": {"A":3, "B":4, "C":5},
"C": {"A":6, "B":7, "C":8},
}



def verificar_meta(tablero_a, tablero_b):
	iguales = True
	for cada_fila in tablero_a:
		for cada_columna in tablero_b:
			iguales = iguales and (tablero_a[cada_fila][cada_columna] == tablero_b[cada_fila][cada_columna])
	return iguales


def ubicar_vacio(tablero):
	for cada_fila in tablero:
		for cada_columna in tablero:
			if tablero[cada_fila][cada_columna] == 0:
				return [cada_fila, cada_columna]

	return ["Z", "Z"]

def mover_arriba(tablero, casilla):
	if tablero[casilla[0]][casilla[1]]

print verificar_meta(tablero_inicial, tablero_inicial_copia)


print ubicar_vacio(tablero_final)
