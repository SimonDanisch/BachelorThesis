import numpy
import mayavi
from mayavi.mlab import *
#max still 90.000
#animated still 2500
N = 90000

x 	= numpy.random.rand(N) * 20.0
y 	= numpy.random.rand(N) * 20.0
z 	= numpy.random.rand(N) * 20.0

def generate(i):
	return x*i,y*i,z*i
	 
particles = points3d(x, y, z, colormap="copper", scale_factor=.08, mode="cube")

"""
@mayavi.mlab.animate(delay=10)
def anim():
    f = mayavi.mlab.gcf()
    i = 1.0
    while True:
    	x,y,z = generate(i)
    	particles.mlab_source.set(x=x, y=y, z=z)
        i = i+0.001
        yield


anim()
"""
mayavi.mlab.show()