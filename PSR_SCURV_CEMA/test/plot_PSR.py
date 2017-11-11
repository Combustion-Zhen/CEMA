import numpy as np
import matplotlib.pyplot as plt

psr = np.genfromtxt('psr.out',usecols=(1,))
mod = np.genfromtxt('PSR_CEMA.op')

fig, ax = plt.subplots()

plt.scatter(1/mod[:,0],psr,c=mod[:,1])

ax.set_xscale('log')
ax.set_xlim(1.e-5,0.01)

plt.show()
