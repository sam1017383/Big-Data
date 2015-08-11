
import matplotlib.pyplot as plt


x = [67,52,56,66,65]

y = [481, 292, 357, 396, 345]

def graficar():
	plt.plot(x, y, 'ro')
	plt.axis([0, 70, 0, 500])
	plt.show()

graficar()