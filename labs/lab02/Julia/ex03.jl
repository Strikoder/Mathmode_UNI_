import Pkg; Pkg.add("PyPlot")


using PyPlot;
using DifferentialEquations;

function myfunction(u, p, T)
return u/√(22.04)
end

const x_1 = 17.8/5.8
const x_2 = 17.8/3.8
const T = (0, 5π)

equation1 = ODEProblem(myfunction, x_1, T)
equation2 = ODEProblem(myfunction, x_2, T)

sol1 = solve(equation1,
 abstol=1e-8, 
 reltol=1e-8)
sol2 = solve(equation2,
 abstol=1e-8,
  reltol=1e-8);

polar(sol1.t, sol1.u + fill(x_1, 20))

polar(fill(-1.5, 11), collect(0: 10: 50))


polar(sol2.t, sol2.u + fill(x_2, 32))
title("FirstCase")
xlabel("x")

polar(fill(-1.5, 11), collect(0: 10: 100))
ylabel("y")

savefig("First pic.jpg")
