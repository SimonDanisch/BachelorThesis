using GLFW
import ModernGL

GLFW.Init()
window = GLFW.CreateWindow(640, 480, "Test Window")
GLFW.MakeContextCurrent(window)

module StagedFunction
import ModernGL
stagedfunction glBindBuffer(target::Cuint, buffer::Cuint)
	ptr = ModernGL.getprocaddress("glBindBuffer")
	:(ccall($ptr, Void, (Cuint, Cuint), target, buffer))
end
stagedfunction glGenBuffers(n::Cint, buffers::Vector{Cuint})
	ptr = ModernGL.getprocaddress("glGenBuffers")
	:(ccall($ptr, Void, (Cint, Ptr{Cuint}), n, buffers))
end
stagedfunction glGetStringi(name::Cuint, index::Cuint)
	ptr = ModernGL.getprocaddress("glGetStringi")
	:(ccall($ptr, Ptr{Cchar}, (Cuint, Cuint), name, index))
end
stagedfunction glClearColor(red::Float32, green::Float32, blue::Float32, alpha::Float32)
	ptr = ModernGL.getprocaddress("glClearColor")
	:(ccall($ptr , Void, (Float32, Float32, Float32, Float32), red, green, blue, alpha))
end

end

import StagedFunction

macro bench_call(results, funcall)
	testfun = gensym()

	funname = string(funcall.args[1])
	quote
		function $testfun()
			t0 = time_ns()
			for i=1:10000000
				$funcall
			end
			t1 = time_ns()
			(t1-t0)/10^6 # milliseconds
		end
		for i=1:100
			bench_result = $testfun()
			push!(get!($results, $funname, Float64[]), bench_result)
		end
	end
end
buff = zeros(Cuint, 10)
ModernGL.glGenBuffers(Cint(10), buff)
const b = buff[1]
const a =  Cuint(0)
benches = Dict{Any, Vector{Float64}}()

# warmup the jit
ModernGL.glClearColor(0.0f0, 0.0f0, 1.0f0, 0.0f0)
ModernGL.glGetStringi(ModernGL.GL_EXTENSIONS, a)
ModernGL.glBindBuffer(ModernGL.GL_ARRAY_BUFFER, b)

StagedFunction.glClearColor(0.0f0, 0.0f0, 1.0f0, 0.0f0)
StagedFunction.glGetStringi(ModernGL.GL_EXTENSIONS, a)
StagedFunction.glBindBuffer(ModernGL.GL_ARRAY_BUFFER, b)

@bench_call benches ModernGL.glClearColor(0.0f0, 0.0f0, 1.0f0, 0.0f0)
@bench_call benches ModernGL.glGetStringi(ModernGL.GL_EXTENSIONS, a)
@bench_call benches ModernGL.glBindBuffer(ModernGL.GL_ARRAY_BUFFER, b)

@bench_call benches StagedFunction.glClearColor(0.0f0, 0.0f0, 1.0f0, 0.0f0)
@bench_call benches StagedFunction.glGetStringi(ModernGL.GL_EXTENSIONS, a)
@bench_call benches StagedFunction.glBindBuffer(ModernGL.GL_ARRAY_BUFFER, b)


for (key, value) in benches
	println("\"", key, "\" => ", value, ",")
end


GLFW.DestroyWindow(window);
GLFW.Terminate()