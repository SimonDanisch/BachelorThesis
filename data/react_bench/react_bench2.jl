using Reactive
using SimpleBench
#using DataFrames
using GeometryTypes
using GLAbstraction
#using Gadfly


vec3(x) = Vector3(x)


function compute_optim(val, N)
    a = val
    b = bf(a, 23.0)
    c = bf(a, 8.0)
    f = ff(a)
    d = vec3(b)
    e = vec3(c)
    g = vec3(f)

    m  = translationmatrix(d)
    m2 = translationmatrix(e)

    m3 = m*m2
end

bf(a,c) = a/c
begin 
    local accum = 0.0
    ff(a) = accum += a
end

function compute_react(val, n)
	a = val
    b = lift(/, a, Input(23.0))
    c = lift(/, a, Input(8.0))
    f = foldl(+, 0.0, b)
 
    d = lift(vec3, b)
    e = lift(vec3, c)
    g = lift(vec3, f)
 
    m = lift(translationmatrix, d)
    m2 = lift(translationmatrix, e)
 
    m3 = lift(*, m, m2)

end
function test2(N)
	val_r = Input(1)
	rr = compute_react(val_r, Input(N))
	for i=1:N
		push!(val_r, i)
	end
	rr
end
function test1(N)
	res = 0.0
	for i=1:N
		res = compute_optim(i, N)
	end
	res
end


function test()
	df = Dict{Symbol, Vector{BenchData}}()
	r1 = test1(10) # start jit with some random value
	r2 = test2(10)
	@assert r1 == r2.value
	for i=1:100
		@benchmark df :unrolled test1(10^4)
		@benchmark df :react test2(10^4)
	end
	println(map(x->x.time_ns, df[:unrolled]))
	println("####################################################")
	println(map(x->x.time_ns, df[:react]))
	df2 = convert(DataFrame, df)
end
data=test()

unrolled 	= data[data[:Name] .== :unrolled, :]
react 		= data[data[:Name] .== :react, :]
data[:Difference] = zeros(length(data[:Time]))
for i=1:length(data[:Time])
	
	data[:Difference][i] = 
p = plot(
	layer(unrolled, x=:Trial, y=:Time, color=:BenchmarkName, Geom.line),
	layer(react, 	x=:Trial, y=:Time, color=:BenchmarkName, Geom.point),
	)
	

draw(PDF(joinpath("C:\\", "Users","Sim", "Desktop", "BachelorThesis", "graphics", "react_bench2.pdf"), 6inch, 4inch), p)
