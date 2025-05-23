# Задание 1
function log_(a, x; atol = 1e-16)
    @assert a > 1; @assert x > 0; @assert atol > 0
    z = x; t = 1; y = 0
    # ИНВАРИАНТ: x = a^y * z^t
    # Где z^t = a^Δy , Δy - погрешность
    while z < 1/a || z > a || abs(t) > atol
        if z < 1/a
            z *= a
            y += t
        elseif z > a
            z /= a
            y -= t
        else
            t /= 2
            z *= z
        end
    end
    return y
end

println(log_(2, 8))  

#Исследуем возможность получения переполнения/исчезновения порядка в этом алгоритме в случае выполнения операций в неправильном порядке.

function log_1(a, x; atol = 1e-16)
    @assert a > 1; @assert x > 0; @assert atol > 0
    z = x; t = 1; y = 0
    while z < 1/a || z > a || abs(t) > atol
        if abs(t) > atol # При z > 1 достигает Inf | при z < 1 достигает машинного нуля 
            t /= 2 
            z *= z
        elseif z < 1/a
            z *= a
            y += t
        elseif z > a
            z /= a 
            y -= t 
        end
    end
    return y
end

#println(log_1(2, 10000008))


# Задание 2
function bisect(a, b; atol = 1e-8)
    @assert a < b
    @assert f(a)*f(b) < 0
    y_a = f(a)
    while b-a > atol
        x = (a+b) / 2
        y = f(x)
        if y == 0
            return x
        elseif y*y_a < 0 # <=> корень in (a, x)
            b = x
        else # y*fa > 0  #<=> корень in (x, b) 
            a = x
        end
    end
    return (a+b)/2
end

f(x) = x - 2
println(bisect(-10, 10))


# Задание 3
using LinearAlgebra

# Метод Ньютона для скалярных значений
function newthon(delta::Function, x::Number; atol=1e-8, nmax_iter=20)
    dx = delta(x)
    n = 0
    while abs(dx) > atol && n < nmax_iter
        x += dx
        dx = delta(x)
        n += 1
    end
    if n >= nmax_iter
        @warn "Превышено число итераций ($nmax_iter)"
        return nothing
    end
    return x
end

# Метод Ньютона для векторов
function newthon(delta::Function, x::AbstractVector; atol=1e-8, nmax_iter=20)
    dx = delta(x)
    n = 0
    while norm(dx) > atol && n < nmax_iter
        x += dx
        dx = delta(x)
        n += 1
    end
    if n >= nmax_iter
        @warn "Превышено число итераций ($nmax_iter)"
        return nothing
    end
    return x
end


# Решение cos(x) = x с ручным дифференцированием
f(x) = cos(x) - x
df(x) = -sin(x) - 1
delta(x) = -f(x) / df(x)
result = newthon(delta, 1.0)
println("Решение cos(x)=x (ручная производная): ", result)

# Решение cos(x) = x с конечными разностями
h = 1e-8
f(x) = cos(x) - x
df(x) = (f(x + h) - f(x)) / h
delta(x) = -f(x) / df(x)
result = newthon(delta, 1.0)
println("Решение cos(x)=x (конечные разности): ", result)

# Схема Горнера для многочлена x^3 + x^2 + x + 1
function horner(coeffs, x)
    p = coeffs[1]
    dp = zero(x)
    for c in coeffs[2:end]
        dp = dp * x + p
        p = p * x + c
    end
    return p, dp
end

coeffs = [1.0, 1.0, 1.0, 1.0] # x^3 + x^2 + x + 1
delta(x) = begin
    p, dp = horner(coeffs, x)
    -p / dp
end

roots = []
for x0 in [-1.0+0.0im, 0.0+1.0im, 0.0-1.0im] # -1 | i | -i
    root = newthon(delta, x0)
    push!(roots, round(root, digits=6))
end
println("Корни многочлена x^3 + x^2 + x + 1: ", unique(roots))


# Задание 4
using LinearAlgebra

struct Dual{T}
    val::T # значение
    der::T # производная
end

# Базовые операции для Dual с поддержкой комплексных чисел
Base.:+(x::Dual{T}, y::Dual{S}) where {T,S} = Dual{promote_type(T,S)}(x.val + y.val, x.der + y.der)
Base.:-(x::Dual{T}, y::Dual{S}) where {T,S} = Dual{promote_type(T,S)}(x.val - y.val, x.der - y.der)
Base.:*(x::Dual{T}, y::Dual{S}) where {T,S} = Dual{promote_type(T,S)}(x.val * y.val, x.val * y.der + x.der * y.val)
Base.:/(x::Dual{T}, y::Dual{S}) where {T,S} = Dual{promote_type(T,S)}(x.val / y.val, (x.der * y.val - x.val * y.der) / y.val^2)

Base.cos(d::Dual) = Dual(cos(d.val), -sin(d.val)*d.der)
Base.sin(d::Dual) = Dual(sin(d.val), cos(d.val)*d.der)

