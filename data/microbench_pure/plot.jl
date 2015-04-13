using DataFrames
using Gadfly
using Cairo

benchmarks = readtable(joinpath("C:\\", "Users","Sim", "Desktop", "BachelorThesis", "data", "microbench_pure", "benchmarks.csv"), names=[:language, :benchmark, :time])
cdata = benchmarks[benchmarks[:language].== "c", :]
benchmarks = join(benchmarks, cdata, on=:benchmark)
benchmarks[:time]./= benchmarks[:time_1]

benchmarks[:language] = PooledDataArray(benchmarks[:language])
benchmarks[:benchmark] = PooledDataArray(benchmarks[:benchmark])
#benchmarks[:benchmark] = reorder(benchmarks[:benchmark], benchmarks[:time])
benchmarks = benchmarks[benchmarks[:language].!= "c", :]
benchmarks[:language] = setlevels!(benchmarks[:language], Dict{UTF8String,Any}(benchmarks[:language],
  [ lang == "javascript" ? "JavaScript" : ucfirst(lang) for lang in benchmarks[:language]]));

# Couldn't find another way to move julia to the first place
function movejulia(lang)
	if lang == "Julia"
		return "aJulia"
	end
	lang
end
benchmarks = sort(benchmarks, cols=order(:language, by = movejulia), rev=true)

jdata = benchmarks[benchmarks[:language].== "Julia", :]
jmin = minimum(jdata[:time])
jmax = maximum(jdata[:time])

p = plot(benchmarks,
	x = :language,
	y = :time,
	color = :benchmark,
	Scale.y_log10,
	yintercept=[jmin, jmax],
	Geom.hline,
	Geom.point,
	Theme(
	    default_point_size = 1mm,
	    guide_title_position = :left,
	    colorkey_swatch_shape = :square,
	    minor_label_font = "Georgia",
	    major_label_font = "Georgia",
	    panel_fill = color("white")
	)
)
#p = plot(benchmarks, x=:language, y=:time_mean, Geom.point)
draw(PDF(joinpath("C:\\", "Users","Sim", "Desktop", "BachelorThesis", "graphics", "juliabench.pdf"), 8inch, 8inch/golden), p)

