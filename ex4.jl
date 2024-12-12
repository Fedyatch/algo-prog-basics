#=
ДАНО: Робот находится в произвольной клетке ограниченного
прямоугольного поля без внутренних перегородок и маркеров.

РЕЗУЛЬТАТ: Робот — в исходном положении в центре косого креста из
маркеров, расставленных вплоть до внешней рамки.
=#

using HorizonSideRobots

function cross!(robot, sides)
    for side in sides
        n = mark_line!(robot, side)
        for i in 1:n move!(robot, inverse(side)) end
    end
end

function mark_line!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
        n += 1
    end
    return n
end

HorizonSideRobots.move!(robot, side::Any) = for s in side move!(robot, s) end
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
inverse(side::NTuple{2, HorizonSide}) = inverse.(side)
HorizonSideRobots.isborder(robot, side::NTuple{2, HorizonSide}) = isborder(robot, side[1]) || isborder(robot, side[2])

#cross!(robot, ((Nord, Ost), (Ost, Sud), (Sud, West), (West, Nord)))