import OpenGL.GL as gl
import numpy as np
import cyglfw3 as glfw
import sys
import time
glfw.Init()

# version hints
glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 3)
glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 3)
glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, gl.GL_TRUE)
glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

# make a window
width, height = 640, 480
aspect = width/float(height)
win = glfw.CreateWindow(width, height, "test")
# make context current
glfw.MakeContextCurrent(win)


def clearcolor( ):
	t = time.time()
	for x in xrange(1,10000):
		gl.glClearColor(1,1,1,1)
	t = (time.time()-t) * 1000
	return t

def getstring( ):
	t = time.time()
	for x in xrange(1,10000):
		gl.glGetStringi(gl.GL_EXTENSIONS, 0)
	t = (time.time()-t) * 1000
	return t


def bindbuffer(buff):
	t = time.time()
	for x in xrange(1,10000):
		gl.glBindBuffer(gl.GL_ARRAY_BUFFER, buff)
	t = (time.time()-t) * 1000
	return t

buff = gl.glGenBuffers(1)

print("\"Py.glBindBuffer\" => [")
for x in xrange(1,100):
	sys.stdout.write("{0},".format(bindbuffer(buff)))
print("],")

print("\"Py.glGetStringi\" => [")
for x in xrange(1,100):
	sys.stdout.write("{0},".format(getstring()))
print("],")

print("\"Py.glClearColor\" => [")
for x in xrange(1,100):
	sys.stdout.write("{0},".format(clearcolor()))
print("]")



glfw.Terminate()

