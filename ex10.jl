using HorizonSideRobots

function chess!(robot, N)

    s, w = 0, 0
    s += do_upora(robot, Sud)
    w += do_upora(robot, West)

    side = Ost
    flag = false
    for i in 1:N
        !flag && putmarker!(robot)
        for j in 1:(N)
            move!(robot, side)
            flag && putmarker!(robot)
            flag = !flag
        end
        flag = !flag
        side = inverse(side)
        move!(robot, Nord)
    end
    do_upora(robot, Sud)
    do_upora(robot, West)
    for i in 1:w
        move!(robot, Ost)
    end
    for j in 1:s
        move!(robot, Nord)
    end
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

