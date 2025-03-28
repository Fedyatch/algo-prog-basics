function horner_scheme(coefficients, x0)
    n = length(coefficients)
    value = coefficients[end] #Начинаем с последнего коэффициента
    derivative = 0

    for i in (n-1):-1:1 # Идем от предпоследнего коэффициента к первому
        derivative = derivative * x0 + value
        value = value * x0 + coefficients[i]
    end
    return value, derivative
end

coefficients = [3, -1, 2, -5]  # Многочлен 3 - x + 2x^2 - 5x^3
x0 = 2
value, derivative = horner_scheme(coefficients, x0)
println("Значение многочлена в точке $x0: $value")
println("Значение производной в точке $x0: $derivative")