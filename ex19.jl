using HorizonSideRobots

function movetoend!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
    else
        return
    end
    movetoend!(robot, side)
end

