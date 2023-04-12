import matplotlib.pyplot as plt
import numpy as np
import scipy.optimize as opt

# Data for plotting
def CL(x):
	return np.pi*np.sin(2*x)

def LiftBalance(a, ai, Cr):
	#return np.arctan( CL(a - ai)*Cr/np.pi ) - ai
	return np.cos(ai)*CL(a - ai)*Cr/(8*np.pi) - np.tan(ai)**2

def inFlow(a, Cr):
	def rootFunc(x): 
		return [LiftBalance(a, x[0], Cr)]
		
	ai = opt.fsolve(rootFunc, [a])
	return CL(a - ai)

# Generate data
t = np.arange(0.0, np.radians(90), 0.01)
s = []

for i in t:
	Cr = 0.8 # Cr > 3.5 causes initial slope to grow
	s.append(inFlow(i, Cr))
	
# Display plot
fig, ax = plt.subplots()
ax.plot(t, s)

ax.set(xlabel='Angle of attack (deg)', ylabel='Lift coefficient', title='Actuator disk induced flow')
ax.grid()

plt.show()

# Observation: 
#	Rotation has similar effect as decreasing the aspect ratio

# == Derivation ==
# Ly = cos(a)*L
# L = 0.5*p*Aw*V^2*Cl
# L = 0.5*p*As*(V2^2 - V1^2)
# dV^2 = 4*Vi(Vi - V1)
# Aw = S*C
# As = 2*pi*s*r

# L = L -> cos(a)*Aw*V^2*Cl = As*4*Vi*(Vi - V1)
# cos(a)*(C/r)*(Cl/2*pi)*V^2 = 4*Vi(Vi - V1)
# Vi = V*tan(a)
# dV^2 = 4*V^2*(tan(a) - sin(o))*tan(a)

# cos(a)(C/r)(Cl/2pi) =  4(tan(a) - sin(o))*tan(a)
# cos(a)(C/r)*(Cl(a)/8pi) + sin(o)*tan(a) = tan(a)^2 

# == Slope equations ==
# s = AR/(2 + AR)
