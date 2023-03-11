#Julia
using Random, LinearAlgebra
using PyPlot

M = 12 #Количество итераций(шагов)
x = 0 #Начальные коор
y = 0 #Начальные коор
N = 120


w = 0.5 #Коэффициент, учитывающий влияние диагональных соседей
h = 1 #Расстояние между узлами по вертикали и горизонтали
deltaT = 1 #Шаг по времени

cp = 3.8 #Теплоемкость при постоянном давлении на единицу массы
L = 4.42 #Удельная теплота плавления на единицу массы

Tm = 5 #Температура плавления
Tinf = 6

l = 4.31323
delta = 139.547327
k = 0 #Коэффициент теплопроводности
hi = 414.32

rows, cols = 131, 131 #Сетка NxN
Dend = zeros(rows, cols)
Temp = zeros(rows, cols)
Dend[div(rows - 1, 2)+1, div(cols - 1, 2)+1] = 1
Temp[div(rows - 1, 2)+1, div(cols - 1, 2)+1] = cp * (Tm - Tinf) / L

Random.seed!(1234)
nu = (1 - (-1)) .* rand(rows, cols) .- 1

Grad = zeros(rows, cols) #Массив для хранения температурного градиента
S = zeros(rows, cols)

function cal_grad_tem()  #Вычисляет температурный градиент в каждой ячейке(интерация по всем, кроме границ + для каждого SumT соседнего => T в каждой ячейке
    global x
    global Dend, Temp, Grad, S

    if y < N
        if x < M
            for i in 1:rows
                for j in 1:cols
                    Tij_sum = 0
                    Tij_sum_w = 0

                    if i > 1
                        Tij_sum += Temp[i-1, j]
                        if j > 1
                            Tij_sum_w += Temp[i-1, j-1]
                        end
                    end

                    if j > 1
                        Tij_sum += Temp[i, j-1]
                        if i < rows
                            Tij_sum_w += Temp[i+1, j-1]
                        end
                    end

                    if i < rows
                        Tij_sum += Temp[i+1, j]
                        if j > 1
                            Tij_sum_w += Temp[i+1, j-1]
                        end
                    end

                    if j < cols
                        Tij_sum += Temp[i, j+1]
                        if i < rows
                            Tij_sum_w += Temp[i+1, j+1]
                        end
                    end

                    Tij = (Tij_sum + w * Tij_sum_w) / (4 + 4 * w)
                    Grad[i, j] = (Tij - Temp[i, j]) / ((4 + 4 * w) * (1 + 2 * w) * (h * h))
                end
            end

            upd_temp()
        else
            status()
        end
    end
end

function upd_temp() #Обновляет T в каждой
    global x
    global Dend, Temp, Grad

    for i in div(rows - 1, 2):-1:1
        for j in div(cols - 1, 2):-1:1
            if Dend[i, j] == 0
                Temp[i, j] += hi * deltaT * Grad[i, j] / M
            end
        end
    end

    for i in div(rows - 1, 2)+1:rows
        for j in div(cols - 1, 2)+1:cols
            if Dend[i, j] == 0
                Temp[i, j] += hi * deltaT * Grad[i, j] / M
            end
        end
    end

    x += 1
    cal_grad_tem()
end

function status()  #Обновляет статус каждой + Sum стату соседей (если статус > нужного, то ячейка превращается в дендрит)
    global y
    for i in 1:rows
        for j in 1:cols
            sum_not_diagonal = 0
            sum_diagonal = 0
            if i > 1
                sum_not_diagonal += Dend[i-1, j]
                if j > 1
                    sum_diagonal += Dend[i-1, j-1]
                end
            end
            if j > 1
                sum_not_diagonal += Dend[i, j-1]
                if i < rows
                    sum_diagonal += Dend[i+1, j-1]
                end
            end
            if i < rows
                sum_not_diagonal += Dend[i+1, j]
                if j > 1
                    sum_diagonal += Dend[i+1, j-1]
                end
            end
            if j < cols
                sum_not_diagonal += Dend[i, j+1]
                if i < rows
                    sum_diagonal += Dend[i+1, j+1]
                end
            end
            k = sum_diagonal + sum_not_diagonal
            if k >= 1
                S[i, j] = sum_not_diagonal + w * sum_diagonal - (2.5 + 2.5 * w)
                T = Temp[div(rows - 1, 2)+1, div(cols - 1, 2)+1] * (1 + nu[i, j] * delta + l * S[i, j])

                if Temp[i, j] < T
                    Dend[i, j] = 1 #1 - состояние, при достижении которой ячейка превращается в дендрит
                    Temp[i, j] = Temp[div(rows - 1, 2)+1, div(cols - 1, 2)+1]
                end
            end
        end
    end
    y += 1

    rgba = cmap(norm(Dend))
    plt.pause(1e-12)
    plt.clf()
    plt.imshow(rgba, interpolation="nearest")
    cal_grad_tem() # вызывает снова А, для повторной проверки T уже не ячейки, а дендрита
end

cmap = matplotlib.cm.gray
norm = matplotlib.colors.Normalize(vmin=minimum(Dend), vmax=maximum(Dend))
rgba = cmap.(norm.(Dend))

PyPlot.title("Dendritic Growth.")
PyPlot.imshow(rgba, interpolation="nearest")

cal_grad_tem()

rgba = cmap.(norm.(Dend))

PyPlot.title("Final Dendritic Growth.")
PyPlot.imshow(rgba, interpolation="nearest")