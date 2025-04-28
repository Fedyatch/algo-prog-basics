# Задание 1
iter = []
function arraymaker(iter)
    randn = rand(-10:10,10)
    for i in randn
        push!(iter, i)
    end
    println(iter)
    return iter
end



function maxsum(iter)
    arraymaker(iter)
    mx = 0
    sum = 0
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

println(maxsum(iter))