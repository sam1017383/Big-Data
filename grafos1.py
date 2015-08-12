# -*- coding: utf-8 -*-

import matplotlib.pyplot as plt

import networkx as nx




def explore_graph(G):
	for nA, nbrs in G.adjacency_iter():
		for nB, att in nbrs.items():
			rel = att['label']


def draw_graph(G):
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
			rel = att['costo']
			edges_dict[(nA,nB)]=rel

	nx.draw_networkx_edge_labels(G,pos, edges_dict)
	plt.show()







G = nx.DiGraph()

G.add_nodes_from(['a','b','c','d','e','f','g','h'])

G.add_edge('a','b', {'costo':1})
G.add_edge('a','c', {'costo':1})
G.add_edge('b','f', {'costo':1})
G.add_edge('b','e', {'costo':1})
G.add_edge('a','d', {'costo':1})
G.add_edge('c','g', {'costo':1})
G.add_edge('c','h', {'costo':1})

print "¿Hay camino de A a F? ", nx.has_path(G, 'a', 'f')

print "¿Hay camino de E a F? ", nx.has_path(G, 'e', 'f')

draw_graph(G)