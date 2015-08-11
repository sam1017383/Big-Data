from cassandra.cluster import Cluster
	

def filtrar_por_periodo(tabla, per):
	resultado = []
	consulta = session.execute("SELECT * FROM " + tabla + ";")
	for cada_ticket in consulta:
		if cada_ticket.periodo == per:
			resultado.append({"id_obj": cada_ticket.id_obj, "producto": cada_ticket.producto, "importe": cada_ticket.importe})
	return resultado


def verificar_reclamacion(idobj):
	consulta = session.execute("SELECT * FROM reclamaciones;")
	for cada_ticket in consulta:
		if cada_ticket.id_obj == idobj:
			return True
	return False


cluster = Cluster()
print "Iniciando sesion..."
session = cluster.connect('ejemplo')
print "Revisando keyspaces en la DB..."
keyspaces = session.execute("SELECT * FROM system.schema_keyspaces;")
for k in keyspaces:
	print k.keyspace_name


#Consulta las adquisiciones del periodo 1
adquisiciones_periodo_1 = filtrar_por_periodo("adquisiciones",1)
print adquisiciones_periodo_1


#Consulta las ventas del periodo 4
ventas_periodo_4 = filtrar_por_periodo("ventas",4)
print ventas_periodo_4


#Consulta si el objeto 1 fue reclamado
print "Objeto 1 fue reclamado?", verificar_reclamacion(1)





