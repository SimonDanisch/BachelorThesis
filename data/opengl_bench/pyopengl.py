import OpenGL.GL as gl
import OpenGL.GLUT as glut
import time
import sys
print (sys.version) 
glut.glutInit()
glut.glutInitDisplayMode(glut.GLUT_DOUBLE | glut.GLUT_RGBA)
glut.glutCreateWindow('Hello world!')
glut.glutReshapeWindow(512,512)


def clearcolor( ):
	t = time.time()
	for x in xrange(1,10000000):
		gl.glClearColor(1,1,1,1)
	t = (time.time()-t) * 1000
	return t

def getstring( ):
	t = time.time()
	for x in xrange(1,10000000):
		gl.glGetStringi(gl.GL_EXTENSIONS, 0)
	t = (time.time()-t) * 1000
	return t


def bindbuffer(buff):
	t = time.time()
	for x in xrange(1,10000000):
		gl.glBindBuffer(gl.GL_ARRAY_BUFFER, buff)
	t = (time.time()-t) * 1000
	return t

buff = gl.glGenBuffers(1)

print("\"Py.glBindBuffer\" => [")
for x in xrange(1,100):
	sys.stdout.write("{0},".format(bindbuffer(buff)))
print("],")

"""
print("\"Py.glGetStringi\" => [")
for x in xrange(1,100):
	sys.stdout.write("{0},".format(getstring()))
print("],")

print("\"Py.glClearColor\" => [")
for x in xrange(1,100):
	sys.stdout.write("{0},".format(clearcolor()))
print("]")

"""