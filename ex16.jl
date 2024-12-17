#=
Решить задачу 7 с использованием обобщённой функции
shuttle!(stop_condition::Function, robot, side)

ДАНО: Робот - рядом с горизонтальной бесконечно продолжающейся в
обе стороны перегородкой (под ней), в которой имеется проход шириной в одну
клетку.

РЕЗУЛЬТАТ: Робот - в клетке под проходом
=#
using HorizonSideRobots

function find!(robot)
    shuttle!(robot, Nord) do side 
        !isborder(robot, side) 
    end
    
end

function shuttle!(stop_condition::Function, robot, side) 
    s = Ost
    n = 0 
    while !stop_condition(side) 
        move!(robot, s, n) 
        s = inverse(s) 
        n += 1 
    end 
end

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)
HorizonSideRobots.move!(robot, side, num_steps) = for i in 1:num_steps move!(robot, side) end

#shuttle!(robot, Nord) do side !isborder(robot, side) end