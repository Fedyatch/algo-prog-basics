using HorizonSideRobots

mutable struct ChessRobot
    robot::Robot
    flag::Bool
end

function HorizonSideRobots.move!(robot::ChessRobot, side)
    robot.flag && putmarker!(robot.robot)
    move!(robot.robot, side)
end

HorizonSideRobots.isborder(robot::ChessRobot, side) = isborder(robot.robot, side)

function corner(robot, side)
    robot.flag = !robot.flag
    for s in side 
        movetoend!(robot, s) 
    end
end

function perimeter!(robot)
    for s in (Nord, Ost, Sud, West)
        movetoend!(robot, s)
    end
end

function movetoend!(robot, side)
    while trymove!(robot, side) end
end

function trymove!(robot, side)
    isborder(robot, side) && return false
    move!(robot, side)
    return true
end

#corner(robot, (Sud, West)); robot = ChessRobot(robot, true); perimeter!(robot)