using GLVisualize, AbstractGPUArray, GLAbstraction, Meshes, GeometryTypes, Reactive
const N = 500
const heights = Float32[1f0 for i=1:N, j=1:N]
const robj = visualize(heights)
push!(GLVisualize.ROOT_SCREEN.renderlist, robj)


renderloop()
