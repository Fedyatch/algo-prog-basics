using HorizonSideRobots

function move_border!(robot, side)
    !isborder(robot, side)&&(move!(robot, side); return)
    move!(robot, right(side))
    move_border!(robot, side)
    move!(robot, left(side))
end

right(side::HorizonSide) = HorizonSide((Int(side)+3)%4)
left(side::HorizonSide) = HorizonSide((Int(side)+1)%4)