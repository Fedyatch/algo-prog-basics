#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного
поля

РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля
промаркированы.
=#

using HorizonSideRobots

function snake!(stop_condition::Function, robot, sides::NTuple{2, HorizonSide})
    s = sides[1]
    while !stop_condition(s)
        movetoend!(robot, s) do
            stop_condition(s) || isborder(robot, s)
        end
        if stop_condition(s)
            putmarker!(robot)
            break
        end
        s = inverse(s)
        putmarker!(robot)
        move!(robot, sides[2])
    end
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
inverse(sides::NTuple{2, HorizonSide}) = inverse.(side)

movetoend!(stop_condition::Function, robot, side, flag::Bool) = while !stop_condition() flag&&putmarker!(robot); move!(robot, side) end

function corner!(robot, sides::NTuple{2, HorizonSide})
    for s in sides
        movetoend!(robot, s, false) do
            isborder(robot, s)
        end
    end
end

#=
corner(robot, (West, Sud)); snake!(robot, (Ost,Nord)) do s isborder(robot,s)&&isborder(robot,Nord) end
=#