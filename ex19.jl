#=
Написать рекурсивную функцию, 
перемещающую робота до упора в заданном направлении.
=#

using HorizonSideRobots

function movetoend!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
    else
        return
    end
    movetoend!(robot, side)
end