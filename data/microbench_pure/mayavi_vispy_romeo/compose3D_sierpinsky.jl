using Compose3D

function sierpinski(n)
    if n == 0
        compose(Context(0w,0h,0d,1w,1h,1d),pyramid(0w,0h,0d,1w,1h))
    else
        t = sierpinski(n - 1)
        compose(Context(0w,0h,0d,1w,1h,1d),
        (Context(0w,0h,0d,(1/2)w,(1/2)h,(1/2)d), t),
        (Context(0.5w,0h,0d,(1/2)w,(1/2)h,(1/2)d), t),
        (Context(0.5w,0.5h,0d,(1/2)w,(1/2)h,(1/2)d), t),
        (Context(0w,0.5h,0d,(1/2)w,(1/2)h,(1/2)d), t),
        (Context(0.25w,0.25h,0.5d,(1/2)w,(1/2)h,(1/2)d), t))
    end
end

compose(Context(-5mm,-5mm,-5mm,10mm,10mm,10mm), sierpinski(5))