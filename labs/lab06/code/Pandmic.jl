using Plots
using DifferentialEquations

a = 0.09
b = 0.02

I = 52
R = 32
S = 9428

tspan = (0, 100)
t = collect(LinRange(0, 200, 1000))
u0 = [S; I; R]

function syst(dy, y, p, t)
    dy[1] = 0
    dy[2] = b * y[2]
    dy[3] = -b * y[2]
end

prob = ODEProblem(syst, u0, tspan)
sol = solve(prob, saveat=t)

plot(sol)

savefig("03.png")

function syst(dy, y, p, t)
    dy[1] = -a * y[1]
    dy[2] = a * y[1] - b * y[2]
    dy[3] = b * y[2]
end

prob = ODEProblem(syst, u0, tspan)
sol = solve(prob, saveat=t)

plot(sol)

savefig("01.png")
