# 1 задание

function maxsum(iter)
    arraymaker(iter)
    mx = sum = zero(eltype(iter))
    for i in 1:length(iter)
        if sum + iter[i] >= iter[i]
            sum += iter[i]
        else
            sum = iter[i]
            mx = max(sum, mx)
        end
        mx = max(sum, mx)
    end
    return mx
end

# 2 задание

function standart_deviation_multidim(iter)
    arraymaker(iter)
    s1 = s2 = 0
    n = 0
    for elem in iter
        s1 += elem
        s2 += elem^2
        n += 1
    end
    return (s2/n - (s1/n)^2)
end

# 3 задание

function polynom(coefficients::Vector{T}, x::S) where {T,S}
    R = promote_type(T, S)
    result = zero(R)
    for coeff in coefficients
        result = result*x + coeff
    end
    return result
end

# 4 задание

function f_value(coeff, x)
    T = promote_type(eltype(coeff), typeof(x))
    poly_val = poly_diff = convert(T, coeff[begin])
    for a in Iterators.drop(coeff, 1)
        poly_diff = poly_diff*x + poly_val
        poly_val = poly_val*x + a
    end
    return poly_val, poly_diff
end

coeffs = [2, -3, 5, -1]  # 2x^3 - 3x^2 + 5x - 1
x = 3.0

println(f_value(coeffs, x))

# 5 задание

function gcdx_(a_0::T, b_0::T)::NTuple{3,T} where T
a, b = a_0, b_0
ua, va = one(T), zero(T)
ub, vb = zero(T), one(T)
# - едничные и нулевые значения, определяемые с помощью функуий one и zero обеспечивают стабильность типа переменных ua,va,ub,vb
# ИНВАРИАНТ: НОД(a0, b0) = НОД(a0,b0)  &&  a = ua*a0 + va*b0  &&  b = ub*a0 + vb*b0

while !iszero(b)
    k, r = divrem(a,b) # k = div(a,b), r = rem(a,b) (a == k*b + r)
    a, b = b, r
    ua, va, ub, vb = ub, vb, ua - k * ub, va - k * vb # - это преобразование переменных выведено из того, что r = a - k*b
                                                      # и из требования сохранения инварианта цикла
end
return a, ua, va
end
#----------------TEWST


iter = rand(-10:10, 7)
# function arraymaker(iter)
#     randn = rand(-10:10,10)
#     for i in randn
#         push!(iter, i)
#     end
#     println(iter)
#     return iter
# end


println(gcdx_(48, 18))

#6 задание

struct Residue{M, T} <: Number where {T<:Integer, M}
    value::T
    function Residue{M}(x) where {M}
        new{typeof(x), M}(mod(x, M))  # Приводим к модулю M
    end
end

Base.:+(a::Residue{T, M}, b::Residue{T, M}) where {T, M} = Residue{T, M}(a.value + b.value)
Base.:-(a::Residue{T, M}, b::Residue{T, M}) where {T, M} = Residue{T, M}(a.value - b.value)
Base.:*(a::Residue{T, M}, b::Residue{T, M}) where {T, M} = Residue{T, M}(a.value * b.value)

Base.zero(::Type{Residue{T, M}}) where {T, M} = Residue{T, M}(zero(T))
Base.one(::Type{Residue{T, M}}) where {T, M} = Residue{T, M}(one(T))

r1 = Residue{5}(7)
r2 = Residue{5}(9)
println(r1.value)
println(r2.value)

r3 = r1 + r2
println(r3.value)

#7 задание
struct Residue{M, T}
    val::T
    Residue{M}(val) where {M} = new{M, typeof(val)}(mod(val, M))
end

Base. +(a::Residue{M, T}, b::Residue{M, T}) where {M, T} = Residue{M, T}(a.val + b.val)
Base. -(a::Residue{M, T}, b::Residue{M, T}) where {M, T} = Residue{M, T}(a.val - b.val)
Base. *(a::Residue{M, T}, b::Residue{M, T}) where {M, T} = Residue{M, T}(a.val * b.val)

Base.zero(::Type{Residue{M, T}}) where {M, T} = Residue{M, T}(zero(T))
Base.zero(::Residue{M, T}) where {M, T} = Residue{M, T}(zero(T))  # Для экземпляра
Base.one(::Type{Residue{M, T}}) where {M, T} = Residue{M, T}(one(T))

