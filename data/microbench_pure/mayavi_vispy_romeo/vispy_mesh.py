# -*- coding: utf-8 -*-
# Copyright (c) 2014, Vispy Development Team.
# Distributed under the (new) BSD License. See LICENSE.txt for more info.

"""
Simple demonstration of Mesh visual.
"""
import sys
import numpy as np
from vispy import scene
from vispy import app, gloo, visuals, io, geometry
from vispy.geometry import create_sphere
from vispy.visuals.transforms import (STTransform, AffineTransform,
                                      ChainTransform)

canvas      = scene.SceneCanvas(keys='interactive')
canvas.view = canvas.central_widget.add_view()

verts, faces, normals, _lol = io.read_mesh("Rider.obj")
mesh = scene.visuals.Mesh(vertices=verts, shading='smooth', faces=faces)

canvas.view.add(mesh)
canvas.view.camera = scene.TurntableCamera()

canvas.view.camera.set_range((-20, 20), (-20, 20), (-20, 20))
canvas.show()

if __name__ == '__main__':
    if sys.flags.interactive != 1:
        canvas.app.run()