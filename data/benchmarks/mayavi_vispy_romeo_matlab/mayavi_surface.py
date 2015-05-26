import numpy as np
import mayavi.mlab as mlab


N = 100
i = 1.0
z = np.fromfunction(lambda x, y: np.sin(np.sqrt((((x+1/N)-0.5)*i)*(((x+1/N)-0.5)*i) + (((y+1/N)-0.5)*i)*(((y+1/N)-0.5)*i)))/np.sqrt((((x+1/N)-0.5)*i)*(((x+1/N)-0.5)*i) + (((y+1/N)-0.5)*i)*(((y+1/N)-0.5)*i)), (N, N), dtype=np.float32)

s = mlab.surf(z, warp_scale="auto")

@mlab.animate(delay=10)
def anim():
    f = mlab.gcf()
    i = 1.0
    while True:
        s.mlab_source.scalars = np.fromfunction(lambda x, y: np.sin(np.sqrt((((x/N)-0.5)*i)*(((x/N)-0.5)*i) + (((y/N)-0.5)*i)*(((y/N)-0.5)*i)))/np.sqrt((((x/N)-0.5)*i)*(((x/N)-0.5)*i) + (((y/N)-0.5)*i)*(((y/N)-0.5)*i)), (N, N), dtype=np.float32)
        i = i+1.0
        yield


anim()
mlab.show()