# Конвертация чисел в Dual с автоматическим определением типа
Dual(x::Number) = Dual(x, zero(x))
Dual(x::Number, d::Number) = Dual{promote_type(typeof(x), typeof(d))}(x, d)

# Функция valdif
function valdif(f::Function, x::Number)
    dx = Dual(x, one(x))  # x + ε, где ε^2 = 0
    dy = f(dx)
    return (dy.val, dy.der)  # (f(x), f'(x))
end

function newthon(delta::Function, x; atol=1e-8, nmax_iter=50)
    dx = delta(x)
    n = 0
    while (x isa Number ? abs(dx) : norm(dx)) > atol && n < nmax_iter
        x += dx
        dx = delta(x)
        n += 1
    end
    if n >= nmax_iter
        @warn "Превышено число итераций ($nmax_iter)"
        return nothing
    end
    return x
end

# Решение cos(x) = x
function solve_cos_eq()
    f(x) = cos(x) - x
    delta(x) = -valdif(f, x)[1] / valdif(f, x)[2]  # -f(x)/f'(x)
    root = newthon(delta, 1.0)
    println("Корень cos(x) = x: ", root)
end

# Решение x^3 + x^2 + x + 1 = 0
function solve_poly_eq()
    coeffs = [1.0, 1.0, 1.0, 1.0]  
        
    function poly(x)
        p = Dual(coeffs[1], 0.0)
        for c in coeffs[2:end]
            p = p * Dual(c, 0.0) + p * x
        end
        return p
    end
        
    delta(x) = -valdif(poly, x)[1] / valdif(poly, x)[2]
        
    # Поиск всех корней
    roots = []
    for x0 in [-1.0+0.0im, 0.0+1.0im, 0.0-1.0im]
        root = newthon(delta, x0)
        !isnothing(root) && push!(roots, round(root, digits=6))
    end
    println("Корни: ", unique(roots))
end

solve_cos_eq()
solve_poly_eq()


# Задание 5
using LinearAlgebra
using ForwardDiff

struct Dual{T}
    val::T
    der::T
end

Base.:+(a::Dual, b::Dual) = Dual(a.val + b.val, a.der + b.der)
Base.:+(a::Dual, b::Number) = Dual(a.val + b, a.der)
Base.:+(a::Number, b::Dual) = Dual(a + b.val, b.der)

Base.:-(a::Dual, b::Dual) = Dual(a.val - b.val, a.der - b.der)
Base.:-(a::Dual, b::Number) = Dual(a.val - b, a.der)
Base.:-(a::Number, b::Dual) = Dual(a - b.val, -b.der)

Base.:*(a::Dual, b::Dual) = Dual(a.val * b.val, a.val*b.der + a.der*b.val)
Base.:*(a::Dual, b::Number) = Dual(a.val * b, a.der * b)
Base.:*(a::Number, b::Dual) = Dual(a * b.val, a * b.der)

Base.:/(a::Dual, b::Dual) = Dual(a.val / b.val, (a.der*b.val - a.val*b.der)/b.val^2)
Base.:/(a::Dual, b::Number) = Dual(a.val / b, a.der / b)
Base.:/(a::Number, b::Dual) = Dual(a / b.val, (-a*b.der)/b.val^2)

Base.:^(a::Dual, n::Integer) = Dual(a.val^n, n*a.val^(n-1)*a.der)

Dual(x::Number) = Dual(x, zero(x))
Dual(x::Number, d::Number) = Dual{promote_type(typeof(x), typeof(d))}(x, d)

Base.cos(d::Dual) = Dual(cos(d.val), -sin(d.val)*d.der)
Base.sin(d::Dual) = Dual(sin(d.val), cos(d.val)*d.der)
Base.exp(d::Dual) = Dual(exp(d.val), exp(d.val)*d.der)


function newton(F, J, x0; atol=1e-8, maxiter=20)
    x = copy(x0)
    for i in 1:maxiter
        Fx = F(x)
        if norm(Fx) < atol
            return x
        end
        Jx = J(x)
        Δx = Jx \ (-Fx)
        x += Δx
    end
    @warn "Достигнуто максимальное число итераций"
    return x
end

## Решение системы  x^2 + y^2 = 2,y = x^3

F_system(x) = [
    x[1]^2 + x[2]^2 - 2,
    x[2] - x[1]^3
]

J_manual(x) = [
    2x[1]       2x[2];
    -3x[1]^2    1
]

function J_dual(x)
    # Первый столбец Якобиана (производная по x1)
    vars = [Dual(x[1], 1.0), Dual(x[2], 0.0)]
    f1 = F_system(vars)
    col1 = [f1[1].der, f1[2].der]
    
    # Второй столбец Якобиана (производная по x2)
    vars = [Dual(x[1], 0.0), Dual(x[2], 1.0)]
    f2 = F_system(vars)
    col2 = [f2[1].der, f2[2].der]
    
    hcat(col1, col2)
end

function J_forwarddiff(x)
    ForwardDiff.jacobian(F_system, x)
end

x0 = [1.0, 1.0]

sol_manual = newton(F_system, J_manual, x0)
println("1. Ручное дифференцирование: ", round.(sol_manual, digits=8))

