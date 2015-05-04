import numpy
from mayavi.mlab import *

def test_surf():
    """Test surf on regularly spaced co-ordinates like MayaVi."""
    def f(x, y):
        sin, cos = numpy.sin, numpy.cos
        return sin(x/50.0)*sin(y/50.0)/3.0

    x, y = numpy.mgrid[1:1024, 1:1024]
    s = surf(x, y, f)
    #cs = contour_surf(x, y, f, contour_z=0)
    return s