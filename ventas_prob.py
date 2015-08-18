mat_prob = {"alto": {"alto":0.971, "medio":0.029, "bajo": 0}, "medio": {"alto":0.145, "medio":0.778, "bajo": 0.077}, "bajo": {"alto":0, "medio":0.508, "bajo": 0.492}}

obs = ["alto", "medio", "bajo", "bajo"]

def obtener_transiciones(obs):
	transiciones = []
	for i in range(0,len(obs)-1):
		transicion = [obs[i], obs[i+1]]
		transiciones.append(transicion)
	return transiciones



def medir_prob_sec(secuencia, mat_prob):
	transiciones = obtener_transiciones(secuencia)
	print "secuencia de transiciones: ", transiciones
	print "primera transicion de:", transiciones[0][0], "   a: ", transiciones[0][1]
	p = mat_prob[transiciones[0][0]][transiciones[0][1]]
	print "primer valor: ", p
	transiciones = transiciones[1:len(transiciones)]
	print "el resto de las transiciones: ", transiciones
	for cada_transicion in transiciones:
		i = mat_prob[cada_transicion[0]][cada_transicion[1]]
		print "probabilidad es ", p, " * ", i
		p = p * i

	return p



proba = medir_prob_sec(obs, mat_prob)

print "La probabilidad de la secuencia es: ", proba