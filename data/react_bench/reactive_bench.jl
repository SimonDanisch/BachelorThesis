using Reactive
using SimpleBench
using DataFrames

function compute_optim(val, N)
	m = Float64[sin(val)*x*y for x=1:N, y=1:N]
	mn = mean(m)
	m = m-mn
	m = m+m
	m = m.*m
	return sum(m)
end

function init(i, N)
	Float64[sin(i)*x*y for x=1:N, y=1:N]
end
function compute_react(val, n)
	m 	= lift(init, val, n)
	mn 	= lift(mean, m)
	m 	= lift(-, m, mn)
	m 	= lift(+, m, m)
	m 	= lift(.*, m, m)
	r 	= lift(sum, m)
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
	for i=1:10:500
		@benchmark df :unrolled test1(i)
		@benchmark df :react test2(i)
	end
	println(df)
	df2 = convert(DataFrame, df)
end
data=test()

p = plot(
	layer(data[data[:Name] .== :unrolled, :], x=:Trial, y=:Time, color=:BenchmarkName, Geom.line),
	layer(data[data[:Name] .== :react, :], x=:Trial, y=:Time, color=:BenchmarkName, Geom.point),
	)
	

draw(PDF(joinpath("C:\\", "Users","Sim", "Desktop", "BachelorThesis", "graphics", "react_bench1.pdf"), 6inch, 4inch), p)
