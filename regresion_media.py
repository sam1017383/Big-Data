
import matplotlib.pyplot as plt


x = [67.0,52.0,56.0,66.0,65.0]

y = [481.0, 292.0, 357.0, 396.0, 345.0]

def graficar():
	plt.plot(x, y, 'ro')
	plt.axis([0, 70, 0, 500])
	plt.show()




def media(lista):
	avg = 0.0
	for each in lista:
		avg += each/len(lista)
	return avg


print media(x)

graficar()
