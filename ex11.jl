using HorizonSideRobots

function counter!(robot)
    num = 0
    s, w = 0, 0
    s += do_upora(robot, West)
    w += do_upora(robot, Sud)
    side = Ost
    while !isborder(robot, Nord) && !isborder(robot, side)
        num += numborders!(robot, side)
        side = inverse(side)
        move!(robot, Nord)
    end
    do_upora(robot, Sud)
    do_upora(robot, West)
    return num
end

function numborders!(robot, side)
    state = 0
    num_borders = 0
    while !isborder(robot, side)
        move!(robot, side)
        if state == 0
            (isborder(robot, Nord) == true) && (state = 1; num_borders += 1)

        elseif state == 1
            (isborder(robot, Nord)==false) && (state = 0)
        end
    end
    return num_borders
end

function do_upora(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        n += 1
    end
    return n
end

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)