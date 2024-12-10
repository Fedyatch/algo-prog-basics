using HorizonSideRobots

function movetomark!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
    else
        putmarker!(robot)
        movetoend!(robot, inverse(side))
        return
    end
    movetomark!(robot, side)
end

function movetoend!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
    else
        return
    end
    movetoend!(robot, side)
end

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)