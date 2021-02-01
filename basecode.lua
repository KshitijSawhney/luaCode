--Program for the turtle to execute on startup
--
--------------------------------------------------------------
FIRST_FREE_SLOT = 4 --marks the first slot in the inventory
-- here is the breakdown of slots : {1:lava,2:empty buckets,3:items chest,4 to 16 : everything else}
TOTAL_SLOTS=16

function refuel()
    if turtle.getFuelLevel()==0 then
        while (turtle.detect()) do --makes space for chests even if it has to dig mulitiple blocks
            turtle.dig() 
        end
        turtle.select(1) -- select lava enderchest
        turtle.place()
        turtle.select(16) -- last slot specially for fuel
        turtle.suck() --get lava bucket
        turtle.refuel()
        turtle.select(1) -- lavachest slot
        turtle.dig()
        turtle.select(2) -- bucket chest slot
        turtle.place()
        turtle.select(16) --empty bucket
        turtle.drop() --puts bucket in enderchest
        turtle.select(2)
        turtle.dig()
        print(turtle.getFuelLevel())
    end
 end

 function invDump(first_slot)
    while (turtle.detect()) do --makes space for chests even if it has to dig mulitiple blocks
        turtle.dig() 
    end
    turtle.select(3)
    turtle.place()
    for i=TOTAL_SLOTS,first_slot,-1 do
        turtle.select(i)
        turtle.drop()
    end
    turtle.select(3)
    turtle.dig()
 end

rednet.open("right") -- open the wireless modem for communication
 while true do -- puts turtle into a waitloop for a message
    local id,message = rednet.receive()
    if message=="exit" then
        break
    elseif message =="dump" then
        invDump(FIRST_FREE_SLOT) 
    elseif message=="checkFuel" then
        invDump(FIRST_FREE_SLOT) --make sure invetory is empty to accept potential items
        refuel()
    end
 end