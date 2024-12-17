#=
ДАНО: Робот находится в произвольной клетке ограниченного
прямоугольного поля без внутренних перегородок и маркеров.

РЕЗУЛЬТАТ: Робот — в исходном положении в центре косого креста из
маркеров, расставленных вплоть до внешней рамки.
=#

using HorizonSideRobots

function cross!(robot, sides)
    for side in sides
        n = mark_line!(robot, side)
        for i in 1:n move!(robot, inverse(side)) end
    end
end

function mark_line!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
        n += 1
    end
    return n
end

HorizonSideRobots.move!(robot, side::Any) = for s in side move!(robot, s) end
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
function inverse(side::NTuple{2, HorizonSide})
    inverse.(side)
end
HorizonSideRobots.isborder(robot, side::NTuple{2, HorizonSide}) = isborder(robot, side[1]) || isborder(robot, side[2])

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

#cross!(robot, ((Nord, Ost), (Ost, Sud), (Sud, West), (West, Nord)))