sol_dual = newton(F_system, J_dual, x0)
println("2. Автом. дифф. (Dual): ", round.(sol_dual, digits=8))

sol_fd = newton(F_system, J_forwarddiff, x0)
println("3. ForwardDiff: ", round.(sol_fd, digits=8))


# Задание 6
using SpecialFunctions  
using Plots             
using ForwardDiff       

# Реализация функции Бесселя первого рода через ряд Тейлора
function bessel_taylor(n::Int, x::Real; atol=1e-10, maxiter=1000)
    sum = zero(x)
    term = zero(x)
    m = 0
    
    while m ≤ maxiter
        # Вычисляем текущий член ряда
        term = (-1)^m / (factorial(m) * factorial(m + n)) * (x/2)^(2m + n)
        
        sum += term
        
        if abs(term) < atol
            break
        end
        
        m += 1
    end
    
    return sum
end

# Оптимизированная версия с рекуррентным соотношением (O(n) сложность)
function bessel_recurrent(n::Int, x::Real; atol=1e-10, maxiter=1000)
    if n < 0
        throw(DomainError(n, "Порядок должен быть неотрицательным"))
    end
    
    sum = zero(x)
    term = zero(x)
    m = 0
    
    # Начальный член ряда при m=0
    term = (x/2)^n / factorial(n)
    sum = term
    
    while m < maxiter
        # Рекуррентное соотношение для следующего члена
        term *= (-1) * (x/2)^2 / ((m + 1) * (m + n + 1))
        
        sum += term
        
        if abs(term) < atol
            break
        end
        
        m += 1
    end
    
    return sum
end

function plot_bessel_functions(orders::Vector{Int}, xrange=0:0.1:20)
    plt = plot(title="Функции Бесселя первого рода",
              xlabel="x", ylabel="J_n(x)",
              legend=:topright)
    
    for n in orders
        yvals = [bessel_recurrent(n, x) for x in xrange]
        plot!(xrange, yvals, label="J$n(x)", lw=2)
    end
    
    return plt  
end

# Функция для построения графика функции и её производной
function plot_bessel_with_derivative(n::Int, xrange=0:0.1:10)
    f(x) = bessel_recurrent(n, x)
    
    df(x) = ForwardDiff.derivative(f, x)
    
    plt = plot(title="Функция Бесселя J$n(x) и её производная",
              xlabel="x", ylabel="Значение",
              legend=:topright)
    
    yvals = [f(x) for x in xrange]
    dyvals = [df(x) for x in xrange]
    
    plot!(xrange, yvals, label="J$n(x)", lw=2)
    plot!(xrange, dyvals, label="dJ$n(x)/dx", lw=2, linestyle=:dash)
    
    return plt  
end


x_test = 2.5
println(bessel_recurrent(0, x_test))

p1 = plot_bessel_functions([0, 1, 2])

p2 = plot_bessel_with_derivative(1)

println("\nПроверка точности для больших x:")
x_big = 100.0
println("Float64: ", bessel_recurrent(0, x_big))
println("BigFloat: ", bessel_recurrent(0, BigFloat(x_big)))

# Чтобы графики не закрывались сразу
println("\nДля закрытия графиков нажмите Enter...")
display(p1)
display(p2)
readline()



# Задание 7
using Pkg
Pkg.add("GLMakie")
Pkg.add("LinearAlgebra")
Pkg.add("Colors")

using GLMakie  # Используем GLMakie для визуализации
using LinearAlgebra
using Colors

# Функция для метода Ньютона
function newton_fractal(z0; maxiter=50, tol=1e-6)
    roots = [cis(2π*k/3) for k in 0:2]  # Три корня уравнения z^3 = 1
    colors = [RGB(1,0,0), RGB(0,1,0), RGB(0,0,1)]  # Красный, зеленый, синий
    
    z = z0
    for i in 1:maxiter
        f = z^3 - 1
        df = 3z^2
        dz = f / df
        z -= dz
        
        # Проверяем сходимость к одному из корней
        for (k, root) in enumerate(roots)
            if abs(z - root) < tol
                return colors[k], i 
            end
        end
    end
    
    return RGB(0,0,0), maxiter  # Черный цвет для расходящихся точек
end

width, height = 800, 800
xmin, xmax = -2.0, 2.0
ymin, ymax = -2.0, 2.0

img = Matrix{RGB{Float64}}(undef, height, width)

for i in 1:height, j in 1:width
    x = xmin + (j-1)*(xmax-xmin)/(width-1)
    y = ymin + (i-1)*(ymax-ymin)/(height-1)
    z0 = x + y*im
    color, _ = newton_fractal(z0)
    img[i,j] = color
end

# Создаем и настраиваем график
fig = Figure(resolution = (width, height))
ax = Axis(fig[1, 1], aspect = DataAspect())
hidedecorations!(ax) 

image!(ax, img)

fig[1, 1] = ax
display(fig)

save("newton_fractal.png", fig)
println("Фрактал сохранен в файл newton_fractal.png")