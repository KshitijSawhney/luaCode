network={}
rednet.open("right")

function addTurtle()
    turtle.suckUp()
    turtle.place()
    local new_turtle=peripheral.warp("front")
    new_turtle.turnOn()
    local id,message = rednet.receive() --confirmation message upon successful startup
    if message == "added" then table.insert( network, id ) end
    rednet.broadcast(id,"moveTo 143 70 555")
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
            turtle.dig()
        elseif command[1]=="quarry" then
            quarry(tonumber(command[2]),tonumber(command[3]),tonumber(command[4]),tonumber(command[5]),tonumber(command[6]),tonumber(command[7]))
        end
    end
end