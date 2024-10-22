using HorizonSideRobots

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

function prohod!(robot)

    side = Ost

    n = 1
    while isborder(robot, Nord)
        for i in 1:n
            move!(robot, side)
        end
        n += 1
        side = inverse(side)
    end
end

