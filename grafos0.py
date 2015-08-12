import matplotlib.pyplot as plt

import networkx as nx


G = nx.Graph()

G.add_nodes_from([1,2,3,4])

G.add_edge(1,2)
G.add_edge(1,3)
G.add_edge(1,4)


nx.draw(G)
plt.show()


G.remove_node(2)


nx.draw(G)
plt.show()


G.remove_edge(1,3)

nx.draw(G)
plt.show()
