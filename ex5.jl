#=
ДАНО: На ограниченном внешней прямоугольной рамкой поле имеется
ровно одна внутренняя перегородка в форме прямоугольника. Робот - в
произвольной клетке поля между внешней и внутренней перегородками.
РЕЗУЛЬТАТ: Робот - в исходном положении и по всему периметру
внутренней, как внутренней, так и внешней, перегородки поставлены маркеры
=#

using HorizonSideRobots

mutable struct MarkRobot
    robot::Robot
end

function mark!(robot::MarkRobot)
    corner!(robot, (Sud, West))
    snake!(robot, (Ost, Nord)) do side
        isborder(robot, side) && isborder(robot, Nord)
    end
    move!(robot, Sud)
    snake!(robot, (West, Sud)) do side
        isborder(robot, side) && isborder(robot, Sud)
    end
end

function HorizonSideRobots.move!(robot::MarkRobot, side::HorizonSide) 
    if isborder(robot, Nord) || isborder(robot, Ost) || isborder(robot, Sud) || isborder(robot, West)
        putmarker!(robot)
    end
    move!(robot.robot, side)
end

function snake!(stop_condition::Function, robot::MarkRobot, sides::NTuple{2, HorizonSide})
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
        move!(robot, sides[2])
    end
end

movetoend!(stop_condition::Function, robot, side) = while !stop_condition() move!(robot, side) end

function corner!(robot, sides::NTuple{2, HorizonSide})
    while !isborder(robot, sides[1]) || !isborder(robot, sides[2])
        movetoend!(robot, sides[1]) do
            isborder(robot, sides[1])
        end
        movetoend!(robot, sides[2]) do
            isborder(robot, sides[2])
        end
    end
end

HorizonSideRobots.isborder(robot::MarkRobot, side) = isborder(robot.robot, side)
HorizonSideRobots.putmarker!(robot::MarkRobot) = putmarker!(robot.robot)
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
inverse(sides::NTuple{2, HorizonSide}) = inverse.(side)