#include "stdafx.h"
//Include GLEW
#include <GL/glew.h>

//Include GLFW
#include <GLFW/glfw3.h>

//Include the standard C++ headers
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <chrono>      /* time_t, struct tm, difftime, time, mktime */

using namespace std::chrono;
using namespace std;


void printresult(char * name, double results[]){
	cout << name << "=>[" << endl;
	for (int k = 0; k < 100; k++)
	{
		cout << results[k] << ", ";
	}
	cout << "]," << endl;
}
void bench()
{
	
	GLuint buff[10];
	double result[100];
	for (int k = 0; k < 100; k++)
	{ 
		high_resolution_clock::time_point t0 = high_resolution_clock::now();
		for (int i = 1; i <= 10000000; i++){
			glClearColor(1.f, 1.f, 1.f, 1.f);
		}
		high_resolution_clock::time_point t1 = high_resolution_clock::now();
		result[k] = std::chrono::duration_cast<std::chrono::milliseconds>(t1 - t0).count();
	}
	printresult("glClearColor", result);
	glGenBuffers(10, &buff[0]);
	GLuint extension = 0;
	for (int k = 0; k < 100; k++)
	{
		high_resolution_clock::time_point t0 = high_resolution_clock::now();
		for (int i = 1; i <= 10000000; i++){
			glGetStringi(GL_EXTENSIONS, extension);
		}
		high_resolution_clock::time_point t1 = high_resolution_clock::now();
		result[k] = std::chrono::duration_cast<std::chrono::milliseconds>(t1 - t0).count();
	}
	printresult("glGetStringi", result);

	GLuint buffer = buff[0];
	for (int k = 0; k < 100; k++)
	{
		high_resolution_clock::time_point t0 = high_resolution_clock::now();
		for (int i = 1; i <= 10000000; i++){
			glBindBuffer(GL_ARRAY_BUFFER, buffer);
		}
		high_resolution_clock::time_point t1 = high_resolution_clock::now();
		result[k] = std::chrono::duration_cast<std::chrono::milliseconds>(t1 - t0).count();
	}
	printresult("glBindBuffer", result);

}
int main(void)
{

	//Initialize GLFW
	glfwInit();
	//Declare a window object
	GLFWwindow* window;
	//Create a window and create its OpenGL context
	window = glfwCreateWindow(640, 480, "Test Window", NULL, NULL);
	//This function makes the context of the specified window current on the calling thread. 
	glfwMakeContextCurrent(window);

	//Initialize GLEW
	GLenum err = glewInit();

	//If GLEW hasn't initialized
	if (err != GLEW_OK)
	{
		fprintf(stderr, "Error: %s\n", glewGetErrorString(err));
		return -1;
	}
	
	bench();


	do
	{
		glfwPollEvents();
	} while (!glfwWindowShouldClose(window));
	//Close OpenGL window and terminate GLFW
	glfwDestroyWindow(window);
	//Finalize and clean up GLFW
	glfwTerminate();

	exit(EXIT_SUCCESS);
}