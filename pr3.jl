coefficients = [3, 4, 5, 8, 9]

function polynom(coefficients::Vector{T}, x::S) where {T,S}
    R = promote_type(T, S)
    result = zero(R)
    for coeff in coefficients
        result = result*x + coeff
    end
    return result
end

coefficients = [2.0, -1.0, 3.0, 1.0]
x = 2.0
value = polynom(coefficients, x)
println(value)