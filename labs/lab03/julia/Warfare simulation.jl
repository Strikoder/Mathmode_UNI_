using Plots
using DifferentialEquations
x0 = 65300
y0 = 55500
t0 = 0
tmax =0.1

a=0.67;
b= 0.54;
c=0.491;
h=0.37;

a2=0.278;
b2= 0.701;
c2=0.502;
h2=0.188;
function P(t)
return sin(5*t)+1
end
function Q(t)
return cos(5*t)+1
end
function P2(t)
return abs(sin(2*t))
end
function Q2(t)
return abs(cos(12*t))
end

function syst(dy, y, p, t)
dy[1] = -a*y[1] - b*y[2] + P(t)
dy[2] = -c*y[1] - h*y[2] + Q(t)
end
function syst2(dy, y, p, t)
dy[1] = -a2*y[1] - b2*y[2] + P2(t)
dy[2] = -c2*y[1]*y[2] - h2*y[2] + Q2(t)
end
u0 = [x0; y0]
tspan = (t0, tmax)
t = collect(LinRange(0, 1, 100))
prob = ODEProblem(syst, u0, tspan)
sol = solve(prob, saveat=t)
prob2 = ODEProblem(syst2, u0, tspan)
sol2 = solve(prob2, saveat=t)
plot(sol2)
