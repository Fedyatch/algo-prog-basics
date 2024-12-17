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

HorizonSideRobots.move!(robot::ChessRobot, side, nsteps::Integer) = for _ in 1:nsteps move!(robot, side) end
HorizonSideRobots.isborder(robot::ChessRobot, side) = isborder(robot.robot, side)
HorizonSideRobots.putmarker!(robot::ChessRobot) = putmarker!(robot.robot)

function field!(robot::Robot)
    corner!(robot, (Sud, West))
    robot = ChessRobot(robot, Coordinates(0,0))
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

movetoend!(stop_condition::Function, robot, side) = while !stop_condition() trymove!(robot, side) end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
inverse(side::NTuple{2, HorizonSide}) = inverse.(side)

HorizonSideRobots.move!(robot::ChessRobot, side, nsteps::Integer) = for _ in 1:nsteps move!(robot, side) end

function corner!(robot, sides::NTuple{2, HorizonSide})
    for s in sides 
        movetoend!(robot, s) do 
            isborder(robot, s)
        end
    end
end

function nummovetoend!(stop_condition::Function, robot, side)
    n=0
    while !stop_condition()
        move!(robot, side)
        n+=1
    end
    return n
end

function trymove!(robot, side)::Bool 
    nsteps = nummovetoend!(robot, right(side)) do 
        !isborder(robot, side) || isborder(robot, right(side)) #-условие останова 
    end 
    if !isborder(robot, side) # => обойти препятствие возможно 
        move!(robot, side) 
        if nsteps > 0 # => робот находится "в состоянии обхода" 
            movetoend!(robot, side) do # - проход через толщу препятсятвия 
                !isborder(robot, left(side)) 
            end 
        end # иначе надо ограичиться только одним шагом в направлении side
        result = true 
    else # isborder(robot, right(side)) => обход препятствия не возможен 
        result = false 
    end 
    move!(robot, left(side), nsteps) 
    # робот перемещен в направленн обратном тому, в котором он обходил или пытался 
    #обойти препятствие 
    return result 
end

left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side)+3, 4))