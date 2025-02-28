iter = []
function arraymaker(iter)
    randn = rand(-10:10,10)
    for i in randn
        push!(iter, i)
    end
    println(iter)
    return iter
end

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