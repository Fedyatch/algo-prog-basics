using HorizonSideRobots

mutable struct Coordinates
    x::Int
    y::Int
end

function move(coord::Coordinates, side::HorizonSide) 
    side == Nord && return Coordinates(coord.x, coord.y+1) 
    side == Sud && return Coordinates(coord.x, coord.y-1) 
    side == Ost && return Coordinates(coord.x+1, coord.y) 
    side == West && return Coordinates(coord.x-1, coord.y) 
end

mutable struct ChessRobot
    robot::Robot
    coord::Coordinates
end

function HorizonSideRobots.move!(robot::ChessRobot, side::HorizonSide) 
    x = mod(robot.coord.x, 2) 
    y = mod(robot.coord.y, 2) 
    (x == y) && putmarker!(robot.robot)
    move!(robot.robot, side)
    robot.coord = move(robot.coord, side)
end

HorizonSideRobots.isborder(robot::ChessRobot, side) = isborder(robot.robot, side)
HorizonSideRobots.putmarker!(robot::ChessRobot) = putmarker!(robot.robot)

function field!(robot::Robot)
    robot = ChessRobot(robot, Coordinates(0,0))
    corner!(robot, (Sud, West))
    snake!(robot, (Ost, Nord)) do side
        isborder(robot, side) && isborder(robot, Nord)
    end
end

function snake!(stop_condition::Function, robot, sides::NTuple{2, HorizonSide})
    s = sides[1]
    while !stop_condition(s)
        movetoend!(robot, s) do
            stop_condition(s) || isborder(robot, s)
        end
        if stop_condition(s)
            break
        end
        s = inverse(s)
        move!(robot, sides[2])
    end
end

movetoend!(stop_condition::Function, robot, side) = while !stop_condition() move!(robot, side) end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
inverse(side::NTuple{2, HorizonSide}) = inverse.(side)

function corner!(robot, sides::NTuple{2, HorizonSide})
    for s in sides 
        movetoend!(robot, s) do 
            isborder(robot, s)
        end
    end
end

