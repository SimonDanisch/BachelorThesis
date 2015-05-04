import sys
import numpy as np
import vispy
from vispy import app, scene


canvas = scene.SceneCanvas(keys='interactive')
view = canvas.central_widget.add_view()
view.set_camera('turntable', mode='perspective', up='z', distance=2,
                azimuth=30., elevation=30.)

## Simple surface plot example
## x, y values are not specified, so assumed to be 0:50
sin = np.sin
z = np.array([[sin(x/50)*sin(y/50)/3 for x in xrange(1,1024)]
                 for y in xrange(1,1024)])
p1 = scene.visuals.SurfacePlot(z=z, color=(0.5, 0.5, 1, 1), shading='smooth')

p1.transform = scene.transforms.AffineTransform()
p1.transform.scale([1/49., 1/49., 0.02])
p1.transform.translate([-0.5, -0.5, 0])

view.add(p1)

# Add a 3D axis to keep us oriented
axis = scene.visuals.XYZAxis(parent=view.scene)

if __name__ == '__main__':
    canvas.show()
    if sys.flags.interactive == 0:
        app.run()