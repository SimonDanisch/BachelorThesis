using PyPlot, PyCall, DatFrames
df = readtable("react_bench_1.csv")
figure()

unrolled 			= df[df[:Name] .== "unrolled", :]
react 				= df[df[:Name] .== "react", :]

react_t 			= collect(react[react[:BenchmarkName] .== "time_ns", :][:Time])
unrolled_t 			= collect(unrolled[unrolled[:BenchmarkName] .== "time_ns", :][:Time])

react_b 			= collect(react[react[:BenchmarkName] .== "gc_bytes", :][:Time])
unrolled_b 			= collect(unrolled[unrolled[:BenchmarkName] .== "gc_bytes", :][:Time])


plot(1:100:10^4, react_t/10^9, color="c", linewidth=1.0, linestyle="--", label="line1")
plot(1:100:10^4, unrolled_t/10^9, color="c", linewidth=1.0, linestyle="-", label="line2")

plot(1:100:10^4, react_b/10^9, color="deepskyblue", linewidth=1.0, linestyle="--", label="allocated bytes")
plot(1:100:10^4, unrolled_b/10^9, color="deepskyblue", linewidth=1.0, linestyle="-", label="line2")

react_line = mlines.Line2D([], [], color="black", linestyle="--", markersize=15, label="React")
unrolled_line = mlines.Line2D([], [], color="black", linestyle="-", markersize=15, label="Unrolled")
time_line = mpatches.Patch(color="c")
byte_line = mpatches.Patch(color="deepskyblue")

legend([react_line, unrolled_line, time_line, byte_line], ["React", "Unrolled", "Time in Seconds", "Allocation in Gigabytes"],
loc="upper left")
xlabel("N*N")
ylabel("Amount")

gcf()
savefig("test.pdf")