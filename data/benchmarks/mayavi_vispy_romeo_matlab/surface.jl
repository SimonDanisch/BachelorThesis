using Reactive, GLVisualize, GLAbstraction

function f(x, y, i, N)
	x = ((x/N)-0.5f0)*i
	y = ((y/N)-0.5f0)*i
	r = sqrt(x*x + y*y)
	sin(r)/r
end
create(i, N) = Float32[f(Float32(x),Float32(y),i,Float32(N)) for x=1:N, y=1:N]

N 		= 600
surface = lift(create, bounce(1f0:200f0), N)
#surface = create(20f0, N)
view(visualize(surface, :surface, color_norm = Vec2(-0.5,1)))
renderloop()

