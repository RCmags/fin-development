import matplotlib.pyplot as plt
import numpy as np
import scipy.optimize as opt

# induced flow iterations
def inFlow(a, AR):
	ai = 0
	for i in range(1,20):
		cl = np.pi*np.sin(2*(a - ai)) # np.sin
		#term = 2*(AR+4)/(AR**2 + 4*AR + 8)	# 2nd order approximation
		term = 2/(AR + 2) 					# Small AR approximation
		#term = 1/AR						# Lifting line
		ai = np.arctan( cl*term/(np.pi) )
	return cl

# Generate data
t = np.arange(0.0, np.radians(90), 0.001)
s = []

for i in t:
	AR = 2.5 # AR < 2.5 causes initial slope to grow
	s.append(inFlow(i, AR))

# Display plot
fig, ax = plt.subplots()
ax.plot(t, s)

ax.set(xlabel='Angle of attack (deg)', ylabel='Lift coefficient', title='Planar induced flow')
ax.grid()

plt.show()
