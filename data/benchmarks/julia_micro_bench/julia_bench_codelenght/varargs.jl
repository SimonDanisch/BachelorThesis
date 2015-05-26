immutable Functor{FuncName} end
#with staged functions available in 0.4:
#=
stagedfunction evaluate{NumArgs,FuncName}(::Functor{FuncName}, args::NTuple{NumArgs})
    args_expr = map(1:NumArgs) do x
        :(args[$x])
    end
    :($FuncName($(args_expr...)))
end
=#
#without:
for numargs=1:8, funcname=[:testfunction]
    args_expr = map(1:numargs) do x
        :(args[$x])
    end
    @eval evaluate(::Functor{$(parse(":$funcname"))}, args::NTuple{$numargs}) = $funcname($(args_expr...))
end

testfunction(a)     = sum(a)
testfunction(a,b)   = sum(a+b)
testfunction(a,b,c) = sum(a+b+c)

function broadcast_devec(m, n, f, arr_out, args::NTuple)
    for j=1:n
      for i=1:m
        @inbounds arr_out[i, j] = evaluate(f, args)
      end
    end
end

#Your version!?
for numargs=1:8, funcname=[:testfunction]
    args_expr = map(1:numargs) do x
        :($(symbol(":a$x")))
    end
    @eval evaluate2(::Functor{$(parse(":$funcname"))}, $(args_expr...)) = $funcname($(args_expr...))
end
function broadcast_devec2(
    num_args, m, n, f, arr_out, 
    a, b, c)
  if num_args == 1
    for j=1:n
      for i=1:m
        @inbounds arr_out[i, j] = evaluate2(f, a)
      end
    end
  elseif num_args == 2
    for j=1:n
      for i=1:m
        @inbounds arr_out[i, j] = evaluate2(f, a, b)
      end
    end
  elseif num_args == 3
    for j=1:n
      for i=1:m
        @inbounds arr_out[i, j] = evaluate2(f, a, b, c)
      end
    end
  end
end

const myfunc = Functor{:testfunction}()
const N = 500
const m,n = (N,N)
const arr_out = rand(m,n)
const a,b,c = (rand(N), rand(N), rand(N))

@time broadcast_devec(m,n,myfunc, arr_out, (a,))
@time broadcast_devec(m,n,myfunc, arr_out, (a,b))
@time broadcast_devec(m,n,myfunc, arr_out, (a,b,c))

@time broadcast_devec2(1,m,n,myfunc, arr_out, a,b,c)
@time broadcast_devec2(2,m,n,myfunc, arr_out, a,b,c)
@time broadcast_devec2(3,m,n,myfunc, arr_out, a,b,c)
println("......")

@time broadcast_devec(m,n,myfunc, arr_out, (a,))
@time broadcast_devec2(1,m,n,myfunc, arr_out, a,b,c)

@time broadcast_devec(m,n,myfunc, arr_out, (a,b))
@time broadcast_devec2(2,m,n,myfunc, arr_out, a,b,c)

@time broadcast_devec(m,n,myfunc, arr_out, (a,b,c))
@time broadcast_devec2(3,m,n,myfunc, arr_out, a,b,c)
