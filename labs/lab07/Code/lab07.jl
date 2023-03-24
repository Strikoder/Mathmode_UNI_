using Plots

using DifferentialEquations

a = 0.58
b = 0.00008
N = 1550

tspan = (0, 15)
t = collect(LinRange(0, 15, 500))
n = 8

function syst(dy, y, p, t)
    dy[1] = (a + b * y[1]) * (N - y[1])
end

prob = ODEProblem(syst, [n], tspan)
sol = solve(prob, saveat=t)

plot(sol)

savefig("01.png")

a = 0.000058
b = 0.8
N = 1550

tspan = (0, 0.1)
t = collect(LinRange(0, 0.1, 500))
n = 8

function syst(dy, y, p, t)
    dy[1] = (a + b * y[1]) * (N - y[1])
end

prob = ODEProblem(syst, [n], tspan)
sol = solve(prob, saveat=t)

plot(sol)

savefig("02.png")

a = 0.58
b = 0.38
N = 1550

tspan = (0, 0.3)
t = collect(LinRange(0, 0.3, 500))
n = 8

function syst(dy, y, p, t)
    dy[1] = (a * cos(2 * t) + b * cos(3 * t) * y[1]) * (N - y[1])
end

prob = ODEProblem(syst, [n], tspan)
sol = solve(prob, saveat=t)

plot(sol)

savefig("03.png")
