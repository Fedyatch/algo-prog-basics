#=
11. ДАНО: Робот - в произвольной клетке ограниченного прямоугольного
поля, на поле расставлены горизонтальные перегородки различной длины
(перегородки длиной в несколько клеток, считаются одной перегородкой), не
касающиеся внешней рамки.
РЕЗУЛЬТАТ: Робот — в исходном положении, подсчитано и возвращено
число всех перегородок на поле.
=#

using HorizonSideRobots

function numbord!(robot)
    n = 0
    s, w = 0, 0
    s += do_upora(robot, Sud)
    w += do_upora(robot, West)
    side = Ost
    while !isborder(robot, Nord) && !isborder(robot, side)
        n += numborders!(robot, side)
        if !isborder(robot, Nord)
            move!(robot, Nord)
        end
        side = inverse(side)
    end
    
    return n
end

function numborders!(robot, side)
    state = 1
    num_borders = 1
    while !isborder(robot, side)
        move!(robot, side)
        if state == 0
            (isborder(robot, Nord) == true) && (state = 1; num_borders += 1)
        elseif state == 1
            (isborder(robot, Nord) == false) && (state = 0)
        end
    end
    return num_borders
end

function do_upora(robot, side)
    num = 0
    while !isborder(robot, side)
        move!(robot, side)
        num += 1
    end
    return num
end

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

#numbord!(robot)