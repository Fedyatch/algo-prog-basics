using HorizonSideRobots

function per_cross!(robot)
    path = []
    num_sud = 0
    num_west = 0
    while !isborder(robot, West) || !isborder(robot, Sud)
        w = do_upora(robot, West)
        s = do_upora(robot, Sud)
        num_west += w 
        num_sud += s    
        push!(path, (s, w))
    end

    n = num_steps(robot, Nord)
    o = num_steps(robot, Ost)

    for side in (Nord, Ost, Sud, West)
        if side == Nord
            for i in 1:num_sud
                move!(robot, Nord)
            end
        elseif side == Ost
            for i in 1:num_west
                move!(robot, Ost)
            end
        elseif side == Sud
            for i in 1:(n-num_sud)
                move!(robot, Sud)
            end
        elseif side == West
            for i in 1:(n-num_west)
                move!(robot, West)
            end
        end

        putmarker!(robot)

        while !isborder(robot, side)
            do_upora!(robot, side)
        end
    end

    for p in reverse(path)
        n = p[1]
        o = p[2]

        for i in 1:n
            move!(robot, Nord)
        end
        for i in 1:o
            move!(robot, Ost)
        end
    end
end

function do_upora(robot, side)
    num_side = 0
    while !isborder(robot, side)
        num_side += 1
        move!(robot, side)
    end
    return num_side 
end

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

function num_steps(robot, side)
    num_side = 0
    while !isborder(robot, side)
        move!(robot, side)
        num_side += 1
    end
    do_upora!(robot, inverse(side))
    return num_side
end

function do_upora!(robot, side)
    while !isborder(robot, side)
        move!(robot, side)
    end
end



