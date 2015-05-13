# -*- coding: utf-8 -*-
# vispy: gallery 30
# -----------------------------------------------------------------------------
# Copyright (c) 2014, Vispy Development Team. All Rights Reserved.
# Distributed under the (new) BSD License. See LICENSE.txt for more info.
# -----------------------------------------------------------------------------
"""
This example demonstrates the use of the SurfacePlot visual.
"""

import sys
import numpy as np

from vispy import app, scene
from vispy.util.filter import gaussian_filter

canvas = scene.SceneCanvas(keys='interactive')
view = canvas.central_widget.add_view()
view.camera = scene.TurntableCamera(up='z')

# Simple surface plot example
# x, y values are not specified, so assumed to be 0:50
N = 100

i = np.float32(1.0)
z = np.fromfunction(lambda x, y: np.sin(np.sqrt((((x+1/N)-0.5)*i)*(((x+1/N)-0.5)*i) + (((y+1/N)-0.5)*i)*(((y+1/N)-0.5)*i)))/np.sqrt((((x+1/N)-0.5)*i)*(((x+1/N)-0.5)*i) + (((y+1/N)-0.5)*i)*(((y+1/N)-0.5)*i)), (N, N), dtype=np.float32)

p1 = scene.visuals.SurfacePlot(z=z, color=(0.5, 0.5, 1, 1), shading='smooth')
p1.transform = scene.transforms.AffineTransform()
p1.transform.scale([1/49., 1/49., 1.0])
p1.transform.translate([-0.5, -0.5, 0])

view.add(p1)

# Add a 3D axis to keep us oriented
axis = scene.visuals.XYZAxis(parent=view.scene)
i = np.float32(1.0)
def update(ev):
	global p1
	global i
	i += np.float32(1.0)
	p1.set_data(z=np.fromfunction(lambda x, y: np.sin(np.sqrt((((x/N)-0.5)*i)*(((x/N)-0.5)*i) + (((y/N)-0.5)*i)*(((y/N)-0.5)*i)))/np.sqrt((((x/N)-0.5)*i)*(((x/N)-0.5)*i) + (((y/N)-0.5)*i)*(((y/N)-0.5)*i)), (N, N), dtype=np.float32))

timer = app.Timer()
timer.connect(update)
timer.start(0)



if __name__ == '__main__':
    canvas.show()
    p1.set_data(z = gaussian_filter(np.random.normal(size=(100, 100)), (1, 1)) * 10)
    if sys.flags.interactive == 0:
        app.run()
