network={}
rednet.open("right")
MAX_DIG_SLICE = 4
num_turtles=0

function tablefind(tab,el)
    for index, value in pairs(tab) do
        if value == el then
            return index
        end
    end
end

function addTurtle()
    turtle.suckUp()
    turtle.place()
    local new_turtle=peripheral.wrap("front")
    new_turtle.turnOn()
    local id,message = rednet.receive() --confirmation message upon successful startup
    if message == "added" then 
        table.insert( network, id ) 
        print("added ".. id)
        os.sleep(1)
        rednet.broadcast(tostring(id) .. " moveTo 143 70 555")
        os.sleep(10)
        return id
    end
    
end

function removeTurtle(id)
    turtle.dig()
    table.remove(network, tablefind(network, id))    
end

function max(t, fn)
    if #t == 0 then return nil, nil end
    local key, value = 1, t[1]
    for i = 2, #t do
        if fn(value, t[i]) then
            key, value = i, t[i]
        end
    end
    return key
end

function getNumTurtles(volume)
    local n = math.ceil(volume % MAX_DIG_SLICE)
    if n > 27 then 
        MAX_DIG_SLICE=MAX_DIG_SLICE+1
        getNumTurtles(volume)
    else
        return n
    end
end

function assignDig(n, x1,y1,z1,x2,y2,z2, max_dim_index)
    while n>0 do
        local new_turtle_ID = addTurtle()
        n=n-1
        local new_turtle_ID=network[table.getn(network)]
        if max_dim_index == 1 then
            rednet.broadcast(new_turtle_ID .. " mine " .. tostring(x1)+" ".. tostring(y1).." ".. tostring(z1).." ".. tostring(x1+MAX_DIG_SLICE-1).." ".. tostring(y2).." ".. tostring(z2))
            if x1+MAX_DIG_SLICE<x2 then x1=x1+MAX_DIG_SLICE end
        elseif max_dim_index == 2 then
            rednet.broadcast(new_turtle_ID .. " mine " .. tostring(x1)+" ".. tostring(y1).." ".. tostring(z1).." ".. tostring(x2).." ".. tostring(y1-MAX_DIG_SLICE+1).." ".. tostring(z2))
            if y1-MAX_DIG_SLICE>y2 then y1=y1-MAX_DIG_SLICE end
        elseif max_dim_index == 3 then
            rednet.broadcast(new_turtle_ID .. " mine " .. tostring(x1).." ".. tostring(y1).." ".. tostring(z1).." ".. tostring(x2).." ".. tostring(y2).." ".. tostring(z1+MAX_DIG_SLICE-1))
            if z1+MAX_DIG_SLICE<z2 then z1=z1+MAX_DIG_SLICE end
        end
    end
end

function quarry(x1,y1,z1,x2,y2,z2)
    print("quarry request")
    local dims = {(math.abs(x1-x2)+1),(math.abs(y1-y2)+1),(math.abs(z1-z2)+1)}
    local quarry_volume =dims[1]*dims[2]*dims[3]
    local num_turtles=getNumTurtles(quarry_volume)
    local max_dim_index= max(dims, function(a,b) return a < b end)
    local topx,topy,topz,bottomx,bottomy,bottomz = math.min(x1,x2),math.max(y1,y2),math.min(z1,z2),math.max(x1,x2),math.min(y1,y2),math.max(z1,z2)
    print("assigning ".. num_turtles.."turtles")
    assignDig(num_turtles , topx,topy,topz,bottomx,bottomy,bottomz, max_dim_index)
end

--[[mainloop for master]]
while true do
    local id,message = rednet.receive()
    command = {}
    for word in message:gmatch("%w+") do table.insert(command, word) end
    if command[1]=="master" then
        table.remove(command,1)
        if command[1]=="exit" then
            break
        elseif command[1]=="add" then
            addTurtle()
        elseif command[1]=="remove" then
            removeTurtle(id)
        elseif command[1]=="quarry" then
            quarry(tonumber(command[2]),tonumber(command[3]),tonumber(command[4]),tonumber(command[5]),tonumber(command[6]),tonumber(command[7]))
        end
    end
end
