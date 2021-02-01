--Program for the turtle to execute on startup
--
--------------------------------------------------------------
FIRST_FREE_SLOT = 4 --marks the first slot in the inventory
-- here is the breakdown of slots : {1:lava,2:empty buckets,3:items chest,4 to 16 : everything else}
TOTAL_SLOTS=16

function refuel()
    if turtle.getFuelLevel()==0 then
        while (not turtle.placeUp()) do --makes space for chests even if it has to dig mulitiple blocks
            turtle.digUp() 
        end
        turtle.select(1) -- select lava enderchest
        turtle.placeUp()
        turtle.select(16) -- last slot specially for fuel
        turtle.suckUp() --get lava bucket
        turtle.refuel()
        turtle.select(1) -- lavachest slot
        turtle.digUp()
        turtle.select(2) -- bucket chest slot
        turtle.placeUp()
        turtle.select(16) --empty bucket
        turtle.dropUp() --puts bucket in enderchest
        turtle.select(2)
        turtle.digUp()
        print(turtle.getFuelLevel())
    end
 end

 function invDump(first_slot)
    while (not turtle.placeUp()) do --makes space for chests even if it has to dig mulitiple blocks
        turtle.digUp() 
    end
    turtle.select(3)
    turtle.placeUp()
    for i=TOTAL_SLOTS,first_slot,-1 do
        turtle.select(i)
        turtle.dropUp()
    end
    turtle.select(3)
    turtle.digUp()
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