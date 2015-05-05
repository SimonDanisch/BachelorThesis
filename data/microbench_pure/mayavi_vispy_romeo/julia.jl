using GLVisualize, AbstractGPUArray, GLAbstraction, GeometryTypes, Reactive, Meshes

const robj = visualize(rand(Float32,1000,1000), :surface, model=Input(translationmatrix(Vec3(2,0,0))))

push!(GLVisualize.ROOT_SCREEN.renderlist, robj)


renderloop()
