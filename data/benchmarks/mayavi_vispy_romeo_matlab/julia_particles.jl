using GLVisualize, AbstractGPUArray, GLAbstraction, GeometryTypes, Reactive, ColorTypes


#animated max 40.000
#still max 1 million
const N = 1000
const time_i 		= bounce(1f0:0.001f0:20f0) # lets the values "bounce" back and forth between 1 and 50, f0 for Float32
const start_pos 	= Point3{Float32}[rand(Point3{Float32}, 0f0:eps(Float32):1f0)*5f0 for i=1:N, j=1:N]
generate(i, start) 	= convert(Array{Point3{Float32},2}, start.*i)
const positions 	= lift(generate, time_i, start_pos)
const robj 			= visualize(positions)

push!(GLVisualize.ROOT_SCREEN.renderlist, robj)


renderloop()
 