struct Polynomial{M, T}
    coef::Vector{T}

    function Polynomial{M, T}(coef) where {M, T}
        while !isempty(coef) && iszero(coef[end])
            pop!(coef)
        end
        (isempty(coef)) && (push!(coef, zero(T)))
        return new{M, T}(coef)
    end
end

ord(polyn::Polynomial{M, T}) where {M, T} = length(polyn.coef) - 1     

polyn_to_tuple(polyn::Polynomial{M, T}) where {M, T} = Tuple(polyn.coef)

Base.zero(::Type{Polynomial{M, T}}) where {M, T} = Polynomial{M, T}([zero(T)])
Base.zero(polyn::Polynomial{M, T}) where {M, T} = zero(Polynomial{M, T})
Base.one(::Type{Polynomial{M, T}}) where {M, T} = Polynomial{M, T}([one(T)])
Base.one(polyn::Polynomial{M, T}) where {M, T} = one(Polynomial{M, T})

function Base. +(a::Polynomial{M, T}, b::Polynomial{M, T}) where {M, T}
    (ord(a) >= ord(b)) && (c = copy(a.coef); c[1:ord(b) + 1] .+= b.coef)
    (ord(a) < ord(b)) && (c = copy(b.coef); c[1:ord(a) + 1] .+= a.coef)
    return Polynomial{M, T}(c)
end

function Base. -(a::Polynomial{M, T}, b::Polynomial{M, T}) where {M, T}
    (ord(a) >= ord(b)) && (c = copy(a.coef); c[1:ord(b) + 1] .-= b.coef)
    (ord(a) < ord(b)) && (c = copy(b.coef); c[1:ord(a) + 1] .-= a.coef)
    return Polynomial{M, T}(c)
end

function Base. +(a::Polynomial{M, T}, num) where {M, T}
    res = copy(a.coef)
    res .+= num
    return Polynomial{M, T}(res)
end

function Base. -(a::Polynomial{M, T}, num) where {M, T}
    res = copy(a.coef)
    res .-= num
    return Polynomial{M, T}(res)
end

function Base. *(a::Polynomial{M, T}, b::Polynomial{M, T}) where {M, T}
    c = zeros(T, ord(a) + ord(b) + 1)
    for i = eachindex(a.coef), j = eachindex(b.coef)
        c[i + j - 1] += a.coef[i] * b.coef[j]
    end
    return Polynomial{M, T}(c)
end

function Base. *(a::Polynomial{M, T}, num) where {M, T}
    res = copy(a.coef)
    res .*= num
    return Polynomial{M, T}(res)
end

function Base.divrem(a0::Polynomial{M, T}, b0::Polynomial{M, T}) where {M, T <: Integer}
    orda, ordb = ord(a0), ord(b0) 
    
    (orda < ordb) && return zero(a0), a0
    
    a, b = a0.coef, b0.coef
    q = zeros(T, orda - ordb + 1)
    r = copy(a)

    for i in (orda + 1):-1:(ordb + 1)
        if r[i] != 0
            coef = r[i] ÷ b[end]
            q[i - ordb] = coef
            for j in 0:ordb
                r[i - j] -= coef * b[end - j]
            end
        end
    end
    
    return (Polynomial{M, T}(q), Polynomial{M, T}(r))
end

Base.div(a::Polynomial{M, T}, b::Polynomial{M, T}) where {M, T} = divrem(a, b)[begin]
Base.mod(a::Polynomial{M, T}, b::Polynomial{M, T}) where {M, T} = divrem(a, b)[end]
Base.mod(a::Polynomial{M, T}, b::Tuple) where {M, T} = mod(a, Polynomial{M, T}(collect(b)))

function (iter::Polynomial{M, T})(arg) where {M, T}
    TT = promote_type(T, typeof(arg))
    polynom::TT = iter.coef[begin]

    for i in Iterators.drop(iter.coef, 1)
        polynom = polynom * arg + i
    end

    return polynom
end

# Создание вычетов
a = Residue{5}(6)  # 6 mod 5 = 1
b = Residue{5}(4)  # 4 mod 5 = 4

# Создание полиномов с целыми коэффициентами
P = Polynomial{1, Int} 
p1 = P([1, 2, 3])      
p2 = P([0, 1])         

# Операции с полиномами
println("Сложение: ", p1 + p2) 
println("Вычитание: ", p1 - p2) 
println("Умножение: ", p1 * p2)  
println("Значение в точке (x = 2): ", p1(2))  