using HorizonSideRobots

function findmarker!(robot)::Nothing
    side = Nord
    max_nsteps = 0
    while !findmarker!(robot, side, max_nsteps)
        side = left(side)
        (side in (Nord, Sud) && (max_nsteps += 1))
    end
end

function findmarker!(robot, side, max_nsteps)::Bool
    for _ in 0:max_nsteps
        ismarker(robot) && return true
        move!(robot, side)
    end
    return ismarker(robot)
end

left(side::HorizonSide) = HorizonSide((Int(side)+1)%4)
