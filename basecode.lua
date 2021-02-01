--Program for the turtle to execute on startup
rednet.open("right") -- open the wireless modem for communication
 while true do -- puts turtle into a waitloop for a message
    local id,message = rednet.receive()
    if message=="exit" then
        break
    elseif message=="checkFuel" then
        shell.run(refuel)
    end
 end