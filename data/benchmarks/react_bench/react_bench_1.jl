using Reactive
using DataFrames
using SimpleBench
using GeometryTypes
using GLAbstraction

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
	for i=1:50
		push!(val_r, i)
	end
	rr
end
function test1(N)
	res = 0.0
	for i=1:50
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
		@benchmark df :unrolled test1(i+500)
		@benchmark df :react test2(i+500)
	end
	df
end
bench_data = test()
df = convert(DataFrame, bench_data)
writetable("react_bench_1.csv", df)
