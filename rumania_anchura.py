

rumania = {"arad": {"timisoara":118, "sibiu":140, "zerind":75 },
"timisoara": {"arad":118, "lugoj":111},
"sibiu": {"arad": 140, "oradea":151, "fagaras":99, "rimnicu":80},
"zerind": {"arad":75, "oradea":71},
"lugoj": {"timisoara":111, "mehadia":70},
"oradea": {"zerind":71, "sibiu":151},
"fagaras": {"bucharest":211, "sibiu":99},
"rimnicu": {"sibiu":80, "craiova":146, "pitesti":97},
"mehadia": {"lugoj":70, "drobeta":75},
"bucharest": {"giurgiu":90, "pitesti":101, "fagaras":211},
"craiova": {"rimnicu":146, "drobeta":120, "pitesti":138},
"pitesti": {"rimnicu":97, "craiova":138, "bucharest":101},
"drobeta": {"mehadia":75, "craiova":120}
}



costos_acumulados = [("arad",10000),
("timisoara",10000),
("sibiu",10000),
("zerind",10000),
("lugoj",10000),
("oradea",10000),
("fagaras",10000),
("rimnicu",10000),
("mehadia",10000),
("bucharest",10000),
("craiova",10000),
("pitesti",10000),
("drobeta",10000)]

costos_dummy = [("arad",0),
("timisoara",10000),
("sibiu",140),
("zerind",10000),
("lugoj",10000),
("oradea",10000),
("fagaras",239),
("rimnicu",10000),
("mehadia",10000),
("bucharest",450),
("craiova",10000),
("pitesti",10000),
("drobeta",10000)]

def planeacion_bfs(G, nodo_inicio, nodo_final):
	print "recorre el grafo hasta encontrar un camino a la meta"
	return "regresar camino como secuencia de nodos"

def grado_nodo(G, nodo):
	if nodo in G.keys():
		return len(G[nodo].keys())

def explorar_nodo(G, nodo):
	if nodo in G.keys():
		return G[nodo].keys()



print grado_nodo(rumania, "arad")
print explorar_nodo(rumania, "bucharest")