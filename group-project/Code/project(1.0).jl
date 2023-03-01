"""
### to fix
* matrices prints out zeros (code not working needs debugging)
* needs plotting
### fixed
* idk some syntax errors and bounds connections
"""

# using Distributions
using Plots
using Random

M = 12.0
N = 120.0
x = 0.0
y = 0.0
w = 0.5
h = 1.0
deltaT = 1.0
cp = 3.8
L = 4.42
Tm = 5
Tinf = 6
l = 4.31323
delta = 139.547327
k = 0
hi = 414.32
rows = 131 # m
cols = 131 # n
Dend = zeros((rows,cols)) # float64
Temp = zeros((rows,cols)) # float64
Dend[trunc(Int, ((rows-1)/2)),trunc(Int, ((cols-1)/2))] = 1
Temp[trunc(Int, ((rows-1)/2)),trunc(Int, ((cols-1)/2))] = cp * (Tm - Tinf)/L
nu = (1.0 - (-1.0)) * rand(rows,cols) .- 1.0
Grad = zeros((rows,cols))
S = zeros((rows,cols))
function Dentrid()
    if y < N
        if x < M
            for i in rows
               for j in cols
                    Tij_sum = 0
                    Tij_sum_w = 0.0
                    
                    if i > 0
                        Tij_sum += Temp[i-1,j]
                        if j > 0
                            Tij_sum_w += Temp[i-1,j-1]
                        end
                    end
                    if j > 0
                        Tij_sum += Temp[i,j-1]
                        if i < rows-1
                            Tij_sum_w += Temp[i+1,j-1]
                        end
                    end
                    if i < rows-1
                        Tij_sum += Temp[i+1,j]
                        if j > 0
                            Tij_sum_w += Temp[i+1,j-1]
                        end
                    end
                    if j < cols-1
                        Tij_sum += Temp[i,j+1]
                        if i < rows-1
                            Tij_sum_w += Temp[i+1,j+1]
                        end
                    end
                    Tij = (Tij_sum + w*Tij_sum_w) / (4.0 + 4.0*w)
                    Grad[i,j] = (Tij - Temp[i]) / ((4.0 + 4.0*w) * (1.0+2.0*w)*(h*h))
               end
            end
            # second part
            funcA()
        else
            # third part
            funcB()
        end
    end
end
function funcA()
    global x
    for i in trunc(Int, (rows-1)/2):-1:1
        for j in trunc(Int, (cols-1)/2):-1:1
            if Dend[i,j] == 0
                Temp[i,j] = Temp[i,j] + hi*deltaT*Grad[i,j] / M
            end
            
        end
    end
    for i in trunc(Int, (rows-1)/2):rows:1
        for j in trunc(Int, (cols-1)/2):cols:1
            if Dend[i,j] == 0
                Temp[i,j] = Temp[i,j] + hi*deltaT*Grad[i,j] / M
            end
        end
    end
    x += 1
    Dentrid()
end
function funcB()
    global y
    for i in rows
        for j in cols
            sum_not_diagonal = 0.0
            sum_diagonal = 0.0
            if i > 0
                sum_not_diagonal += Dend[i-1,j]
                if j > 0
                    sum_diagonal += Dend[i-1,j-1]
                end
            end
            if j > 0
                sum_not_diagonal += Dend[i,j-1]
                if i < rows-1
                    sum_diagonal += Dend[i+1,j-1]
                end
            end
            if i < rows-1
                sum_not_diagonal += Dend[i+1,j]
                if j > 0
                    sum_diagonal += Dend[i+1,j-1]
                end
            end
            if j < cols-1
                sum_not_diagonal += Dend[i,j+1]
                if i < rows-1
                    sum_diagonal += Dend[i+1,j+1]
                end
            end
            k = sum_diagonal + sum_not_diagonal
            if k >= 1
                S[i,j] = sum_not_diagonal + w*sum_diagonal .- (2.5 + 2.5*w)
                T = Temp[trunc(Int, (rows-1)/2),trunc(Int, (cols-1)/2)]*(1.0 + nu[i,j]*delta)+l*S[i,j]
                if Temp[i,j] < T
                    Dend[i,j] = 1
                    Temp[i,j] = Temp[trunc(Int, (rows-1)/2),trunc(Int, (cols-1)/2)]
                end
            end
        end
    y += 1
    # plot
    #
    #
    #
    #
    #
    Dentrid()
    end
end

Dentrid()

