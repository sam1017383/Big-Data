# -*- coding: utf-8 -*-

import matplotlib.pyplot as plt

import networkx as nx



def recorrer_grafo(G):
	for nA, nbrs in G.adjacency_iter():
		for nB, att in nbrs.items():
			#rel = att['label']
			print "explorando nodo: ", nB
			print "Vecindario: ", G.neighbors(nB)


def grados(G):
	grados = []
	for nA, nbrs in G.adjacency_iter():
		for nB, att in nbrs.items():
			grados.append({nB : len(G.neighbors(nB))})
	return grados


def graficar(G):
	plt.figure()
	pos=nx.spring_layout(G) # positions for all nodes

	# nodes
	nx.draw_networkx_nodes(G,pos,node_size=2000, node_color="red")

	# edges
	nx.draw_networkx_edges(G,pos,width=1,alpha=0.7,edge_color='black')

	nx.draw_networkx_labels(G,pos,font_size=10,font_family='sans-serif')

	edges_dict = {}
	for nA, nbrs in G.adjacency_iter():
		for nB, att in nbrs.items():
			edges_dict[(nA,nB)]="relacion"

	nx.draw_networkx_edge_labels(G,pos, edges_dict)
	plt.show()







G = nx.DiGraph()

G.add_nodes_from(['a','b','c','d','e','f'])

G.add_edge('a','b')
G.add_edge('a','c')
G.add_edge('b','f')
G.add_edge('b','e')
G.add_edge('d','a')
G.add_edge('c','d')
G.add_edge('c','b')

recorrer_grafo(G)
print grados(G)
graficar(G)