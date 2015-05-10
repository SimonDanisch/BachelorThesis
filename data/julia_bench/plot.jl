using DataFrames, Gadfly
benchmarks = readtable("bench_data.csv", names=[:language, :benchmark, :time, :codelength, :codelengthsingle])
cdata = benchmarks[benchmarks[:language].== "c", :]
benchmarks = join(benchmarks, cdata, on=:benchmark)
benchmarks[:time]./= benchmarks[:time_1]
benchmarks[:language] = PooledDataArray(benchmarks[:language])
#benchmarks[:language] = reorder(benchmarks[:language], benchmarks[:time])
benchmarks[:benchmark] = PooledDataArray(benchmarks[:benchmark])
#benchmarks[:benchmark] = reorder(benchmarks[:benchmark], benchmarks[:time])
lnames = unique(benchmarks[:language])
result = DataFrame(language=lnames, meantime=1.0:length(lnames), codelength=1.0:length(lnames))
for elem in lnames
    result[result[:language] .== elem, :meantime] = mean(benchmarks[benchmarks[:language].== elem, :time])
    result[result[:language] .== elem, :codelength] = mean(benchmarks[benchmarks[:language].== elem, :codelength])
end
clength = result[:, :codelength]
cmin = minimum(clength)
cmax = maximum(clength)
result[:, :codelength] = (clength - cmin) / (cmax-cmin)
println(result)

p = plot(result,
    x = :codelength,
    y = :meantime,
    color = :language,
    Scale.y_log10,
    Guide.ylabel(nothing),
    Guide.xlabel(nothing),
    Theme(
        default_point_size = 1mm,
        guide_title_position = :left,
        colorkey_swatch_shape = :circle,
        minor_label_font = "Georgia",
        major_label_font = "Georgia",
    )
)
draw(PNG("benchmarks.png", 8inch, 8inch/golden), p)
