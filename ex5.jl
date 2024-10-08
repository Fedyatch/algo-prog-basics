using HorizonSideRobots


function do_upora!(robot, side)
    n = 0::Int
    while !isborder(robot, side)
        move!(robot, side)
        n+=1
    end
    return n
end

function num_steps(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        n += 1
    end
    do_upora!(robot, inverse(side))
    return n
end

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

function printer!(robot)
    x = 0::Int
    y = 0::Int
    while !isborder(robot, Sud) || !isborder(robot, West)
        x += do_upora!(robot, West)
        y += do_upora!(robot, Sud)
    end
    h = num_steps(robot, Nord)
    side_1 = Ost
    side_3 = Nord
    for i in 1:h
        while !isborder(robot, side_1)
            for side_2 in (Sud, West, Nord, Ost)
                if isborder(robot, side_2)
                    putmarker!(robot)
                end
            end
            move!(robot, side_1)
        end
        if isborder(robot, side_1)
            putmarker!(robot)
        end
        if !isborder(robot, side_3)
            move!(robot, side_3)
        end
        side_1 = inverse(side_1)
    end
    side_3 = Sud
    for i in 1:h
        while !isborder(robot, side_1)
            for side_2 in (Sud, West, Nord, Ost)
                if isborder(robot, side_2)
                    putmarker!(robot)
                end
            end
            move!(robot, side_1)
        end
        if isborder(robot, side_1)
            putmarker!(robot)
        end
        if !isborder(robot, side_3)
            move!(robot, side_3)
        end
        side_1 = inverse(side_1)
    end
    for i in 1:y
        move!(robot, Nord)
    end
    for i in 1:x
        move!(robot, Ost)
    end
end

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

